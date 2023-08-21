import 'package:final_project/Components/CustomCard.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:final_project/Models/Tanks.dart';
import 'package:final_project/Pages/DashboardCards/StatsCard.dart';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Resources.dart';
import 'dart:math';

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
  final int tankId;
  const SystemPage({Key? key, this.tankId = 1}) : super(key: key);

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
              children: [SystemPageStfl(tankId: tankId)],
            ),
          )),
    );
  }
}

class SystemPageStfl extends StatefulWidget {
  final int tankId;
  const SystemPageStfl({Key? key, this.tankId = 1}) : super(key: key);

  @override
  State<SystemPageStfl> createState() => _SystemPageStflState();
}

class _SystemPageStflState extends State<SystemPageStfl>implements ConnectionInterface {
  late ChartSeriesController chartController;
  late List<LiveData> levelData;
   ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();
  late Tanks tank;
  String tankName = '';
  double tdsValue = 0;
  double temp = 0;
  double perFlow = 0;
  double conFlow = 0;
  double totalWater = 0;
  int efficiency = 0;

  @override
  void initState() {
    super.initState();

    levelData = [];
    for (int i = 0; i < 200; i++) {
      Random r = new Random();
      levelData.add(LiveData(0.1 * i.toDouble(), (r.nextInt(1000)).toDouble()));
    }
    // DataBase call
    if (objectbox.tanks.contains(widget.tankId)) {
      tank = objectbox.tanks.get(widget.tankId)!;
      tankName = tank.plantName;
      tdsValue = tank.tdsValue;
    }
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
            CustomCard(
              cols: 3,
              rows: 1.25,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TDSChart(
                          xMax: 7,
                          xMin: 0,
                          yMax: 1000,
                          yMin: 0,
                          chartData: levelData,
                          onRendererCreated: (controller) =>
                              chartController = controller),
                    ),
                  ]),
            ),
            StatsBody(
              title: 'Tank name',
              data: "$tankName ",
              icon: Icons.takeout_dining_rounded,
            ),
            StatsBody(
              title: 'Temperature',
              data: "$temp C",
              icon: Icons.thermostat_rounded,
            ),
            StatsBody(
              title: 'TDS Value',
              data: "$tdsValue PPM",
              icon: Icons.spa_rounded,
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
                    data: "$perFlow Lpm",
                    icon: Icons.water_outlined,
                  ),
                  StatsBody(
                      title: "Concentrated Discharge:",
                      data: "$conFlow Lpm",
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
                              Pump("Input Pump", true),
                              const Spacer(
                                flex: 1,
                              ),
                              Pump("Main Pump", true),
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
                            Pump("Plant Pump", true),
                            const Spacer(
                              flex: 1,
                            ),
                            Pump("Plant Valve", false),
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
                            Pump("Drinking Pump", false),
                            const Spacer(
                              flex: 1,
                            ),
                            Pump("Drinking Valve", true),
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
  void connected() {
    // TODO: implement connected
  }
  
  @override
  void interrupted(data) {
    // TODO: implement interrupted
  }
  
  @override
  void listen(Map<int, dynamic> data) {
    // TODO: implement listen
  }
}
