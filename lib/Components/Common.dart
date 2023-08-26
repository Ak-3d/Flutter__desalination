// import 'dart:async';

import 'package:final_project/Components/CustomCard.dart';
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
      CustomCard.defaultRows = 1;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/Settings');
            },
          ),
        ],
      ),
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
      // bottomSheet: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     ElevatedButton(
      //       child: Text(foregroundTxt),
      //       onPressed: () async {
      //         final service = FlutterBackgroundService();
      //         var isRunning = await service.isRunning();
      //         if (isRunning) {
      //           service.invoke("stopService");
      //         } else {
      //           service.startService();
      //         }
      //       },
      //     ),
      //     ElevatedButton(
      //       child: const Text('connect direct'),
      //       onPressed: () async {
      //         final service = FlutterBackgroundService();
      //         var isRunning = await service.isRunning();
      //         if (isRunning) {
      //           service.invoke("ConnectDirectly", {"ip": "192.168.43.133"});
      //         } else {
      //           service.startService();
      //         }
      //       },
      //     ),
      //     Row(
      //       children: [
      //         ElevatedButton(
      //           child: const Text('plant 0'),
      //           onPressed: () async {
      //             final service = FlutterBackgroundService();
      //             var isRunning = await service.isRunning();
      //             if (isRunning) {
      //               service.invoke("Send", {"msg": "plant:0"});
      //             }
      //           },
      //         ),
      //         ElevatedButton(
      //           child: const Text('plant 1'),
      //           onPressed: () async {
      //             final service = FlutterBackgroundService();
      //             var isRunning = await service.isRunning();
      //             if (isRunning) {
      //               service.invoke("Send", {"msg": "plant:1"});
      //             }
      //           },
      //         ),
      //         ElevatedButton(
      //           child: const Text('mainpump 1'),
      //           onPressed: () async {
      //             final service = FlutterBackgroundService();
      //             var isRunning = await service.isRunning();
      //             if (isRunning) {
      //               service.invoke("Send", {"msg": "mainpump:1"});
      //             }
      //           },
      //         ),
      //         ElevatedButton(
      //           child: const Text('mainpump 0'),
      //           onPressed: () async {
      //             final service = FlutterBackgroundService();
      //             var isRunning = await service.isRunning();
      //             if (isRunning) {
      //               service.invoke("Send", {"msg": "mainpump:0"});
      //             }
      //           },
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
