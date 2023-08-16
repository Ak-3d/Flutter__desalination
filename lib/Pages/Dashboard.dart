import 'package:flutter/material.dart';

import 'package:final_project/Components/Common.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Components/CardDash.dart';
import '../main.dart';

class Dashboard extends StatelessWidget {
  //THIS IS IMPORTANT DO NOT DELETE
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScofflding(listView: [DashboardStfl()]);
  }
}

class DashboardStfl extends StatefulWidget {
  const DashboardStfl({
    super.key,
  });

  @override
  State<DashboardStfl> createState() => _Dashboard();
}

class _Dashboard extends State<DashboardStfl> implements ConnectionInterface {
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
    return StaggeredGrid.count(
      crossAxisCount: colsN,
      mainAxisSpacing: 30,
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
          rows: 1,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          title: 'SingleTank',
          child: ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/SingleTank'),
            child: const Text('SingleTank'),
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
          title: 'LoginPage',
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/LoginPage'),
            child: const Text('LoginPage'),
          ),
        ),
        CardDash(
          title: 'SchedulePage',
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/SchedulePage' ),
            child: const Text('SchedulePage'),
          ),
        ),
        CardDash(
          title: 'PasswordSetup',
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/PasswordSetup'),
            child: const Text('PasswordSetup'),
          ),
        ),
        CardDash(
          title: 'AllTanks',
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/TanksPage'),
            child: const Text('AllTanks'),
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
          mainAxisExtent: 100,
          crossAxisCellCount: 3,
          child: Text(""),
        )
      ],
    );
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
    // debugPrint('listnning from dashboard');
  }
}
