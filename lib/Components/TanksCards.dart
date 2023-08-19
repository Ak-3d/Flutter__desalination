import 'package:final_project/Components/CustomCard.dart';
import 'package:final_project/Components/Tank.dart';
import 'package:final_project/Core/Tanks_setup.dart';
import 'package:final_project/Resources.dart';
import 'package:final_project/Widgets/EditButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Pages/DashboardCards/StatsCard.dart';
import '../Widgets/SmallTank.dart';

class TanksCards extends StatefulWidget {
  final int tankId;
  final int portNumber;
  final String plantName;
  final double tdsValue;
  final double quantity;
  const TanksCards(
      {Key? key,
      this.tankId = 0,
      this.portNumber = 0,
      this.plantName = "tankName",
      this.tdsValue = 0.0,
      this.quantity = 0.0})
      : super(key: key);

  @override
  _TanksCardsState createState() => _TanksCardsState();
}

class _TanksCardsState extends State<TanksCards> {
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
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 10,
          children: [
            CustomCard(
              color: const Color.fromARGB(165, 105, 30, 225),
              cols: 1,
              rows: 0.6,
              child: Tank(
                  tankTitle: "tank Level",
                  value: widget.quantity,
                  isFilling: false),
            ),
            StatsBody(
                icon: Icons.takeout_dining_rounded,
                title: "Tank Name:",
                data: widget.plantName),
            StatsBody(
                icon: Icons.pin_end_sharp,
                title: 'Port pin:',
                data: widget.portNumber.toString()),
            StatsBody(
                icon: Icons.spa_outlined,
                title: 'TDS value',
                data: widget.tdsValue.toString()),
            EditButton(editPage: TanksSetup(tankId: widget.tankId)),
          ],
        ),
      ]),
    );
  }
}
