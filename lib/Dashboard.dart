

import 'dart:async';
import 'package:final_project/Resources.dart';
import 'package:udp/udp.dart';
import 'package:flutter/material.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'CardDash.dart';
import 'TankCard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
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
                  onPressed: () {
                    // Navigate to the second page when the button is pressed
                    Navigator.pushNamed(context, '/TdsMainPage');
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
