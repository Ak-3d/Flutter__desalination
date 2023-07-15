import 'dart:async';
import 'dart:io';

import 'package:udp/udp.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionHandler{
  static late WebSocketChannel _channel;
  static late StreamSubscription _stream;
  static bool isWebsocketCreated = false;

  static late UDP receiver;
  static late StreamSubscription _streamUDP;
  static bool isUDPCreated = false;

  static void listen(data){

  }
  static void interrupted(data){

  }
  static void connected(){

  }
  static void closeWebsocket(){
    if(!isWebsocketCreated) return;
    _channel.sink.close();
    _stream.cancel();
    isWebsocketCreated = false;
  }
  static void connectWebSocket(
      { String ipaddress = 'ws://192.168.4.1/ws',
        Function listen = listen,
        Function interrupted = interrupted}){
    try {

      _channel = WebSocketChannel.connect(
          Uri.parse('ws://${ipaddress}/ws')
      );
      _stream = _channel.stream.listen((data) {
        listen(data);
      }, onError: (e) {

        ///TODO Show Error Message
        closeWebsocket();
        interrupted(e.toString());
      },onDone: () {
        closeWebsocket();
        interrupted("done websocket");
      },cancelOnError: true);

      isWebsocketCreated = true;
    }catch(e){
      closeWebsocket();
      interrupted(e.toString());
    }
  }

  static void closeUDP(){
    if(!isUDPCreated) return;
    _streamUDP.cancel();
    receiver.close();
    isUDPCreated = false;
  }
  static Future<void> connectUDP(
      { Function listen = listen,
        Function interrupted = interrupted,
        Function connected = connected}) async{
    try {
      var multiCast =
      // Endpoint.broadcast(port: const Port(54321));
      // Endpoint.multicast(InternetAddress("239.1.2.3"), port: const Port(54321));
      Endpoint.multicast(InternetAddress("0.0.0.0"), port: const Port(53));

      receiver = await UDP.bind(multiCast);
      _streamUDP = receiver.asStream().listen((data) {
        if(data != null) {
          var str = String.fromCharCodes(data.data);
          listen(str);
        }
      }, onError: (e) {
        closeUDP();
        interrupted(e.toString());
      },onDone: () {
        closeUDP();
        interrupted("on done");
      },cancelOnError: true);
      isUDPCreated = true;
      connected();
      return;
    }catch(e){
      closeUDP();
      interrupted(e.toString());
    }
  }

  static void dispose(){
    closeWebsocket();
    closeUDP();
  }
}