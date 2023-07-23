import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import '../Resources.dart';
import 'dart:math' as math;

class ChartTds extends StatefulWidget {
  @override
  _ChartTdsState createState() => _ChartTdsState();
}

class _ChartTdsState extends State<ChartTds> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    chartData = getChartData();
    Timer.periodic(const Duration(milliseconds: 1000), updateDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Resources.bgcolor_100,
            body: SfCartesianChart(
                title: ChartTitle(text: "Total Dissolved Solid Chart"),
                series: <LineSeries<LiveData, double>>[
                  LineSeries<LiveData, double>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: Resources.chartColor,
                    xValueMapper: (LiveData sales, _) => sales.time,
                    yValueMapper: (LiveData sales, _) => sales.speed,
                  )
                ],
                enableAxisAnimation: true,
                plotAreaBorderColor: Color(22),
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(
                        width: 0.5,
                        color: Resources.chartColorGrid,
                        dashArray: [3, 3]),
                    axisLine: const AxisLine(
                        width: 1, color: Resources.chartAxisColor),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 1,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(
                        width: 0.5,
                        color: Resources.chartColorGrid,
                        dashArray: [3, 3]),
                    axisLine: const AxisLine(
                        width: 1, color: Resources.chartAxisColor),
                    title: AxisTitle(text: 'TDS (ppm)')))));
  }

  double time = 0;
  void updateDataSource(Timer timer) {
    time = time + 2;
    chartData.add(LiveData(time, (math.Random().nextInt(700) + 0)));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(0, 0),
      LiveData(0, 0),
      LiveData(0, 0),
      LiveData(0, 0),
      LiveData(0, 0),
      LiveData(0, 0),
      LiveData(0, 0),
      LiveData(0, 0),
      LiveData(0, 0),
      LiveData(0, 0),
      LiveData(0, 0)
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final double time;
  final double speed;
}
