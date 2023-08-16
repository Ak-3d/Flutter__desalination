// import 'dart:async';

import 'package:final_project/Components/CardDash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// import '../ConnectionHandler.dart';
import '../Resources.dart';

class AppScofflding extends StatelessWidget {
  const AppScofflding({Key? key, this.title = 'title', required this.listView})
      : super(key: key);

  final String title;
  final List<Widget> listView;
  final String foregroundTxt = 'Toggle Service';
  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // debugPrint('width of screen: $width');
    if (MediaQuery.of(context).size.width < 450) {
      CardDash.defaultRows = 1;
    }
    return Scaffold(
      backgroundColor: Resources.bgcolor,
      // appBar: AppBar(
      //   title: Text(title),
      //   backgroundColor: Resources.bgcolor,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: listView,
        ),
      ),
      bottomSheet: Row(
        //TODO this is temprary
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text(foregroundTxt),
            onPressed: () async {
              final service = FlutterBackgroundService();
              var isRunning = await service.isRunning();
              if (isRunning) {
                service.invoke("stopService");
              } else {
                service.startService();
              }
            },
          ),
        ],
      ),
    );
  }
}
