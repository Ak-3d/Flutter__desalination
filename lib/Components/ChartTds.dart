import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import '../Resources.dart';

class ChartTds extends StatefulWidget {
  final List<LiveData> chartData;
  final void Function(ChartSeriesController controller) onRendererCreated;

  final double? xMin;
  final double? xMax;
  final double? yMin;
  final double? yMax;

  const ChartTds(
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

class _ChartTdsState extends State<ChartTds> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SfCartesianChart(
            title: ChartTitle(text: "Total Dissolved Solid Chart"),
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
            plotAreaBorderColor: Color(22),
            primaryXAxis: NumericAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                maximum: widget.xMin,
                minimum: widget.xMax,
                axisLine:
                    const AxisLine(width: 1, color: Resources.chartAxisColor),
                title: AxisTitle(
                  text: 'Time (seconds)',
                )),
            primaryYAxis: NumericAxis(
              maximum: widget.yMax,
              minimum: widget.yMin,
              associatedAxisName: '',
              axisLine:
                  const AxisLine(width: 1, color: Resources.chartAxisColor),
              // title: AxisTitle(text: 'TDS (ppm)')
            )));
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final double time;
  final double speed;
}
