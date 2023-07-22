


import 'dart:async';
import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:final_project/ChartTds_page.dart';
import 'package:udp/udp.dart';
import 'CardDash.dart';



class TdsMainPage extends StatelessWidget {
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
                widget: ChartTdsPage(),
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
