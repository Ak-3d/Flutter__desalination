import 'dart:async';

import 'package:final_project/Components/ChartTds.dart';
import 'package:final_project/Components/Tank.dart';
import 'package:final_project/Components/TanksCards.dart';
import 'package:final_project/Models/Electricity.dart';
import 'package:final_project/Models/Production.dart';
import 'package:final_project/Models/Schedule.dart';
import 'package:final_project/Models/SingleTank.dart';
import 'package:final_project/Models/Tanks.dart';
import 'package:final_project/Pages/DashboardCards/PowerCards.dart';
import 'package:final_project/Pages/DashboardCards/ScheduleCard.dart';
import 'package:final_project/Pages/DashboardCards/SystemCard.dart';
import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';

import 'package:final_project/Components/Common.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
  String status = "Disconnected";
  double totalPower = 100;
  double totalProduction = 70000;

  double value = 0;
  String title = '';

  late Tanks tanks;
  List<SingleTank> tanksRealTime = [];
  late Schedule schedule;
  late Production production;
  late Electricity electricity;

  int colsN = 3;

  ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();
  DateTime nowTemp = DateTime.now();
  String durationStr = '';

  late List<LiveData> irregationsData;
  late ChartSeriesController irregationController;

  late List<ColoredData> dataGood;
  late CircularSeriesController cGood;

  late List<ColoredData> dataWaste;
  late CircularSeriesController cWaste;

  @override
  void initState() {
    super.initState();
    ciw.setInterface(this);

    tanks = Tanks(1, 'demo plant 1', 500, 2000);
    tanks.id = 1;

    tanksRealTime.add(SingleTank(100, false));
    tanksRealTime[0].id = 1;
    tanksRealTime.add(SingleTank(50, true));
    tanksRealTime[1].id = 2;
    tanksRealTime.add(SingleTank(10, true));
    // tanksRealTime[2].id = 3;
    // tanksRealTime.add(SingleTank(1, true));
    // tanksRealTime[3].id = 4;

    schedule = Schedule(
        nowTemp.add(const Duration(days: 2, hours: 32)), DateTime.now());
    schedule.tanks.target = tanks;

    production = Production(120, 200, 100, 27);
    electricity = Electricity(42, 32, 300, 3200, 40, false);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      getPeriod();
    });

    irregationsData = List.generate(7, (index) {
      return LiveData(index.toDouble(), index * index * 0.5);
    });

    dataGood = List<ColoredData>.generate(
        360, (i) => ColoredData(i.toDouble(), '', Colors.white));
    dataWaste = List<ColoredData>.generate(
        360, (i) => ColoredData(i.toDouble(), '', Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: colsN,
      mainAxisSpacing: 30,
      crossAxisSpacing: 20,
      children: [
        StatsBody(
          title: 'Status',
          data: status,
          icon: Icons.wifi,
        ),
        StatsBody(
          title: 'Total Power Saved',
          data: '$totalPower kW',
          icon: Icons.electrical_services,
        ),
        StatsBody(
          title: 'Total Water Production',
          data: '$totalProduction ml',
          icon: Icons.water_drop_outlined,
        ),
        ScheduleCard(
            schedule: schedule,
            duration: durationStr,
            chartData: irregationsData,
            onRendererCreated: (c) => irregationController = c),
        PowerCard(electricity: electricity),
        CardDash(
            title: 'Tanks',
            rows: 0.8,
            cols: tanksRealTime.length < 4 ? 1 : 3,
            child: TanksCards(tanks: tanksRealTime)),
        CardDash(
          rows: 0.8,
          cols: tanksRealTime.length < 4 ? 2 : 3,
          title: 'System',
          child: SystemCard(
            production: production,
            cGoodRendererCreated: (c) => cGood = c,
            dataGood: dataGood,
            cWasteRendererCreated: (c) => cWaste = c,
            dataWaste: dataWaste,
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
          child: Slider(
              value: value,
              min: 0,
              max: 100,
              onChanged: (v) {
                setState(() {
                  value = v;
                  production.flowWaterPermeate = v.toInt().toDouble();
                });
                updateCirculeChart(cGood, dataGood, v.toInt());
                // dischargeCtrl.changeSpeed(v);
                electricity.batteryLevel = v.toInt().toDouble();
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
      status = data.toString();
    });
    // debugPrint('listnning from dashboard');
  }

  void updateCirculeChart(
      CircularSeriesController c, List<ColoredData> data, int v) {
    List<int> degI = List<int>.generate(360, (index) => index);
    const Color c = Resources.primaryColor;
    v = (v * 3.6).toInt();
    // v = v > 360 ? 359 : v;
    for (var i = 0; i < data.length; i++) {
      data[i] = ColoredData(100 / 3, '$i', i <= v ? c : Colors.white);
    }
    cGood.updateDataSource(updatedDataIndexes: degI);
  }

  void getPeriod() {
    final diff = schedule.time.difference(DateTime.now());
    final hrs = diff.inHours % Duration.hoursPerDay;
    final mins = diff.inMinutes % Duration.minutesPerDay;
    final scnds = (diff.inSeconds % Duration.secondsPerDay) % 60;
    setState(() {
      durationStr =
          '${diff.inDays} days, $hrs hours, $mins mins, $scnds seconds';
    });
  }
}

class StatsBody extends StatelessWidget {
  const StatsBody(
      {super.key,
      this.data = 'data | unit',
      this.title = 'Title',
      required this.icon});

  final String title;
  final String data;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 30;
    return CardDash(
        rows: 0.3,
        title: title,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              data,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Icon(
              icon,
              size: width,
              color: Resources.primaryColor,
            )
          ],
        ));
  }
}
