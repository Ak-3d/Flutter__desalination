import 'package:final_project/Models/Schedule.dart';
import 'package:final_project/Widgets/SelectTank.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../Components/ScheduleCard.dart';
import '../Models/Days.dart';
import '../main.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late List<ScheduleCard> scheduleCard;
  @override
  void initState() {
    List<Schedule> allSchedule = objectbox.schedule.getAll();
    super.initState();

    scheduleCard = [];

    for (var one in allSchedule) {
      scheduleCard.add(ScheduleCard(
        tankId: one.tanks.targetId,
        scheduleId: one.id,
        plantName: objectbox.tanks.get(one.tanks.targetId)!.plantName,
        selectDays: one.days.cast<Days>().map<int>((e) => e.day).toList(),
        time: "${one.hours}:${one.mins}",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Schedules"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              children: scheduleCard,
            ),
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await selectTank(context, "Choose Tank");
          },
          child: const Icon(Icons.add)),
    );
  }
}
