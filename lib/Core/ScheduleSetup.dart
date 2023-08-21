// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:final_project/Pages/Dashboard.dart';
import 'package:final_project/Resources.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/Days.dart';
import '../Models/Schedule.dart';
import '../Models/Tanks.dart';
import '../Widgets/alertShow.dart';
import '../main.dart';
import 'package:day_picker/day_picker.dart';

class ScheduleSetup extends StatefulWidget {
  final int tankId;
  final int scheduleId;
  const ScheduleSetup({Key? key, required this.tankId, this.scheduleId = 0})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleSetupState createState() => _ScheduleSetupState();
}

class _ScheduleSetupState extends State<ScheduleSetup> {
  late Tanks tank;
  late Schedule schedule;
  late Days days;
  final formKey = GlobalKey<FormState>();
  bool deleteVisibleBtn = false;
  bool validated = true;
  TextEditingController timeInput = TextEditingController();
  FocusNode timeInputFocusNode = FocusNode();
  bool timeInputHasFocus = true;
  late int hours;
  late int minutes;

  List<String> selectDays = ["1"];
  List<String> dayName = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
  List<DayInWeek> _days = [
    DayInWeek(
      dayKey: "2",
      "Sun",
    ),
    DayInWeek(
      dayKey: "3",
      "Mon",
    ),
    DayInWeek(dayKey: "4", "Tue", isSelected: true),
    DayInWeek(
      dayKey: "5",
      "Wed",
    ),
    DayInWeek(
      dayKey: "6",
      "Thu",
    ),
    DayInWeek(
      dayKey: "7",
      "Fri",
    ),
    DayInWeek(
      dayKey: "1",
      "Sat",
    ),
  ];
// Add the database for only add New Schedule
  void addNewSchedule() {
    // tank = objectbox.tanks.get(widget.tankId)!;

    if (widget.scheduleId != 0) {
      schedule.hours = hours;
      schedule.mins = minutes;
      var dTemp = schedule.days.cast<Days>().map<int>((e) => e.id);
      objectbox.days.removeMany(dTemp.toList());
      print("Complete Update Data !!");
    } else {
      schedule = Schedule(hours, minutes, DateTime.now());
      print("Complete Add new  schedule !!");
    }
    schedule.tanks.targetId = widget.tankId;
    schedule.days.addAll(selectDays.map<Days>((e) => Days(int.parse(e))));

    objectbox.schedule.put(schedule);
  }

  // delete the database for only delete task
  void deleteSchedule() {
    var removeDays = objectbox.days.query();
    removeDays.link(Days_.schedule, Schedule_.id.equals(widget.scheduleId));
    removeDays.build().remove();
    objectbox.schedule.remove(widget.scheduleId);

    print("Complete delete  schedule !!");
  }

// check the database for delete or edit existed schedule
  void checkEditOrAdd(int scheduleId) {
    if (widget.tankId != 0 && widget.scheduleId != 0) {
      schedule = objectbox.schedule.get(widget.scheduleId)!;
      hours = schedule.hours;
      minutes = schedule.mins;
      timeInput.text = "${schedule.hours}:${schedule.mins}";
      var dTemp = schedule.days.cast<Days>().map<int>((e) => e.day);
      selectDays = [];
      _days = List<DayInWeek>.generate(dayName.length, (index) {
        if (dTemp.contains(index + 1)) {
          selectDays.add('${index + 1}');
        }
        return DayInWeek(dayName[index],
            dayKey: '${index + 1}', isSelected: dTemp.contains(index + 1));
      });
// we can not delete the default
      if (widget.scheduleId != 0) {
        deleteVisibleBtn = true;
      }

      print("Schedule ${widget.scheduleId} : you can Edit it !!");
    }
  }

  void nextPage() {
    // Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => const Dashboard()),
        (e) => false);
  }

  void checkDialog(BuildContext context) async {
    late bool statue;
    statue = await alertShow(context, 'Do You want to save ?', 'Verify');
    if (statue) {
      addNewSchedule();
      nextPage();
    }
  }

  void checkDialogDelete(BuildContext context) async {
    late bool statue;
    statue = await alertShow(context, 'Do You want to Delete ?', 'Verify');
    if (statue) {
      deleteSchedule();
      nextPage();
    }
  }

  @override
  void initState() {
    super.initState();
    tank = objectbox.tanks.get(widget.tankId)!;
    checkEditOrAdd(widget.scheduleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Schedule (${tank.plantName})"),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(left: 35.0),
                margin: const EdgeInsets.only(top: 20, right: 5, left: 10),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
                margin: const EdgeInsets.only(
                    top: 20, bottom: 2, right: 1, left: 10),
                child: Row(
                  children: [
                    Icon(Icons.timer),
                    Text("  "),
                    Expanded(
                      child: TextFormField(
                        focusNode: timeInputFocusNode,
                        controller:
                            timeInput, //editing controller of this TextField
                        decoration: InputDecoration(
                            labelText: "Enter Time",
                            border: const OutlineInputBorder(),
                            suffixIcon: !validated
                                ? const Icon(Icons.error_outline_rounded,
                                    color: Colors.red)
                                : const SizedBox()),
                        validator: (phoneNo) {
                          if (phoneNo!.isEmpty) {
                            timeInputFocusNode.requestFocus();
                            timeInputHasFocus = true;
                            return "You must enter Time";
                          } else {
                            timeInputHasFocus = false;
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              validated = true;
                              // formKey.currentState!.validate();
                            });
                          }
                        }, //label text of field

                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                          );

                          if (pickedTime != null) {
                            print(pickedTime.format(context)); //output 10:51 PM
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());
                            //converting to DateTime so that we can further format on different pattern.
                            print(parsedTime); //output 1970-01-01 22:53:00.000
                            String formattedTime =
                                DateFormat('HH:mm').format(parsedTime);
                            hours = parsedTime.hour;
                            minutes = parsedTime.minute;
                            print("$hours : $minutes"); //output 14:59:00
                            //DateFormat() is from intl package, you can format the time on any pattern you need.

                            setState(() {
                              timeInput.text =
                                  formattedTime; //set the value of text field.
                            });
                          } else {
                            print("Time is not selected");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
                margin: const EdgeInsets.only(
                    top: 10, bottom: 2, right: 1, left: 10),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded),
                    Text("  "),
                    Expanded(
                      flex: 10,
                      child: SelectWeekDays(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        days: _days,
                        border: false,
                        padding: 10,
                        daysFillColor: Color.fromARGB(255, 92, 11, 255),
                        selectedDayTextColor:
                            Color.fromARGB(255, 255, 255, 255),
                        unSelectedDayTextColor: Colors.grey,
                        backgroundColor: Resources.bgcolor,
                        boxDecoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Resources.chartColor),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onSelect: (values) {
                          // <== Callback to handle the selected days
                          print(values);

                          selectDays = values;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                            child: const Text(
                              "Save",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  validated = formKey.currentState!.validate();
                                  if (selectDays.isEmpty) {
                                    alertDialog(context, "Please Select Days",
                                        "Error Days !!");
                                  } else {
                                    checkDialog(context);
                                  }
                                });
                              } else {
                                setState(() {
                                  validated = formKey.currentState!.validate();
                                });
                              }
                            }),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 2,
                        child: Visibility(
                            visible: deleteVisibleBtn,
                            child: ElevatedButton(
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Resources.failcolor,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                                onPressed: () async {
                                  checkDialogDelete(context);
                                })),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
