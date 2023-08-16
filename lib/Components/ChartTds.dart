import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'dart:async';
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
            title: ChartTitle(
              text: "Total Dissolved Solid Chart",
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
            plotAreaBorderColor: Color(22),
            primaryXAxis: NumericAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              maximum: widget.xMin,
              minimum: widget.xMax,
              // axisLine:
              //     const AxisLine(width: 1, color: Resources.chartAxisColor),
            ),
            primaryYAxis: NumericAxis(
              maximum: widget.yMax,
              minimum: widget.yMin,
              associatedAxisName: '',
              // axisLine:
              //     const AxisLine(width: 1, color: Resources.chartAxisColor),
              // title: AxisTitle(text: 'TDS (ppm)')
            )));
  }
}

class ChartBar extends StatefulWidget {
  final List<LiveData> chartData;
  final void Function(ChartSeriesController controller) onRendererCreated;

  final double? xMin;
  final double? xMax;
  final double? yMin;
  final double? yMax;
  final String title;

  const ChartBar(
      {Key? key,
      required this.chartData,
      required this.onRendererCreated,
      this.title = '',
      this.xMax,
      this.xMin,
      this.yMax,
      this.yMin})
      : super(key: key);

  @override
  State<ChartBar> createState() => _ChartBarState();
}

class _ChartBarState extends State<ChartBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SfCartesianChart(
      title: ChartTitle(
        text: widget.title,
        textStyle: Theme.of(context).textTheme.bodyLarge,
      ),
      series: <ChartSeries<LiveData, double>>[
        ColumnSeries<LiveData, double>(
          onRendererCreated: widget.onRendererCreated,
          dataSource: widget.chartData,
          color: Resources.chartColor,
          xValueMapper: (LiveData sales, _) => sales.time,
          yValueMapper: (LiveData sales, _) => sales.speed,
        )
      ],
      enableAxisAnimation: true,
      primaryXAxis: NumericAxis(
          // edgeLabelPlacement: EdgeLabelPlacement.shift,
          maximum: widget.xMin,
          minimum: widget.xMax,
          majorTickLines: const MajorTickLines(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          minorGridLines: const MinorGridLines(width: 2)
          // axisLine:
          //     const AxisLine(width: 1, color: Resources.chartAxisColor),
          ),
      primaryYAxis: NumericAxis(
          maximum: widget.yMax,
          minimum: widget.yMin,
          associatedAxisName: '',
          maximumLabelWidth: 0,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          minorGridLines: const MinorGridLines(width: 2)
          // axisLine:
          //     const AxisLine(width: 1, color: Resources.chartAxisColor),
          // title: AxisTitle(text: 'TDS (ppm)')
          ),
      // plotAreaBorderColor: Colors.white,
      plotAreaBorderWidth: 0,
      borderWidth: 0,
    ));
  }
}

class CircleChart extends StatefulWidget {
  final String circleTxt;
  final String title;

  final List<ColoredData> chartData;
  final void Function(CircularSeriesController controller) onRendererCreated;
  const CircleChart(
      {Key? key,
      required this.chartData,
      required this.onRendererCreated,
      required this.circleTxt,
      required this.title})
      : super(key: key);

  @override
  State<CircleChart> createState() => _CircleChartState();
}

class _CircleChartState extends State<CircleChart> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SfCircularChart(annotations: [
      CircularChartAnnotation(
          widget: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.title,
            style: Resources.smallBoldTitle,
          ),
          Expanded(
            child: Center(
              child: Text(
                '${widget.circleTxt}\n',
                style: Resources.subtitle,
              ),
            ),
          ),
        ],
      ))
    ], series: <CircularSeries>[
      DoughnutSeries<ColoredData, String>(
          onRendererCreated: widget.onRendererCreated,
          dataSource: widget.chartData,
          pointColorMapper: (ColoredData data, _) => data.c,
          xValueMapper: (ColoredData data, _) => data.y,
          yValueMapper: (ColoredData data, _) => data.deg,
          innerRadius: '80%')
    ]));
  }
}

class ColoredData {
  final double deg;
  final String y;
  Color c;
  ColoredData(this.deg, this.y, this.c);
}

class LiveData {
  LiveData(this.time, this.speed);
  final double time;
  final double speed;
}
