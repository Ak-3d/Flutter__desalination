import 'dart:async';
// import 'dart:html';
import 'package:final_project/Components/Common.dart';
import 'package:udp/udp.dart';
import 'package:flutter/material.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Components/CardDash.dart';
import '../Components/TankCard.dart';
import '../main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> implements ConnectionInterface {
  List<Widget> _cards = [];

  String status = "";
  String msgs = "";
  double value = 0;

  int colsN = 5;
  void _initCards() {
    if (screenSize.width > 500) return;
    colsN = 2;
    CardDash.defaultRows = 1;
    _cards = [
      CardDash(txt: 'Message', child: Text(msgs)),
      CardDash(
        txt: 'status',
        child: Text(status),
      ),
      const CardDash(txt: 'Degree'),
      const CardDash(txt: 'Duration'),
      CardDash(
        txt: 'TDS',
        cols: 2,
        child: ElevatedButton(
          onPressed: () => pushEdited(
              context: context,
              connectionInterface: this,
              namedRoute: '/TdsMainPage'),
          child: const Text('TDS'),
        ),
      ),
      CardDash(
        cols: 2,
        rows: 1,
        child: TankCard(v1: value, v2: value),
      ),
      const CardDash(txt: 'flow 1'),
      const CardDash(
        txt: 'flow 2',
      ),
      CardDash(
        child: Slider(
            value: value,
            min: 0,
            max: 100,
            onChanged: (v) {
              setState(() {
                value = v;
              });
            }),
      ),
      const StaggeredGridTile.extent(
        mainAxisExtent: 500,
        crossAxisCellCount: 3,
        child: Text(""),
      )
    ];
  }

  @override
  void initState() {
    ConnectionHandler.setInterface(this);
    ConnectionHandler.connectUDP();

    _initCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScofflding(title: 'Dashboard', listView: [
      StaggeredGrid.count(
        crossAxisCount: colsN,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: _cards,
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    ConnectionHandler.dispose();
    admin.close();
  }

  @override
  void connected() {
    setState(() {
      status = 'Connected';
    });
  }

  @override
  void interrupted(data) {
    setState(() {
      status = 'Disconnect: $data';
    });
  }

  @override
  void listen(data) {
    List<String> d = data.toString().split(':');
    // value = double.parse(d[1]);
    setState(() {
      msgs = data;
    });
  }
}
