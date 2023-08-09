import 'dart:async';
import 'dart:io';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:udp/udp.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionInterfaceWrapper {
  StreamSubscription? _streamSubscription;
  void setInterface(ConnectionInterface ci) {
    _streamSubscription = FlutterBackgroundService().on('update').listen(
        (data) {
      ci.listen(data?['data']);
    },
        onError: (er) => ci.interrupted(er),
        onDone: () => ci.interrupted('done'),
        cancelOnError: true);
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}

class ConnectionInterface {
  void listen(data) {}
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
