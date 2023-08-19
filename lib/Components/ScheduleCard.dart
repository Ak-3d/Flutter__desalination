import 'package:day_picker/day_picker.dart';
import 'package:final_project/Components/CustomCard.dart';
import 'package:final_project/Core/ScheduleSetup.dart';
import 'package:final_project/Pages/DashboardCards/StatsCard.dart';
import 'package:final_project/Widgets/EditButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../Resources.dart';
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
       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Resources.bgcolor_100,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha((255 * 0.25).toInt()),
                  offset: const Offset(0, 7),
                  blurRadius: 4)
            ]),
      child: Column(children: [
        StaggeredGrid.count(
          crossAxisCount:3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 10,
          children: [
            
        
             StatsBody(
                icon: Icons.takeout_dining_rounded,
                title: "Tank Name:",
                data: widget.plantName),
             StatsBody(
                icon: Icons.timer,
                title: "Required Time:",
                data: widget.time.toString()),
         
            EditButton(editPage: ScheduleSetup(
                              tankId: widget.tankId,
                              scheduleId: widget.scheduleId)),
           CustomCard(
              cols: 3,
              rows: 0.4,
              title: 'Selected Days',
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowDays(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        days: _days,
                        border: false,
                       
                        daysFillColor: Resources.primaryColor,
                        selectedDayTextColor: Colors.white,
                        unSelectedDayTextColor: Colors.grey,
                        daysBorderColor: Colors.grey,
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                      
                          border: Border.all(width: 1,color: Resources.chartColor)
                        ),
                      ))),
            ),
          ],
        ),
      ]),
    );
  }
}
