import 'package:final_project/Components/CustomCard.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:final_project/Pages/DashboardCards/StatsCard.dart';
import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ManualControlPage extends StatefulWidget {
  const ManualControlPage({Key? key}) : super(key: key);

  @override
  _ManualControlPageState createState() => _ManualControlPageState();
}

class _ManualControlPageState extends State<ManualControlPage>
    implements ConnectionInterface {
  bool mainPump = false;
  bool plantPump = false;
  bool drinkPump = false;
  bool plantValve = false;
  bool drinkValve = false;
  TextEditingController tdsController = TextEditingController();
  FocusNode tdsFocusNode = FocusNode();
  bool tdsHasFocus = false;
  final formKey = GlobalKey<FormState>();
  bool validated = true;
  ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();
  @override
  void initState() {
    super.initState();
    ciw.setInterface(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Resources.bgcolor,
      appBar: AppBar(
        title: const Text("Control Pumps And Valves Manually"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StaggeredGrid
                .count(crossAxisCount: 2, mainAxisSpacing: 20, children: [
              CustomCard(
                cols: 2,
                rows: 0.5,
                title: "Main System:",
                child: StaggeredGrid.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    StatsBody(
                      title: "Main Pump",
                      data: mainPump ? "ON" : "OFF",
                      icon: mainPump
                          ? Icons.circle_rounded
                          : Icons.circle_outlined,
                    ),
                    CustomCard(
                      cols: 1,
                      rows: 0.3,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black
                                        .withAlpha((255 * 0.25).toInt()),
                                    offset: const Offset(0, 7),
                                    blurRadius: 4)
                              ]),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainPump
                                  ? Resources.passcolor
                                  : Resources.switchoff,

                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              /////// HERE
                            ),
                            onPressed: () {
                              // setState(() {
                              //   mainPump = !mainPump;
                              // });
                              FlutterBackgroundService().invoke('Send',
                                  {'msg': 'mainpump:${!mainPump ? 0 : 1}'});
                            },
                            child: Text("Switch",
                                style:
                                    TextStyle(color: Resources.txtColorSwitch)),
                          )),
                    ),
                    CustomCard(
                        cols: 1,
                        rows: 0.3,
                        child: TextField(
                          controller: tdsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Please Enter TDS Value",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              FlutterBackgroundService()
                                  .invoke('Send', {'msg': 'setTds:${500}'});
                            }else
                            {
                               FlutterBackgroundService()
                                  .invoke('Send', {'msg': 'setTds:$value'});
                            }
                          },
                        )),
                  ],
                ),
              ),
              CustomCard(
                cols: 2,
                rows: 0.5,
                title: "Drink System:",
                child: StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    StatsBody(
                      title: "Drink Pump",
                      data: drinkPump ? "ON" : "OFF",
                      icon: drinkPump
                          ? Icons.circle_rounded
                          : Icons.circle_outlined,
                    ),
                    CustomCard(
                      cols: 1,
                      rows: 0.3,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black
                                        .withAlpha((255 * 0.25).toInt()),
                                    offset: const Offset(0, 7),
                                    blurRadius: 4)
                              ]),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: drinkPump
                                  ? Resources.passcolor
                                  : Resources.switchoff,

                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              /////// HERE
                            ),
                            onPressed: () {
                              // setState(() {
                              //   drinkPump = !drinkPump;
                              // });
                              FlutterBackgroundService().invoke('Send',
                                  {'msg': 'drinkpump:${!drinkPump ? 0 : 1}'});
                            },
                            child: Text("Switch",
                                style:
                                    TextStyle(color: Resources.txtColorSwitch)),
                          )),
                    ),
                    StatsBody(
                      title: "Drink Valve",
                      data: drinkValve ? "ON" : "OFF",
                      icon: drinkValve
                          ? Icons.circle_rounded
                          : Icons.circle_outlined,
                    ),
                    CustomCard(
                      cols: 1,
                      rows: 0.3,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black
                                        .withAlpha((255 * 0.25).toInt()),
                                    offset: const Offset(0, 7),
                                    blurRadius: 4)
                              ]),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: drinkValve
                                  ? Resources.passcolor
                                  : Resources.switchoff,

                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              /////// HERE
                            ),
                            onPressed: () {
                              // setState(() {

                              //    drinkValve = !drinkValve;

                              // });
                              FlutterBackgroundService().invoke('Send',
                                  {'msg': 'drinkvalve:${!drinkValve ? 0 : 1}'});
                            },
                            child: Text("Switch",
                                style:
                                    TextStyle(color: Resources.txtColorSwitch)),
                          )),
                    ),
                  ],
                ),
              ),
              CustomCard(
                cols: 2,
                rows: 0.5,
                title: "Plant System:",
                child: StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    StatsBody(
                      title: "Plant Pump",
                      data: plantPump ? "ON" : "OFF",
                      icon: plantPump
                          ? Icons.circle_rounded
                          : Icons.circle_outlined,
                    ),
                    CustomCard(
                      cols: 1,
                      rows: 0.3,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black
                                        .withAlpha((255 * 0.25).toInt()),
                                    offset: const Offset(0, 7),
                                    blurRadius: 4)
                              ]),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: plantPump
                                  ? Resources.passcolor
                                  : Resources.switchoff,

                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              /////// HERE
                            ),
                            onPressed: () {
                              // setState(() {
                              //   plantPump = !plantPump;
                              // });
                              FlutterBackgroundService().invoke('Send',
                                  {'msg': 'plantpump:${!plantPump ? 0 : 1}'});
                            },
                            child: Text("Switch",
                                style:
                                    TextStyle(color: Resources.txtColorSwitch)),
                          )),
                    ),
                    StatsBody(
                      title: "Plant Valve",
                      data: plantValve ? "ON" : "OFF",
                      icon: plantValve
                          ? Icons.circle_rounded
                          : Icons.circle_outlined,
                    ),
                    CustomCard(
                      cols: 1,
                      rows: 0.3,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black
                                        .withAlpha((255 * 0.25).toInt()),
                                    offset: const Offset(0, 7),
                                    blurRadius: 4)
                              ]),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: plantValve
                                  ? Resources.passcolor
                                  : Resources.switchoff,

                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              /////// HERE
                            ),
                            onPressed: () {
                              // setState(() {
                              //   plantValve = !plantValve;
                              // });
                              FlutterBackgroundService().invoke('Send',
                                  {'msg': 'plantvalve:${!plantValve ? 0 : 1}'});
                            },
                            child: Text("Switch",
                                style:
                                    TextStyle(color: Resources.txtColorSwitch)),
                          )),
                    ),
                  ],
                ),
              ),
            ]),
          )),
    );
  }

  @override
  void connected() {
    // TODO: implement connected
  }

  @override
  void interrupted(data) {
    // TODO: implement interrupted
  }

  @override
  void listen(data) {
    if (!mounted) return;

    final pumpValve = data[ObjName.pumpsAndValves.index];
    if (pumpValve != null) {
      setState(() {
        mainPump = (pumpValve[ActutureStatusData.mainPump.index] == '0')
            ? true
            : false;
        drinkPump = (pumpValve[ActutureStatusData.drinkPump.index] == '0')
            ? true
            : false;
        drinkValve = (pumpValve[ActutureStatusData.drinkValve.index] == '0')
            ? true
            : false;
        plantPump = (pumpValve[ActutureStatusData.plantPump.index] == '0')
            ? true
            : false;
        plantValve = (pumpValve[ActutureStatusData.plantValve.index] == '0')
            ? true
            : false;
      });
    }
  }
}
