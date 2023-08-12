import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:udp/udp.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionInterfaceWrapper {
  late StreamSubscription _streamSubscription;
  static int debugInterfaces = 0;
  void setInterface(ConnectionInterface ci) {
    try {
      _streamSubscription =
          FlutterBackgroundService().on('update').listen((data) {
        if (data == null) return;
        var map = _convertMap(data['data']);
        ci.listen(map);
      }, cancelOnError: true);
      debugInterfaces += 1;//not perfect but will do to debug
      debugPrint('added, interfaces:$debugInterfaces');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void dispose() {
    debugInterfaces -=1;
    debugPrint('closed, interfaces:$debugInterfaces');
    _streamSubscription.cancel();
  }

  Map<String, dynamic> _convertMap(String data) {
    Map<String, dynamic> map = {};
    var objs = data.toString().split('|');
    for (var o in objs) {
      if (o == '') continue;
      var obj = o.split('=');
      map.addAll({obj[0]: _getObj(obj[1])});
    }
    return map;
  }

  Map<String, dynamic> _getObj(String objStr) {
    Map<String, dynamic> obj = {};
    var objs = objStr.split(',');
    for (var element in objs) {
      obj.addAll(_getPair(element));
    }
    return obj;
  }

  Map<String, dynamic> _getPair(String pairStr) {
    var pair = pairStr.split(':');
    return {pair[0]: pair[1]};
  }
}

class ConnectionInterface {
  void listen(Map<String, dynamic> data) {}
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
