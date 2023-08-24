import 'dart:math';

import 'package:final_project/Components/CustomCard.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:final_project/Models/Production.dart';
import 'package:final_project/Models/Tanks.dart';
import 'package:final_project/Pages/DashboardCards/StatsCard.dart';
import 'package:final_project/main.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Resources.dart';
import '../Models/ActuatorStatus.dart';

// ignore: must_be_immutable
class Pump extends StatelessWidget {
  Pump(this.name, bool state, {super.key}) {
    led = state ? Resources.passcolor : Resources.failcolor;
  }
  String name = "";
  Color? led;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: led,
        ),
        Text(name)
      ],
    );
  }
}

class TDSChart extends StatefulWidget {
  const TDSChart(
      {Key? key,
      required this.chartData,
      required this.onRendererCreated,
      this.xMax,
      this.xMin,
      this.yMax,
      this.yMin})
      : super(key: key);

  final List<LiveData> chartData;
  final void Function(ChartSeriesController controller) onRendererCreated;
  final double? xMax;
  final double? xMin;
  final double? yMax;
  final double? yMin;

  @override
  _ChartTdsState createState() => _ChartTdsState();
}

class _ChartTdsState extends State<TDSChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SfCartesianChart(
            title: ChartTitle(
              text: "TDS During Current week",
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            series: <LineSeries<LiveData, double>>[
              LineSeries<LiveData, double>(
                onRendererCreated: widget.onRendererCreated,
                dataSource: widget.chartData,
                color: Resources.chartColor,
                xValueMapper: (LiveData sales, _) => sales.time,
                yValueMapper: (LiveData sales, _) => sales.speed,
              )
            ],
            enableAxisAnimation: true,
            plotAreaBorderColor: const Color.fromARGB(0, 206, 206, 215),
            primaryXAxis: NumericAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              maximum: widget.xMin,
              minimum: widget.xMax,
              title: AxisTitle(text: "Days"),
              // axisLine:
              //     const AxisLine(width: 1, color: Resources.chartAxisColor),
            ),
            primaryYAxis: NumericAxis(
              maximum: widget.yMax,
              minimum: widget.yMin,
              title: AxisTitle(text: "TDS (PPM)"),
              // axisLine:
              //     const AxisLine(width: 1, color: Resources.chartAxisColor),
              // title: AxisTitle(text: 'TDS (ppm)')
            )));
  }
}

class LiveData {
  LiveData(this.time, this.speed);

  final double speed;
  final double time;
}

class SystemPage extends StatelessWidget {
  const SystemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Resources.bgcolor,
      appBar: AppBar(
        title: const Text("System Monitor"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              children: const [SystemPageStfl()],
            ),
          )),
    );
  }
}

class SystemPageStfl extends StatefulWidget {
  const SystemPageStfl({Key? key}) : super(key: key);

  @override
  State<SystemPageStfl> createState() => _SystemPageStflState();
}

class _SystemPageStflState extends State<SystemPageStfl>
    implements ConnectionInterface {
  late ChartSeriesController chartController;
  late List<LiveData> levelData;

  ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();
  late Production production;
  late ActuatorStatus actuatorStatus;
  late Tanks tank;

  double totalWater = 0;
  int efficiency = 0;

  late double maxX;
  int step = 1;
  double t = 0;

  @override
  void initState() {
    super.initState();
    ciw.setInterface(this);

    levelData = [];
    final now = DateTime.now();
    final sat = ((now.weekday + 2) % 7) + 1;

    production = Production(0, 0, 0, 0);
    actuatorStatus = ActuatorStatus();

    //database query
    var q = objectbox.production
        .query(Production_.createdDate.greaterOrEqual(
            now.subtract(Duration(days: sat)).millisecondsSinceEpoch))
        .order(Production_.createdDate)
        .build(); //~/ gives

    levelData = [LiveData(0, 0)];
    t += 1;
    levelData.addAll(q.find().map<LiveData>((e) {
      double temp = t;
      t += step;
      return LiveData(temp, e.tdsValue);
    }).toList());

    maxX = levelData.length / (7 - sat) * 7;
    maxX = maxX < 1000 ? 1000 : maxX;
    // for (int i = 0; i < 200; i++) {
    //   Random r = Random();
    //   levelData.add(LiveData(0.1 * i.toDouble(), (r.nextInt(1000)).toDouble()));
    // }
    // DataBase call
    // if (objectbox.tanks.contains(widget.tankId)) {
    //   tank = objectbox.tanks.get(widget.tankId)!;
    //   tankName = tank.plantName;
    //   tdsValue = tank.tdsValue;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StaggeredGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          children: [
            StatsBody(
              title: 'Temperature',
              data: "${production.temperatureValue} C",
              icon: Icons.thermostat_rounded,
            ),
            PlaceHolderIcon(),
            StatsBody(
              title: 'TDS Value',
              data: "${production.tdsValue} PPM",
              icon: Icons.spa_rounded,
            ),
            CustomCard(
              cols: 3,
              rows: 1.25,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TDSChart(
                          xMax: maxX,
                          xMin: 0,
                          yMax: 1000,
                          yMin: 0,
                          chartData: levelData,
                          onRendererCreated: (controller) =>
                              chartController = controller),
                    ),
                  ]),
            ),
            CustomCard(
              cols: 3,
              rows: 0.5,
              title: "Flow Information:",
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  StatsBody(
                    title: "Permeate Discharge:",
                    data: "${production.flowWaterPermeate} Lpm",
                    icon: Icons.water_outlined,
                  ),
                  StatsBody(
                      title: "Concentrated Discharge:",
                      data: "${production.flowWaterConcentrate} Lpm",
                      icon: Icons.waterfall_chart_rounded),
                ],
              ),
            ),
            CustomCard(
              cols: 3,
              rows: 0.5,
              title: "Statistics:",
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  StatsBody(
                    title: "Current Week Production",
                    data: "$totalWater liter/week",
                    icon: Icons.battery_full,
                  ),
                  StatsBody(
                      title: "Effecency",
                      data: "$efficiency %",
                      icon: Icons.bar_chart),
                ],
              ),
            ),
            CustomCard(
              cols: 5,
              rows: 0.5,
              title: "Information",
              child: Column(
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            children: [
                              const Spacer(
                                flex: 1,
                              ),
                              Pump("Input Pump", actuatorStatus.inPumps),
                              const Spacer(
                                flex: 1,
                              ),
                              Pump("Main Pump", actuatorStatus.mainPump),
                              const Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Spacer(
                              flex: 1,
                            ),
                            Pump("Plant Pump", actuatorStatus.plantPump),
                            const Spacer(
                              flex: 1,
                            ),
                            Pump("Plant Valve", actuatorStatus.plantValve),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Spacer(
                              flex: 1,
                            ),
                            Pump("Drinking Pump", actuatorStatus.drinkPump),
                            const Spacer(
                              flex: 1,
                            ),
                            Pump("Drinking Valve", actuatorStatus.drinkValve),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ciw.dispose();
  }

  @override
  void connected() {
    // TODO: implement connected
  }

  @override
  void interrupted(data) {
    // TODO: implement interrupted
  }

  @override
  void listen(Map<int, dynamic> data) {
    if (!mounted || data.isEmpty) return;

    final prodMap = data[ObjName.production.index];
    if (prodMap != null) {
      _updateProduction(prodMap);
    }

    final actMap = data[ObjName.pumpsAndValves.index];
    if (actMap != null) {
      setState(() {
        // actuatorStatus.inPumps = actMap[ActutureStatusData.inPumps.index];
        actuatorStatus.mainPump =
            actMap[ActutureStatusData.mainPump.index] == "1";
        actuatorStatus.drinkPump =
            actMap[ActutureStatusData.drinkPump.index] == "1";
        actuatorStatus.drinkValve =
            actMap[ActutureStatusData.drinkValve.index] == "1";
        actuatorStatus.plantPump =
            actMap[ActutureStatusData.plantPump.index] == "1";
        actuatorStatus.plantValve =
            actMap[ActutureStatusData.plantValve.index] == "1";
      });
    }
  }

  void _updateProduction(Map<int, dynamic> prodMap) {
    double tds = double.parse(prodMap[ProductionData.tds.index]!);
    setState(() {
      production.flowWaterConcentrate =
          double.parse(prodMap[ProductionData.conFlow.index]!);
      production.flowWaterPermeate =
          double.parse(prodMap[ProductionData.preFlow.index]!);
      production.tdsValue = tds;
      production.temperatureValue =
          double.parse(prodMap[ProductionData.temperature.index]!);
    });

    if (t >= maxX) {
      t = 0;
      chartController.updateDataSource(
          removedDataIndexes:
              List<int>.generate(levelData.length, (index) => index));
      levelData.clear();
    }
    levelData.add(LiveData(t, tds));
    t += 1;
    chartController.updateDataSource(addedDataIndex: levelData.length - 1);
  }
}
