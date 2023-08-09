import 'package:final_project/Components/TanksCards.dart';
import 'package:final_project/Models/Tanks.dart';
import 'package:final_project/Pages/views/PartsTanks_list_view.dart';
import 'package:flutter/material.dart';


class TanksPage extends StatefulWidget {
  final Tanks tanks;
  const TanksPage({Key? key, required this.tanks}) : super(key: key);

  @override
  _TanksPageState createState() => _TanksPageState();
}

class _TanksPageState extends State<TanksPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400, // Some height
        child: Column(
          children: [
            TanksCards(tank: widget.tanks),
            PartsTanks_list_view(tankId: widget.tanks.id),
          ],
        ));
  }
}
