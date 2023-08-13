import 'package:final_project/Components/TanksCards.dart';
import 'package:final_project/Core/Tanks_setup.dart';
import 'package:final_project/Models/Tanks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../main.dart';

class TanksPage extends StatefulWidget {
  const TanksPage({Key? key}) : super(key: key);

  @override
  _TanksPageState createState() => _TanksPageState();
}

class _TanksPageState extends State<TanksPage> {
  late List<TanksCards> tankCard;
  @override
  void initState() {
    List<Tanks> allTanks = objectbox.tanks.getAll();
    super.initState();
    
    tankCard = [];

    for (var tank in allTanks) {
      tankCard.add(TanksCards(
        tankId: tank.id,
        plantName: tank.plantName,
        portNumber: tank.portNumber,
        tdsValue: tank.tdsValue,
        quantity: 50,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tanks"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              children: tankCard,
            ),
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TanksSetup()));
            setState(() {});
          },
          child: const Icon(Icons.add)),
    );
  }
}
