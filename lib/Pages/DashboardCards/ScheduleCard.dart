import 'package:final_project/Components/CardDash.dart';
import 'package:final_project/Components/ChartTds.dart';
import 'package:final_project/Models/Schedule.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ScheduleCard extends StatefulWidget {
  const ScheduleCard(
      {super.key,
      required this.schedule,
      required this.duration,
      required this.chartData,
      required this.date,
      required this.onRendererCreated});

  final Schedule schedule;
  final String duration;
  final DateTime? date;
  final List<NamedData> chartData;
  final void Function(ChartSeriesController controller) onRendererCreated;
  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late double xMax = 14;
  double yMax = 10000;
  double step = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardDash(
        title: '',
        cols: 2,
        rows: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Upcoming Schedule',
                        style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(widget.duration,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge),
                          const Text(''),
                          Text(
                              widget.date == null
                                  ? '...'
                                  : 'From Tank ${widget.schedule.tanks.target?.portNumber ?? 0}',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Text(widget.date == null ? '' : widget.date.toString(),
                        style: Theme.of(context).textTheme.bodySmall),
                  ]),
            ),
            const Spacer(),
            Expanded(
                flex: 2,
                child: Center(
                    child: ChartBar(
                  xMin: 0,
                  xMax: widget.chartData.length.toDouble() * 10,
                  chartData: widget.chartData,
                  onRendererCreated: widget.onRendererCreated,
                )))
          ],
        ));
  }
}
