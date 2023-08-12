import 'package:flutter/material.dart';

import 'package:final_project/Components/Common.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Components/CardDash.dart';
import '../Components/TankCard.dart';
import '../main.dart';

class ElectricalPage extends StatefulWidget {
  const ElectricalPage({
    super.key,
  });

  @override
  State<ElectricalPage> createState() => _ElectricalPage();
}

class _ElectricalPage extends State<ElectricalPage>
    implements ConnectionInterface {
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
    return AppScofflding(title: 'ElectricalPage', listView: [
      StaggeredGrid.count(
        crossAxisCount: colsN,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          CardDash(
            title: 'Total Power Drawn From AC Source',
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text('126 Wh',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ]),
          ),
          CardDash(
            title: 'Total Power Drawn From Battery',
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text('50 Wh',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ]),
          ),
          CardDash(
            title: 'Total Power Drawn From the Solar Energy',
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text('76 Wh',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ]),
          ),
          CardDash(
            title: 'Real Time Calculation',
            cols: 3,
            rows: 2,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 2,
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    height: 300,
                    width: double.infinity,
                    //child: Text('Hisham'),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(1, 1, 1, 0.1),
                    ),
                  ),
                  Text('Hi'),
                ]),
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
            title: 'ElectricalPage',
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/ElectricalPage'),
              child: const Text('ElectricalPage'),
            ),
          ),
          CardDash(
            title: 'TanksSetup',
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/TanksSetup'),
              child: const Text('TanksSetup'),
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
