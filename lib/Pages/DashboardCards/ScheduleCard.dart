import 'dart:async';

import 'package:final_project/Components/CustomCard.dart';
import 'package:final_project/Components/ChartTds.dart';
import 'package:final_project/Models/Irrigation.dart';
import 'package:final_project/Models/Schedule.dart';
import 'package:final_project/Models/SingleTank.dart';
import 'package:final_project/Models/Tanks.dart';
import 'package:final_project/main.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ScheduleCard extends StatefulWidget {
  const ScheduleCard({
    super.key,
    required this.chartData,
    required this.onRendererCreated,
    required this.scheduling,
    required this.infos,
    required this.duration,
  });

  final String infos;
  final String duration;
  final List<NamedData> chartData;
  final IrrigationDashboardData scheduling;
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
    return CustomCard(
        title: '',
        cols: 2,
        rows: 1,
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, '/SchedulePage'),
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
                            Text(widget.infos,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Text(
                          widget.scheduling.dates.isEmpty
                              ? ''
                              : widget.scheduling.dates[0].toString(),
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
          ),
        ));
  }
}

enum Status {
  pending,
  running,
  finished,
}

class IrrigationDashboardData {
  late final List<Schedule> schedules;
  final List<int> ports = [];
  final List<int> indices = [];
  final List<Status> status = [];
  final List<DateTime> dates = [];
  final List<Irrigation> irrigations = [];
  final List<double> levels = [];
  final Map<int, SingleTank> mapLiveTanks;

  int length = 0;
  int index = 0;

  IrrigationDashboardData(this.mapLiveTanks) {
    DateTime nowTemp = DateTime.now();
    final weekDay = ((nowTemp.weekday + 1) % 7) + 1;

    var schBuild = objectbox.schedule
        .query(Schedule_.hours
            .greaterOrEqual(nowTemp.hour)
            .and(Schedule_.mins.greaterThan(nowTemp.minute)))
        .order(Schedule_.hours); //sort by hours

    schBuild.backlink(Days_.schedule, Days_.day.equals(weekDay));

    List<Schedule> scs = schBuild.build().find();
    scs.sort((a, b) => a.mins.compareTo(b.mins)); //sort by mins

    schedules = scs;
    length = schedules.length;
    for (var i = 0; i < length; i++) {
      dates.add(DateTime(nowTemp.year, nowTemp.month, nowTemp.day,
          schedules[i].hours, schedules[i].mins));

      Irrigation irr = Irrigation(
          schedules[i].tanks.target!.irrigationVolume,
          schedules[i].tanks.target!.plantName,
          schedules[i].tanks.target!.portNumber,
          schedules[i].tanks.target!.tdsValue,
          schedules[i].tanks.targetId,
          schedules[i].tanks.target!.createdDate);
      irr.schedule.target = schedules[i];
      irrigations.add(irr);
      status.add(Status.pending);

      ports.add(irrigations[i].tankPort);
      levels.add(0);
    }
  }
  bool isFinished() {
    return status.fold<bool>(
        true,
        (previousValue, element) =>
            element == Status.finished && previousValue);
  }

  void popFinished(i) {
    schedules.removeAt(i);
    ports.removeAt(i);
    dates.removeAt(i);
    status.removeAt(i);
    irrigations.removeAt(i);
    levels.removeAt(i);
    length--;
  }
}
