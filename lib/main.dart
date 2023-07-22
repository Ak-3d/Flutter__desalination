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
    const title = 'Water Desalination Project';
    return MaterialApp(
      title: title,
      home: const MyHomePage(
        title: title,
      ),
      routes: {
        '/secondPage': (context) => SecondPage(),
      },
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

  void listenWebsocket(data) {
    setState(() {
      status = "Connected and Receiving messages";
      connectedIP = foundIP;
      msgs = '${data.toString()}\n';
    });
  }

  void listenUDP(data) {
    var r = RegExp(r"^(\d{1,3}\.){3}\d{1,3}$");
    var substr = data.toString().substring(4);
    setState(() {
      status = "Searching UDP multicast";
      datagramUDP = data;
    });

    if (r.hasMatch(substr)) {
      setState(() {
        status = "trying to Connect to potential IP";
        foundIP = substr;
      });
      ConnectionHandler.closeUDP();
      ConnectionHandler.connectWebSocket(
          ipaddress: substr,
          listen: listenWebsocket,
          interrupted: inturWebsocket);
    }
  }

  void inturUDP(intur) {
    setState(() {
      status = "Error in UDP connection";
      errTxt = "Error UDP: $intur";
      ConnectionHandler.dispose();
    });
  }

  void inturWebsocket(intur) {
    setState(() {
      status = "Error in Websocket connection";
      errTxt = intur;
      ConnectionHandler.dispose();
    });
  }

  void clearMsg() {
    datagramUDP = "";
    connectedIP = "";
    // msgs = "";
  }

  @override
  void initState() {
    ConnectionHandler.connectUDP(
        listen: listenUDP,
        interrupted: inturUDP,
        connected: () {
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
        title: Text(widget.title), // add it to resources
        backgroundColor: Resources.bgcolor_100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          StaggeredGrid.count(
            crossAxisCount: 5,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              CardDash(txt: status),
              CardDash(txt: status),
              CardDash(
                txt: status,
                widget: ElevatedButton(
                  onPressed:  () {
                    // Navigate to the second page when the button is pressed
                    Navigator.pushNamed(context, '/secondPage');
                  },
                  child: Text('TDS'),
                ),
              ),
              CardDash(txt: status),
              CardDash(txt: status),
              CardDash(
                txt: status,
                rows: 2,

              ),
              CardDash(
                txt: status,
                cols: 3,
                rows: 2,
                widget: TankCard(v1: value, v2: value),
              ),
              CardDash(
                txt: status,
                rows: 2,
              ),

              CardDash(
                txt: status,
                widget: Slider(
                    value: value,
                    min: 0,
                    max: 100,
                    onChanged: (v) {
                      setState(() {
                        value = v;
                      });
                    }),
              ),

              StaggeredGridTile.extent(
                mainAxisExtent: 500,
                crossAxisCellCount: 3,
                child: Text(""),

              )
            ],
          ),
        ]),
      ),
      bottomSheet: Container(
        child: Row(
          children: [
            TextButton(
              child: const Text('reconnect'),
              onPressed: () {
                if (ConnectionHandler.isWebsocketCreated ||
                    ConnectionHandler.isUDPCreated) {
                  setState(() {
                    status = "Connection is off";
                  });
                  clearMsg();
                  ConnectionHandler.dispose();
                } else {
                  ConnectionHandler.connectUDP(
                      listen: listenUDP,
                      interrupted: inturUDP,
                      connected: () {
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


class SecondPage extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Resources.bgcolor,
      appBar: AppBar(
        title: Text('TDS'),
        backgroundColor: Resources.bgcolor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          StaggeredGrid.count(
            crossAxisCount: 5,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              CardDash(txt: status),
              CardDash(
                  txt: status,
                rows: 3,
                cols: 4,
                widget: Text('TDS Changes'),

              ),


              CardDash(txt: status),
              CardDash(txt: status),


              ElevatedButton(
                onPressed: () {
                  // Navigate back to the previous page when the button is pressed
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
              ),
              StaggeredGridTile.extent(
                mainAxisExtent: 1000,
                crossAxisCellCount: 80,
                child: Text(""),

              ),

            ],
          ),
        ]),
      ),

    );


  }
}




class CardDash extends StatelessWidget {
  const CardDash(
      {Key? key,
      this.txt = "card",
      this.color = Resources.bgcolor_100,
      this.cols = 1,
      this.rows = 1,
      this.widget = const Text('')})
      : super(key: key);

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
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
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
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Tank(
            value: v1,
          ),
          Tank(
            value: v2,
          )
        ],
      ),
    );
  }
}

class Tank extends StatelessWidget {
  const Tank({Key? key, this.value = 0, this.width, this.height})
      : super(key: key);

  final double? width;
  final double? height;
  final double value;

  @override
  Widget build(BuildContext context) {
    double tempv = value * 2.55;

    double actualValue = value / 100;
    Color actualColor = Color.fromARGB(
        255,
        (Resources.tankFullColor.red +
                (Resources.tankFullColor.red - Resources.tankEmptyColor.red) *
                    actualValue)
            .toInt(),
        (Resources.tankFullColor.green +
                (Resources.tankFullColor.green -
                        Resources.tankEmptyColor.green) *
                    actualValue)
            .toInt(),
        (Resources.tankFullColor.blue +
                (Resources.tankFullColor.blue - Resources.tankEmptyColor.blue) *
                    actualValue)
            .toInt());

    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width / 7,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [actualColor, Colors.grey],
              stops: [actualValue - 0.1, actualValue]),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Center(
          child: Text(
        '${value.toInt()}%',
        textScaleFactor: 2,
      )),
    );
  }
}
