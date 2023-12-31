import 'package:final_project/Core/ScheduleSetup.dart';
import 'package:final_project/main.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../Models/Tanks.dart';
import 'alertShow.dart';

late int id;
// int id = 0;
Future<bool> selectTank(BuildContext context, String title) async {
  List<Tanks> tank = objectbox.tanks.getAll();
  var tanksName = tank.map<String>((e) => e.plantName).toList();
  id = objectbox.tanks
      .query(Tanks_.plantName.equals(tanksName[0]))
      .build()
      .findFirst()!
      .id;
  return await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DropdownSearch<String>(
                items: tanksName,
                selectedItem: tanksName[0],
                onChanged: (value) => id = objectbox.tanks
                    .query(Tanks_.plantName.equals(value!))
                    .build()
                    .findFirst()!
                    .id,
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () async {
              await alertDialog(
                  context, 'Complete Choose Tank !', "Add new Schedule Please !");
              nextPage(context);
            },
          ),
          
        ],
      );
    },
  );
}

Future<void> nextPage(BuildContext context) async {
  await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ScheduleSetup(
            tankId: id,
          )));
}
