import 'dart:async';
import 'dart:io';
import 'package:final_project/Models/Power.dart';
import 'package:final_project/Models/Production.dart';
import 'package:final_project/Models/SingleTank.dart';
import 'package:final_project/main.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:udp/udp.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum ObjName {
  liveTank,
  power,
  production,
  pumpsAndValves,
}

enum SingleTanksData { port, level, isFilling }

enum ProductionData { tds, temperature, preFlow, conFlow }

enum ActutureStatusData {
  drinkValve,
  plantValve,
  nullSpace,
  drinkPump,
  plantPump,
  mainPump
}

enum PowerData {
  voltageIn,
  currentIn,
  currentOut,
  duration,
  batteryLevel,
  isBattery
}

enum ConnectionStatus {
  connected,
  listen,
  disconnected,
}

class ConnectionInterfaceWrapper {
  late StreamSubscription _streamSubscription;
  static int debugInterfaces = 0;

  static void defaultInterface() {
    FlutterBackgroundService().on('update').listen((data) {
      if (data == null) return;
      try {
        var event = data['event'];
        if (event != null) {
        } else {
          var map = _convertMap(data['data']);

          final prodMap = map[ObjName.production.index];
          if (prodMap != null) {
            Production p = Production(
              double.parse(prodMap[ProductionData.tds.index]),
              double.parse(prodMap[ProductionData.conFlow.index]),
              double.parse(prodMap[ProductionData.preFlow.index]),
              double.parse(prodMap[ProductionData.temperature.index]),
            );
            objectbox.production.put(p);
          }

          final powerMap = map[ObjName.power.index];
          if (powerMap != null) {
            Power p = Power(
                double.parse(powerMap[PowerData.voltageIn.index]),
                double.parse(powerMap[PowerData.currentIn.index]),
                double.parse(powerMap[PowerData.currentOut.index]),
                double.parse(powerMap[PowerData.batteryLevel.index]),
                powerMap[PowerData.isBattery.index]?.toString() == '1',
                double.parse(powerMap[PowerData.duration.index]).toInt());
            objectbox.power.put(p);
          }

          final liveTankMap = map[ObjName.liveTank.index];
          if (liveTankMap != null) {
            List<SingleTank> ss = [];
            for (var tank in liveTankMap) {
              SingleTank s = SingleTank(
                  double.parse(tank[SingleTanksData.level.index]),
                  tank[SingleTanksData.level.index].toString() == '1');

              int portNumber = int.parse(tank[SingleTanksData.port.index]);
              int tankId = objectbox.tanks
                  .query(Tanks_.portNumber.equals(portNumber))
                  .build()
                  .findIds()[0];

              s.tanks.targetId = tankId;
              ss.add(s);
            }
            objectbox.singleTank.putMany(ss);
          }
        }
      } catch (e) {
        debugPrint('Model Interface: ${e.toString()}');
      }
    }, cancelOnError: true);
  }

  void setInterface(ConnectionInterface ci) {
    try {
      _streamSubscription =
          FlutterBackgroundService().on('update').listen((data) {
        if (data == null) return;
        try {
          var stat = data['event'];
          if (stat != null) {
            if (stat == '${ConnectionStatus.connected.index}') {
              ci.connected();
            } else if (stat == '${ConnectionStatus.disconnected.index}') {
              ci.interrupted('done');
            }
          } else {
            var map = _convertMap(data['data']);
            ci.listen(map);
          }
        } catch (e) {
          debugPrint('expInterface: ${e.toString()}');
        }
      }, cancelOnError: true);
      debugInterfaces += 1; //not perfect but will do to debug
      debugPrint('added, interfaces:$debugInterfaces');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void dispose() {
    debugInterfaces -= 1;
    debugPrint('closed, interfaces:$debugInterfaces');
    _streamSubscription.cancel();
  }

  static Map<int, dynamic> _convertMap(String data) {
    Map<int, dynamic> map = {};
    var objs = data.toString().split('|');
    List<Map<int, dynamic>> tanks = [];

    // int tan = 0;
    for (var o in objs) {
      if (o == '') continue;

      var obj = o.split('=');
      if (obj[0] == '${ObjName.liveTank.index}') {
        tanks.add(_getObj(obj[1]));
        //map.addAll({obj[0]: _getObj(obj[1])});
      } else {
        map.addAll({int.parse(obj[0]): _getObj(obj[1])});
      }
    }
    if (tanks.isNotEmpty) {
      map.addAll({ObjName.liveTank.index: tanks});
    }
    return map;
  }

  static Map<int, dynamic> _getObj(String objStr) {
    Map<int, dynamic> obj = {};
    var objs = objStr.split(',');
    for (var element in objs) {
      obj.addAll(_getPair(element));
    }
    return obj;
  }

  static Map<int, dynamic> _getPair(String pairStr) {
    var pair = pairStr.split(':');
    int a = int.parse(pair[0]);
    return {a: pair[1]};
  }
}

class ConnectionInterface {
  void listen(Map<int, dynamic> data) {}
  void interrupted(data) {}
  void connected() {}
}

class ConnectionHandler {
  late WebSocketChannel _channel;
  // late StreamSubscription _stream;
  bool isWebsocketCreated = false;

  late UDP receiver;
  // late StreamSubscription _streamUDP;
  bool isUDPCreated = false;

  void closeWebsocket() {
    if (!isWebsocketCreated) return;

    isWebsocketCreated = false;
    _channel.sink.close();
  }

  Stream<dynamic>? connectWebSocket({String ipaddress = '192.168.4.1'}) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse('ws://$ipaddress/ws'));
      isWebsocketCreated = true;
      return _channel.stream;
    } catch (e) {
      closeWebsocket();
      return null;
    }
  }

  void closeUDP() {
    if (!isUDPCreated) return;

    isUDPCreated = false;
    receiver.close();
  }

  Future<Stream<dynamic>?> connectUDP() async {
    try {
      if (isWebsocketCreated) return null;

      var multiCast = Endpoint.multicast(InternetAddress("239.1.2.3"),
          port: const Port(54321));

      receiver = await UDP.bind(multiCast);
      isUDPCreated = true;
      return receiver.asStream();
    } catch (e) {
      closeUDP();
      return null;
    }
  }

  void sendWebsocket(String msg) {
    if (!isWebsocketCreated) return;
    _channel.sink.add(msg);
  }

  void dispose() {
    closeWebsocket();
    closeUDP();
  }
}
