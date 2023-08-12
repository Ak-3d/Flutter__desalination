import 'package:flutter/material.dart';

import '../Pages/Dashboard.dart';
import '../main.dart';

class TanksSetup extends StatefulWidget {
  const TanksSetup({Key? key}) : super(key: key);

  @override
  _TanksSetupState createState() => _TanksSetupState();
}

class _TanksSetupState extends State<TanksSetup> {
  final plantNameController = TextEditingController();
  final portPinController = TextEditingController();
  final tdsValueController = TextEditingController();

  void creatTank() {
    if (portPinController.text.isNotEmpty &&
        plantNameController.text.isNotEmpty) {
      print("max");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Tank"),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // persistentFooterButtons: [FloatingActionButton(onPressed:()=> currentDate=currentDate)],
      body: Column(children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0 ,vertical: 20.0),
            child: TextField(
              controller: plantNameController,
              decoration: const InputDecoration(
                labelText: 'Plant Name',
              ),
            )),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
            child: TextField(
              controller: portPinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Port Pin',
              ),
            )),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
            child: TextField(
              controller: tdsValueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'TDS Value',
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              const Spacer(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton(
                  child: const Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    creatTank();
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Succsussfully Saved !! "),
                        content:
                            const Text("Do You want to add a new Tank ?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Container(
                              
                              padding: const EdgeInsets.all(14),
                              child: const Text("Continue"),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigator.pushAndRemoveUntil(context,Dashboard());
                            },
                            child: Container(
                              
                              padding: const EdgeInsets.all(14),
                              child: const Text("Yes"),
                            ),
                          ),
                        ],
                      ),
                    );
                    // Navigator.pushNamed(context, '/ScheduleSetup');
                  })
            ],
          ),
        ),
      ]),
    );
  }
}
