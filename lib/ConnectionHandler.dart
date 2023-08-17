import 'dart:async';
import 'dart:io';
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

enum PumpsAndValvesData {
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

class ConnectionInterfaceWrapper {
  late StreamSubscription _streamSubscription;
  static int debugInterfaces = 0;
  // static Map<String, dynamic> data = {};

  void setInterface(ConnectionInterface ci) {
    try {
      _streamSubscription =
          FlutterBackgroundService().on('update').listen((data) {
        if (data == null) return;
        var map = _convertMap(data['data']);
        ci.listen(map);
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

  Map<int, dynamic> _convertMap(String data) {
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

  Map<int, dynamic> _getObj(String objStr) {
    Map<int, dynamic> obj = {};
    var objs = objStr.split(',');
    for (var element in objs) {
      obj.addAll(_getPair(element));
    }
    return obj;
  }

  Map<int, dynamic> _getPair(String pairStr) {
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
