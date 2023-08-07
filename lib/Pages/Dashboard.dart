import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:final_project/Components/Common.dart';
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
  String txt = '';

  int colsN = 2;

  ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();
  @override
  void initState() {
    super.initState();

    ciw.setInterface(this);
  }

  @override
  Widget build(BuildContext context) {
    return AppScofflding(title: 'Dashboard', listView: [
      StaggeredGrid.count(
        crossAxisCount: colsN,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          CardDash(txt: 'Message', child: Text(msgs)),
          CardDash(
            txt: 'status',
            child: Text(status),
          ),
          const CardDash(
            txt: 'Degree',
            child: Text('here'),
          ),
          const CardDash(txt: 'Duration'),
          CardDash(
            txt: 'TDS',
            cols: 2,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/TdsMainPage'),
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
        ],
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    admin.close();
    ciw.dispose();
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
      msgs = data.toString();
    });
  }
}
