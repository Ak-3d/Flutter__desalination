import 'package:flutter/material.dart';

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
  String status = "";
  String msgs = "";
  double value = 0;
  String title = '';

  int colsN = 3;

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
          CardDash(title: 'Status', child: Text(msgs)),
          CardDash(
            title: 'Total Power Saved',
            child: Text(status),
          ),
          const CardDash(title: 'Total Water Production'),
          CardDash(
            title: 'Next in Schedule',
            cols: 3,
            rows: 2,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text('1 Day, 15 hours',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
              Expanded(
                  child: Text('Tank 1',
                      style: Theme.of(context).textTheme.bodyMedium)),
              Expanded(
                child: Text('Tuesday at 3 o\'sclick',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ]),
          ),
          CardDash(
            title: 'TDS',
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/TdsMainPage'),
              child: const Text('TDS'),
            ),
          ),
          CardDash(
            title: 'Reports',
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/ReportsView'),
              child: const Text('Reports'),
            ),
          ),
          CardDash(
            title: 'Electrical Information',
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/ElectricalPage'),
              child: const Text('Info.'),
            ),
          ),
          CardDash(
            title: 'Tanks',
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/TankView'),
              child: const Text('Tanks'),
            ),
          ),
          const CardDash(title: 'flow 1'),
          const CardDash(
            title: 'flow 2',
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
    // List<String> d = data.toString().split(':');
    // value = double.parse(d[1]);
    setState(() {
      msgs = data.toString();
    });
  }
}
