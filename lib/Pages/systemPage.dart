import 'package:faker/faker.dart';
import 'package:final_project/Components/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Resources.dart';
import 'dart:math';

class pump extends StatelessWidget {
  pump(String Name, bool state) {
    this.name = Name;
    led = state ? Colors.green : Colors.red;
  }
  String name = "";
  Color? led;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: led,
          ),
          Text(name)
        ],
      ),
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

class systemPage extends StatelessWidget {
  const systemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("System"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              children: [systemPageStfl()],
            ),
          )),
    );
  }
}

class systemPageStfl extends StatefulWidget {
  systemPageStfl({Key? key}) : super(key: key);

  @override
  State<systemPageStfl> createState() => _systemPageStflState();
}

class _systemPageStflState extends State<systemPageStfl> {
  late ChartSeriesController chartController;
  late List<LiveData> levelData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    levelData = [];
    for (int i = 0; i < 200; i++) {
      Random r = new Random();
      levelData.add(LiveData(0.1 * i.toDouble(), (r.nextInt(1000)).toDouble()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 6,
      mainAxisSpacing: 22,
      crossAxisSpacing: 12,
      children: [
        CustomCard(
          cols: 6,
          rows: 1.25,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        CustomCard(
          cols: 4,
          title: "Information",
          child: Column(
            children: [
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Plant: Oninon',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              const Text(''),
                              Text('TDS Value: ${500} PPM'),
                              SizedBox(
                                height: 4,
                              ),
                              Text('Temprature: ${25} C'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('',
                                style: Theme.of(context).textTheme.bodyLarge),
                            const Text(''),
                            Text('Permeate Discharge: ${3} Ltrs'),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Concentrated Discharge: ${2} Ltrs'),
                          ],
                        ),
                      )
                    ]),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Spacer(
                            flex: 3,
                          ),
                          pump("Input Pump", true),
                          Spacer(
                            flex: 2,
                          ),
                          pump("Main Pump", true),
                          Spacer(
                            flex: 4,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Spacer(
                          flex: 3,
                        ),
                        pump("Plant Pump", true),
                        Spacer(
                          flex: 2,
                        ),
                        pump("Plant Valve", false),
                        Spacer(
                          flex: 4,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Spacer(
                          flex: 3,
                        ),
                        pump("Drinking Pump", false),
                        Spacer(
                          flex: 2,
                        ),
                        pump("Drinking Valve", true),
                        Spacer(
                          flex: 4,
                        ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: Column(
                  //     children: [
                  //       pump("Main Pump", true),
                  //       pump("Plant Pump", true),
                  //       pump("Plant Valve", true),
                  //     ],
                  //   ),
                  // ),
                ],
              ))
            ],
          ),
        ),
        CustomCard(
          cols: 2,
          title: "More",
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Statistics',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const Text(''),
                    Text('Current Week Production: ${2500} Ltrs'),
                    SizedBox(
                      height: 4,
                    ),
                    Text('Effecency: ${86} %'),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
