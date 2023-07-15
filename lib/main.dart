import 'dart:async';
import 'dart:io';
import 'package:udp/udp.dart';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:final_project/ConnectionHandler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
  super.key,
  required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  String status = "";
  String foundIP = "";
  String datagramUDP = "";
  String connectedIP = "";
  String msgs = "";

  String errTxt = "";
  int _num = 0;
  String debugTxt = "";

  late StreamSubscription _stream;
  late UDP receiver;

  void listenWebsocket(data){
    setState(() {
      status = "Connected and Receiving messages";
      connectedIP = foundIP;
      msgs += '${data.toString()}\n';
    });
  }
  void listenUDP(data){
    var r = RegExp(r"^(\d{1,3}\.){3}\d{1,3}$");
    var substr = data.toString().substring(4);
    setState(() {
      status = "Searching UDP multicast";
      datagramUDP = data;
    });

    if(r.hasMatch(substr)){
      setState(() {
        status = "trying to Connect to potential IP";
        foundIP = substr;
      });
      ConnectionHandler.closeUDP();
      ConnectionHandler.connectWebSocket(ipaddress: substr,listen: listenWebsocket, interrupted: inturWebsocket);
    }
  }
  void inturUDP(intur){
    setState(() {
      status = "Error in UDP connection";
      errTxt = "Error UDP: $intur";
      ConnectionHandler.dispose();
    });
  }
  void inturWebsocket(intur){
    setState(() {
      status = "Error in Websocket connection";
      errTxt = intur;
      ConnectionHandler.dispose();
    });
  }
  void clearMsg(){
    datagramUDP = "";
    connectedIP = "";
    // msgs = "";
  }

  @override
  void initState() {
    super.initState();
    // ConnectionHandler.connectWebSocket(listen: listenWebsocket);
    // ConnectionHandler.connectUDP(listen: listenUDP, interrupted: inturUDP);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            Text("status: $status"),
            Text("UDP datagram found: $datagramUDP"),
            Text("Connected to: $connectedIP"),
            Text("Receiving: \n$msgs"),
            Text("debug: $debugTxt"),
            Text("Error: $errTxt"),

          ],
        ),
      ),
      bottomSheet: Container(
        child: TextButton(
          child: const Text('reconnect'),
          onPressed: (){
            if(ConnectionHandler.isWebsocketCreated || ConnectionHandler.isUDPCreated) {
              setState(() {
                status = "Connection is off";
              });
              clearMsg();
              ConnectionHandler.dispose();
            }else{
              ConnectionHandler.connectUDP(listen: listenUDP, interrupted: inturUDP, connected: (){
                setState(() {
                  status = "Connected successfully";
                });
              }).then((value) {
                setState(() {
                  status = "Connecting to UDP";
                });
              });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // if(!ConnectionHandler.isWebsocketCreated) {
          //   ConnectionHandler.connectWebSocket(
          //       listen: listenWebsocket, interrupted: inturUDP);
          // }
          // else {
          //   ConnectionHandler.closeWebsocket();
          //   setState(() {
          //     errTxt = "done";
          //   });
          // }
        },//_sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    super.dispose();
    ConnectionHandler.dispose();
  }
}