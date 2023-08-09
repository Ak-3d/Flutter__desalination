import 'package:final_project/Models/Tanks.dart';
import 'package:final_project/Pages/TanksPage.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class Tanks_view extends StatefulWidget {
  const Tanks_view({Key? key}) : super(key: key);

  @override
  _Tanks_viewState createState() => _Tanks_viewState();
}

class _Tanks_viewState extends State<Tanks_view> {
  TanksPage Function(BuildContext, int) _itemBuilder(List<Tanks> tanks) {
    return (BuildContext context, int index) => TanksPage(tanks: tanks[index]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<Tanks>>(
        stream: objectbox.getAllTanks(),
        builder: (context, snapshot) {
          if (snapshot.data?.isNotEmpty ?? false) {
            return ListView.builder(
                // scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                itemBuilder: _itemBuilder(snapshot.data ?? []));
          } else {
            return const Center(child: Text("Press the + icon to add Tanks"));
          }
        });
  }
}
