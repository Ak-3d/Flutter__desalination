import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'dart:async';
import '../Resources.dart';

class TankVolume extends StatefulWidget {
  final List<LiveData> chartData;
  final void Function(ChartSeriesController controller) onRendererCreated;

  final double? xMin;
  final double? xMax;
  final double? yMin;
  final double? yMax;

  const TankVolume(
      {Key? key,
      required this.chartData,
      required this.onRendererCreated,
      this.xMax,
      this.xMin,
      this.yMax,
      this.yMin})
      : super(key: key);

  @override
  _ChartTdsState createState() => _ChartTdsState();
}

class _ChartTdsState extends State<TankVolume> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SfCartesianChart(
            title: ChartTitle(
              text: "Water Used Per Week",
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
              title: AxisTitle(text: "Volume (L)"),
              // axisLine:
              //     const AxisLine(width: 1, color: Resources.chartAxisColor),
              // title: AxisTitle(text: 'TDS (ppm)')
            )));
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final double time;
  final double speed;
}
