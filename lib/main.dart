import 'dart:async';
import 'package:final_project/Resources.dart';
import 'package:flutter/rendering.dart';
import 'package:udp/udp.dart';

import 'package:flutter/material.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: const MyHomePage(
        title: title,
      ),
      darkTheme: ThemeData.dark(),
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
  double value = 0;

  void listenWebsocket(data){
    setState(() {
      status = "Connected and Receiving messages";
      connectedIP = foundIP;
      msgs = '${data.toString()}\n';
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
    ConnectionHandler.connectUDP(listen: listenUDP, interrupted: inturUDP, connected: (){
                    setState(() {
                      status = "Connected successfully";
                    });
                  }).then((value) {
                    setState(() {
                      status = "Connecting to UDP";
                    });
                  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Resources.bgcolor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Resources.bgcolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children:  [
            StaggeredGrid.count(
              crossAxisCount: 6,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              
              children: [
                CardDash(txt: status, cols: 6,),
                CardDash(txt: status),
                CardDash(txt: status),

                CardDash(txt: status),
                CardDash(txt: status),


                CardDash(txt: status, rows: 2, widget:
                Slider(value: value,min: 0, max: 100, onChanged: (v){
                   setState(() {
                     value = v;
                   });
                 }),),
                CardDash(txt: msgs, rows: 3, cols: 6, widget: TankCard(v1: value, v2: value),),
                CardDash(txt: status, rows: 2,),
              ],
            ),
          ]
        ),
      ),
      bottomSheet: Container(
        child: Row(
          children: [
            TextButton(
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
              // Form(
              //   child: TextFormField(
              //     controller: _controller,
              //     decoration: const InputDecoration(labelText: 'Send a message'),
              //   ),
              // ),
              // const SizedBox(height: 24),
              // Text("status: $status"),
              // Text("UDP datagram found: $datagramUDP"),
              // Text("Connected to: $connectedIP"),
              // Text("Receiving: \n$msgs"),
              // Text("debug: $debugTxt"),
              // Text("Error: $errTxt"),
            ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     // if(!ConnectionHandler.isWebsocketCreated) {
      //     //   ConnectionHandler.connectWebSocket(
      //     //       listen: listenWebsocket, interrupted: inturUDP);
      //     // }
      //     // else {
      //     //   ConnectionHandler.closeWebsocket();
      //     //   setState(() {
      //     //     errTxt = "done";
      //     //   });
      //     // }
      //   },//_sendMessage,
      //   tooltip: 'Send message',
      //   child: const Icon(Icons.send),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
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

class CardDash extends StatelessWidget {
  const CardDash({Key? key, 
                  this.txt = "card",
                  this.color = Resources.bgcolor_100,
                  this.cols = 3,
                  this.rows = 2,
                  this.widget = const Text('')}) : super(key: key);

  final String txt;
  final Color color; 
  final int cols;
  final int rows;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
        crossAxisCellCount: cols,
        mainAxisCellCount: rows,
        child: Container(
          decoration: const BoxDecoration(
              color: Resources.bgcolor_100,
              borderRadius:  BorderRadius.all(Radius.circular(20)),
              boxShadow:  [
                BoxShadow(
                    color: Colors.black, offset: Offset(2, 0), blurRadius: 4)
              ]),
              padding: const EdgeInsets.all(8),
          child: Center(
            child: widget,
                // Text(
                //   txt,
                //   style: const TextStyle(color: Colors.white),
                // ),
            ),
          ),
        );
  }
}

class TankCard extends StatelessWidget {
  const TankCard({Key? key, this.v1 = 0, this.v2 = 0}) : super(key: key);

  final double v1;
  final double v2;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        Tank(value: v1,),
        SizedBox(width: 100,),
        Tank(value: v2,)
      ],
    );
  }
}


class Tank extends StatelessWidget {
  const Tank({Key? key, this.value = 0, this.width, this.height}) : super(key: key);

  final double? width;
  final double? height;
  final double value;
  @override
  Widget build(BuildContext context) {
    double tempv = value * 2.55;

    double actualValue = value / 100 ;
    Color actualColor = Color.fromARGB(255,
                                        (Resources.tankFullColor.red + (Resources.tankFullColor.red - Resources.tankEmptyColor.red) * actualValue).toInt() ,
                                        (Resources.tankFullColor.green + (Resources.tankFullColor.green - Resources.tankEmptyColor.green) * actualValue).toInt() ,
                                        (Resources.tankFullColor.blue + (Resources.tankFullColor.blue - Resources.tankEmptyColor.blue) * actualValue).toInt() );

    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width:  MediaQuery.of(context).size.width / 4,
      decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [actualColor, Colors.grey],
            stops: [actualValue - 0.1,actualValue]
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
      child: Center(child: Text('${value.toInt()}%', textScaleFactor: 2,)),
    );
  }
}