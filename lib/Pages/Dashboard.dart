import 'dart:async';

import 'package:final_project/Components/ChartTds.dart';
import 'package:final_project/Pages/DashboardCards/TanksCardDash.dart';
import 'package:final_project/Models/Power.dart';
import 'package:final_project/Models/Production.dart';
import 'package:final_project/Models/Schedule.dart';
import 'package:final_project/Models/SingleTank.dart';
import 'package:final_project/Models/Tanks.dart';
import 'package:final_project/Pages/DashboardCards/PowerCard.dart';
import 'package:final_project/Pages/DashboardCards/ScheduleCard.dart';
import 'package:final_project/Pages/DashboardCards/StatsCard.dart';
import 'package:final_project/Pages/DashboardCards/SystemCard.dart';
import 'package:final_project/Resources.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';

import 'package:final_project/Components/Common.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Components/CustomCard.dart';
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

  late Schedule schedule;
  late DateTime? scheduleDate;

  late Production production;
  late Power electricity;

  int colsN = 3;

  ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();

  String durationStr = '';

  late List<NamedData> irregationsData;
  late ChartSeriesController irregationController;

  late List<ColoredData> dataGood;
  late CircularSeriesController cGood;

  late List<ColoredData> dataWaste;
  late CircularSeriesController cWaste;

  late List<Tanks> tanks;
  late List<SingleTank> liveTanks;

  void quryDatabase() {
    DateTime nowTemp = DateTime.now();
    final weekDay = ((nowTemp.weekday + 1) % 7) + 1;

    //**STATS
    final elects = objectbox.power
        .query(Power_.isBattery.equals(true))
        .order(Power_.createdDate, flags: Order.descending)
        .build()
        .find();
    electricity = elects.isEmpty ? Power(0, 0, 0, 0, false, 0) : elects[0];

    totalPower = elects.fold<double>(
        0,
        (previousValue, element) =>
            ((element.currentOut * 36) + previousValue)); //TODO 10***

    totalProduction = objectbox.production.getAll().fold<double>(0,
        (previousValue, element) => previousValue + element.flowWaterPermeate);

    //**TANKS
    tanks =
        objectbox.tanks.query(Tanks_.isDeleted.equals(false)).build().find();
    liveTanks = [];
    for (var t in tanks) {
      SingleTank s = SingleTank(0, false);
      s.tanks.target = t;
      var b = objectbox.singleTank
          .query()
          .order(SingleTank_.createdDate, flags: Order.descending);
      b.link(SingleTank_.tanks, Tanks_.id.equals(t.id));
      var built = b.build();
      SingleTank temp = built.findFirst() ?? s;
      liveTanks.add(temp);
    }

    //**Schedule
    var schBuild = objectbox.schedule
        .query(Schedule_.hours.greaterOrEqual(nowTemp.hour))
        .order(Schedule_.hours); //sort by hours
    schBuild.backlink(Days_.schedule, Days_.day.equals(weekDay));
    List<Schedule> scs = schBuild.build().find();

    scs.sort((a, b) => a.mins.compareTo(b.mins)); //sort by mins
    schedule = scs.isEmpty
        ? Schedule(0, 0, DateTime.now())
        : scs[0]; //check if none is found
    scheduleDate = scs.isEmpty
        ? null
        : DateTime(nowTemp.year, nowTemp.month, nowTemp.day, schedule.hours,
            schedule.mins);

    //**Irrigation
    irregationsData = [];
    for (var i = 0; i < tanks.length; i++) {
      final volume = objectbox.irregation
          .query(Irrigation_.tankID
              .equals(tanks[i].id)
              .and(Irrigation_.isDeleted.equals(false)))
          .build()
          .find()
          .fold<double>(
              0,
              (previousValue, element) =>
                  previousValue + element.irrigationVolume);
      irregationsData.add(NamedData(
          'Tank ${tanks[i].portNumber}', volume, Resources.primaryColor));
    }
  }

  @override
  void initState() {
    super.initState();
    ciw.setInterface(this);
    print("init Dashbaord");
    quryDatabase();

    production = Production(0, 0, 0, 0);
    dataGood = List<ColoredData>.generate(
        360, (i) => ColoredData(i.toDouble(), '', Colors.white));
    dataWaste = List<ColoredData>.generate(
        360, (i) => ColoredData(i.toDouble(), '', Colors.white));

    Timer.periodic(const Duration(seconds: 1), (timer) {
      updateDuration(); //update the Duration for irregation
    });
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
            date: scheduleDate,
            onRendererCreated: (c) => irregationController = c),
        PowerCard(electricity: electricity),
        CustomCard(
            title: 'Tanks',
            rows: 0.8,
            cols: liveTanks.length < 4 ? 1 : 3,
            child: TanksCardDash(tanks: liveTanks)),
        CustomCard(
          rows: 0.8,
          cols: liveTanks.length < 4 ? 2 : 3,
          title: 'System',
          child: SystemCard(
            production: production,
            cGoodRendererCreated: (c) => cGood = c,
            dataGood: dataGood,
            cWasteRendererCreated: (c) => cWaste = c,
            dataWaste: dataWaste,
          ),
        ),
        CustomCard(
          title: 'TanksSetup',
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/TanksPage'),
            child: const Text('TanksSetup'),
          ),
        ),
        CustomCard(
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
    // print("closed Dashbord");
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
    final prodMap = data[ObjName.production.index];

    if (prodMap != null) {
      production.flowWaterPermeate =
          double.parse(prodMap[ProductionData.preFlow.index]);
      production.flowWaterConcentrate =
          double.parse(prodMap[ProductionData.conFlow.index]);

      setState(() {
        production.temperatureValue =
            double.parse(prodMap[ProductionData.temperature.index]);
        production.tdsValue = double.parse(prodMap[ProductionData.tds.index]);
      });

      var toDeg = (production.flowWaterPermeate / 2000 * 360).toInt();
      updateCirculeChart(cGood, dataGood, toDeg);
      updateCirculeChart(
          cWaste, dataWaste, production.flowWaterConcentrate.toInt());
    }

    final powerMap = data[ObjName.power.index];
    if (powerMap != null) {
      setState(() {
        electricity.batteryLevel =
            double.parse(powerMap[PowerData.batteryLevel.index]);
        electricity.currentOut =
            double.parse(powerMap[PowerData.currentOut.index]);
        electricity.currentIn =
            double.parse(powerMap[PowerData.currentIn.index]);
        electricity.voltageIn =
            double.parse(powerMap[PowerData.voltageIn.index]);
        electricity.duration = int.parse(powerMap[PowerData.duration.index]);
        electricity.isBattery =
            powerMap[PowerData.isBattery.index]?.toString() == '1' ?? false;
      });
    }
  }

  List<int> degI = List<int>.generate(360, (index) => index);
  void updateCirculeChart(controller, coloredData, int discharage) {
    const Color c = Resources.primaryColor;
    discharage = (discharage * 3.6).toInt();
    for (var i = 0; i < coloredData.length; i++) {
      coloredData[i] =
          ColoredData(100 / 3, '$i', i <= discharage ? c : Colors.white);
    }
    cGood.updateDataSource(updatedDataIndexes: degI);
  }

  void updateDuration() {
    if (scheduleDate == null) {
      if (mounted) {
        setState(() {
          durationStr = 'No irregations for the rest of the day';
        });
      }
      return;
    }

    final nowD = DateTime.now();
    final diff = scheduleDate!.difference(nowD);
    final hrs = diff.inHours % Duration.hoursPerDay;
    final mins = diff.inMinutes % 60;
    final scnds = (diff.inSeconds % Duration.secondsPerDay) % 60;
    setState(() {
      durationStr = '$hrs hours, $mins mins, $scnds seconds';
    });
  }
}
