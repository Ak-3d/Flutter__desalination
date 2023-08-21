import 'package:final_project/Pages/DashboardCards/StatsCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../Resources.dart';

class IrrigationCard extends StatefulWidget {
  final double tdsValue;
  final double irrigationVolume;
  final int tankPort;
  final String plantName;
  const IrrigationCard({
    Key? key,
    this.tdsValue = 0,
    this.irrigationVolume = 0,
    this.tankPort = 0,
    this.plantName = "Drink",
  }) : super(key: key);

  @override
  _IrrigationCardState createState() => _IrrigationCardState();
}

class _IrrigationCardState extends State<IrrigationCard> {
  @override
  void initState() {
    super.initState();

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
            crossAxisCount: 4,
            mainAxisSpacing: 15,
            crossAxisSpacing: 10,
            children: [
              StatsBody(
                  icon: Icons.takeout_dining_rounded,
                  title: "Tank Name:",
                  data: widget.plantName),
              StatsBody(
                  icon: Icons.pin_end_sharp,
                  title: "Port Pin:",
                  data: " ${widget.tankPort}"),
              StatsBody(
                  icon: Icons.spa_outlined,
                  title: 'TDS value',
                  data: widget.tdsValue.toString()),
              StatsBody(
                  icon: Icons.water_drop,
                  title: "Irrigation Volume:",
                  data: " ${widget.irrigationVolume}"),
            ])
      ]),
    );
  }
}
