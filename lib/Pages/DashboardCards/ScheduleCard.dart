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
      required this.onRendererCreated});

  final Schedule schedule;
  final String duration;

  final List<LiveData> chartData;
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
                              'From Tank ${widget.schedule.tanks.target?.id ?? 0}',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Text(widget.schedule.time.toIso8601String(),
                        style: Theme.of(context).textTheme.bodySmall),
                  ]),
            ),
            Expanded(
                child: Center(
                    child: ChartBar(
              chartData: widget.chartData,
              onRendererCreated: widget.onRendererCreated,
            )))
          ],
        ));
  }
}
