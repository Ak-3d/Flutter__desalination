import 'package:final_project/Models/SingleTank.dart';
import 'package:final_project/Resources.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';

import '../Models/Tanks.dart';
import '../Pages/Dashboard.dart';
import '../Widgets/alertShow.dart';
import '../main.dart';

class TanksSetup extends StatefulWidget {
  final int tankId;
  const TanksSetup({Key? key, this.tankId = 0}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TanksSetupState createState() => _TanksSetupState();
}

class _TanksSetupState extends State<TanksSetup> {
  late Tanks tank;
  final formKey = GlobalKey<FormState>();
  bool validated = true;

  TextEditingController plantNameController = TextEditingController();
  FocusNode plantNameFocusNode = FocusNode();
  bool plantNameHasFocus = false;

  TextEditingController portPinController = TextEditingController();
  FocusNode portPinFocusNode = FocusNode();
  bool portPinHasFocus = false;

  TextEditingController tdsValueController = TextEditingController();
  FocusNode tdsValueFocusNode = FocusNode();
  bool tdsValueHasFocus = false;

  TextEditingController irrigationValueController = TextEditingController();
  FocusNode irrigationValueFocusNode = FocusNode();
  bool irrigationValueHasFocus = false;
  bool deleteVisibleBtn = false;

// Add the database for only add new task
  void addTank() {
    if (widget.tankId != 0) {
      tank.plantName = plantNameController.text;
      tank.portNumber = int.parse(portPinController.text);
      tank.irrigationVolume = double.parse(irrigationValueController.text);
      tank.tdsValue = double.parse(tdsValueController.text);
      tank.modifiedDate = DateTime.now();
      print("Complete Update Data !!");
    } else {
      tank = Tanks(
          int.parse(portPinController.text),
          plantNameController.text,
          double.parse(tdsValueController.text),
          double.parse(irrigationValueController.text));
      var singletank = SingleTank(0, false);
      singletank.tanks.target = tank;
      print("Complete Add new  Tank !!");
    }
    objectbox.tanks.put(tank);
  }

  // delete the database for only delete task
  void deleteTank() {
    var qurySchedule = objectbox.schedule.query();
    qurySchedule.link(Schedule_.tanks, Tanks_.id.equals(widget.tankId));
    var scheduleBuild = qurySchedule.build();
    var scheduleIds = scheduleBuild.findIds();

    for (var s in scheduleIds) {
      var removeDays = objectbox.days.query();
      removeDays.link(Days_.schedule, Schedule_.id.equals(s));
      removeDays.build().remove();
    }
    scheduleBuild.remove();
    objectbox.tanks.remove(widget.tankId);
    print("Complete delete  Tank !!");
  }

// check the database for delete or edit existed task
  void checkEditOrAdd(int tankId) {
    if (tankId != 0) {
      tank = objectbox.tanks.get(tankId)!;
      plantNameController.text = tank.plantName;
      portPinController.text = tank.portNumber.toString();
      tdsValueController.text = tank.tdsValue.toString();
      irrigationValueController.text = tank.irrigationVolume.toString();
      if (tankId >= 3) {
        // we can not delete the default tanks
        deleteVisibleBtn = true;
      }
      print("Tank $tankId : you can Edit it !!");
    }
  }

  void nextPage() {
    // Navigator.pop(context
    //     // ,MaterialPageRoute<void>(
    //     //     builder: (BuildContext context) => const Dashboard()),
    //     );
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
      addTank();
      nextPage();
    }
  }

  void checkDialogDelete(BuildContext context) async {
    late bool statue;
    statue = await alertShow(context, 'Do You want to Delete ?', 'Verify');
    if (statue) {
      deleteTank();
      nextPage();
    }
  }

  @override
  void initState() {
    super.initState();
    checkEditOrAdd(widget.tankId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Tank"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(children: [
                  Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 35.0),
                      margin:
                          const EdgeInsets.only(top: 20, right: 5, left: 10),
                      child: Text(
                        "Enter Plant Name :",
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      margin: const EdgeInsets.only(
                          top: 1, bottom: 2, right: 1, left: 10),
                      child: TextFormField(
                        focusNode: plantNameFocusNode,
                        controller: plantNameController,
                        decoration: InputDecoration(
                            labelText: "Please Enter Plant Name",
                            border: const OutlineInputBorder(),
                            suffixIcon: !validated
                                ? const Icon(Icons.error_outline_rounded,
                                    color: Colors.red)
                                : const SizedBox()),
                        validator: (phoneNo) {
                          if (phoneNo!.isEmpty) {
                            plantNameFocusNode.requestFocus();
                            plantNameHasFocus = true;
                            return "You must enter Plant Name";
                          } else {
                            plantNameHasFocus = false;
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
                        },
                      )),
                  Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 35.0),
                      margin:
                          const EdgeInsets.only(top: 20, right: 5, left: 10),
                      child: Text(
                        "Enter Port pin Number :",
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      margin: const EdgeInsets.only(
                          top: 1, bottom: 2, right: 1, left: 10),
                      child: TextFormField(
                        focusNode: portPinFocusNode,
                        controller: portPinController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Please Enter Port Pin",
                            border: const OutlineInputBorder(),
                            suffixIcon: !validated
                                ? const Icon(Icons.error_outline_rounded,
                                    color: Colors.red)
                                : const SizedBox()),
                        validator: (phoneNo) {
                          if (phoneNo!.isEmpty) {
                            portPinFocusNode.requestFocus();
                            portPinHasFocus = true;
                            return "You must enter port Pin";
                          } else {
                            portPinHasFocus = false;
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
                        },
                      )),
                  Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 35.0),
                      margin:
                          const EdgeInsets.only(top: 20, right: 5, left: 10),
                      child: Text(
                        "Enter TDS Value :",
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      margin: const EdgeInsets.only(
                          top: 1, bottom: 2, right: 1, left: 10),
                      child: TextFormField(
                        focusNode: tdsValueFocusNode,
                        controller: tdsValueController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Please Enter TDS Value",
                            border: const OutlineInputBorder(),
                            suffixIcon: !validated
                                ? const Icon(Icons.error_outline_rounded,
                                    color: Colors.red)
                                : const SizedBox()),
                        validator: (phoneNo) {
                          if (phoneNo!.isEmpty) {
                            tdsValueFocusNode.requestFocus();
                            tdsValueHasFocus = true;
                            return "You must enter TDS Value";
                          } else {
                            tdsValueHasFocus = false;
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
                        },
                      )),
                  Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 35.0),
                      margin:
                          const EdgeInsets.only(top: 20, right: 5, left: 10),
                      child: Text(
                        "Enter Irrigation Volume  :",
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      margin: const EdgeInsets.only(
                          top: 1, bottom: 2, right: 1, left: 10),
                      child: TextFormField(
                        focusNode: irrigationValueFocusNode,
                        controller: irrigationValueController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Please Enter Irrigation Volume",
                            border: const OutlineInputBorder(),
                            suffixIcon: !validated
                                ? const Icon(Icons.error_outline_rounded,
                                    color: Colors.red)
                                : const SizedBox()),
                        validator: (phoneNo) {
                          if (phoneNo!.isEmpty) {
                            irrigationValueFocusNode.requestFocus();
                            irrigationValueHasFocus = true;
                            return "You must enter Irrigation Volume";
                          } else {
                            irrigationValueHasFocus = false;
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              validated = true;
                              formKey.currentState!.validate();
                            });
                          }
                        },
                      )),
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
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      validated =
                                          formKey.currentState!.validate();

                                      checkDialog(context);
                                    });
                                  } else {
                                    setState(() {
                                      validated =
                                          formKey.currentState!.validate();
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                ]))));
  }
}
