import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:udp/udp.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void pushEdited(
    {required BuildContext context,
    required ConnectionInterface connectionInterface,
    required String namedRoute}) {
  ConnectionHandler.resetInterface();
  Navigator.pushNamed(context, namedRoute).then((value) {
    ConnectionHandler.setInterface(connectionInterface);
  });
}

void popEdited(BuildContext context) {
  ConnectionHandler.resetInterface();
  Navigator.pop(context);
}

class ConnectionInterface {
  void listen(data) {}
  void interrupted(data) {}
  void connected() {}
}

class ConnectionHandler {
  static late ConnectionInterface connectionInterface;
  static final ConnectionInterface _connectionInterface = ConnectionInterface();

  static void setInterface(ConnectionInterface ci) => connectionInterface = ci;
  static void resetInterface() => connectionInterface = _connectionInterface;

  static late WebSocketChannel _channel;
  static late StreamSubscription _stream;
  static bool isWebsocketCreated = false;

  static late UDP receiver;
  static late StreamSubscription _streamUDP;
  static bool isUDPCreated = false;

  static void closeWebsocket() {
    if (!isWebsocketCreated) return;
    _channel.sink.close();
    _stream.cancel();
    isWebsocketCreated = false;
  }

  static void connectWebSocket({String ipaddress = '192.168.4.1'}) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse('ws://$ipaddress/ws'));
      _stream = _channel.stream.listen((data) {
        connectionInterface.listen(data);
      }, onError: (e) {
        closeWebsocket();
        connectionInterface.interrupted(e.toString());
      }, onDone: () {
        closeWebsocket();
        connectionInterface.interrupted("done websocket");
      }, cancelOnError: true);

      isWebsocketCreated = true;
    } catch (e) {
      closeWebsocket();
      connectionInterface.interrupted(e.toString());
    }
  }

  static void closeUDP() {
    if (!isUDPCreated) return;

    _streamUDP.cancel();
    receiver.close();
    isUDPCreated = false;
  }

  static connectUDP() async {
    try {
      if (isWebsocketCreated) return;
      var multiCast = Endpoint.multicast(InternetAddress("239.1.2.3"),
          port: const Port(54321));

      receiver = await UDP.bind(multiCast);

      _streamUDP = receiver.asStream().listen((data) {
        if (data == null) return;
        var str = String.fromCharCodes(data.data);
        var substr = str.toString().substring(4);

        var r = RegExp(r"^(\d{1,3}\.){3}\d{1,3}$");
        if (!r.hasMatch(substr)) return;

        ConnectionHandler.closeUDP();
        ConnectionHandler.connectWebSocket(ipaddress: substr);
      }, onError: (e) {
        closeUDP();
        connectionInterface.interrupted(e.toString());
      }, onDone: () {
        closeUDP();
        connectionInterface.interrupted("on done");
      }, cancelOnError: true);

      isUDPCreated = true;
      connectionInterface.connected();
    } catch (e) {
      closeUDP();
      connectionInterface.interrupted(e.toString());
    }
  }

  static void dispose() {
    closeWebsocket();
    closeUDP();
  }
}
