import 'package:final_project/Components/IrrigationCard.dart';
import 'package:final_project/Models/Irrigation.dart';
import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../main.dart';

class IrrigationPage extends StatefulWidget {
  const IrrigationPage({Key? key}) : super(key: key);

  @override
  _IrrigationPageState createState() => _IrrigationPageState();
}

class _IrrigationPageState extends State<IrrigationPage> {
  late List<IrrigationCard> irrigationCard;
  @override
  void initState() {
    List<Irrigation> allIrrigations = objectbox.irrigation.getAll();
    super.initState();

    irrigationCard = [];

    for (var one in allIrrigations) {
      irrigationCard.add(IrrigationCard(
        plantName: one.plantName,
        irrigationVolume: one.irrigationVolume,
        tankPort: one.tankPort,
        tdsValue: one.tdsValue,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Resources.bgcolor,
      appBar: AppBar(
        title: const Text("All Irrigations Scheduled"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              children: irrigationCard,
            ),
          )),
    );
  }
}
