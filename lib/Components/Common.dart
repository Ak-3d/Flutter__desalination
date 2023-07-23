import 'package:flutter/material.dart';
import '../ConnectionHandler.dart';
import '../Resources.dart';

class AppScofflding extends StatelessWidget {
  const AppScofflding(
      {Key? key, final this.title = 'title', required this.listView})
      : super(key: key);

  final String title;
  final List<Widget> listView;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Resources.bgcolor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Resources.bgcolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: listView,
        ),
      ),
      bottomSheet: Row(
        //TODO this is temprary
        children: [
          TextButton(
            child: const Text('reconnect'),
            onPressed: () {
              if (ConnectionHandler.isWebsocketCreated ||
                  ConnectionHandler.isUDPCreated) {
                ConnectionHandler.dispose();
              } else {
                ConnectionHandler.connectUDP();
              }
            },
          ),
        ],
      ),
    );
  }
}
