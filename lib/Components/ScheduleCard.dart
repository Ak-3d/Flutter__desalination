import 'package:day_picker/day_picker.dart';
import 'package:final_project/Components/CardDash.dart';
import 'package:final_project/Core/ScheduleSetup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../Widgets/ShowDays.dart';

class ScheduleCard extends StatefulWidget {
  final int tankId;
  final int scheduleId;
  final List<int> selectDays;
  final String time;
  final String plantName;
  const ScheduleCard({
    Key? key,
    this.tankId = 0,
    this.scheduleId = 0,
    this.selectDays = const [],
    this.time = "10:00",
    this.plantName = "Drink",
  }) : super(key: key);

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late List<String> dayName = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
  late List<DayInWeek> _days;
  @override
  void initState() {
    super.initState();
    _days = List<DayInWeek>.generate(dayName.length, (index) {
      return DayInWeek(dayName[index],
          dayKey: '${index + 1}',
          isSelected: widget.selectDays.contains(index + 1));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
          color: Color.fromARGB(14, 154, 152, 154),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(30, 0, 0, 0),
                offset: Offset(0, 1),
                blurRadius: 1)
          ]),
      child: Column(children: [
        StaggeredGrid.count(
          crossAxisCount: 5,
          mainAxisSpacing: 5,
          crossAxisSpacing: 10,
          children: [
            CardDash(
              cols: 5,
              rows: 1,
              title: 'Selected Days',
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowDays(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        days: _days,
                        border: true,
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            colors: [Color(0xFFE55CE4), Color(0xFFBB75FB)],
                            tileMode: TileMode
                                .repeated, // repeats the gradient over the canvas
                          ),
                        ),
                      ))),
            ),
            CardDash(
              cols: 2,
              title: 'Tank Name',
              child: Text(widget.plantName),
            ),
            CardDash(
              cols: 2,
              title: 'Time',
              child: Text(widget.time),
            ),
            SizedBox(
              width: 100, // <-- Your width
              height: 75,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minimumSize: const Size(100, 40), //////// HERE
                ),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScheduleSetup(
                              tankId: widget.tankId,
                              scheduleId: widget.scheduleId)));
                  Navigator.pop(context);
                },
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
