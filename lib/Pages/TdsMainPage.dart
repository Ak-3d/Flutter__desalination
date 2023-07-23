import 'dart:async';
import 'package:final_project/Components/Common.dart';
import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:final_project/Components/ChartTds.dart';
import '../Components/CardDash.dart';

class TdsMainPage extends StatefulWidget {
  const TdsMainPage({Key? key}) : super(key: key);

  @override
  State<TdsMainPage> createState() => _TdsMainPageState();
}

class _TdsMainPageState extends State<TdsMainPage> {
  String status = "";
  double value = 0;

  @override
  Widget build(BuildContext context) {
    return AppScofflding(title: 'TDS', listView: [
      StaggeredGrid.count(
        crossAxisCount: 5,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          CardDash(txt: status),
          CardDash(
            txt: status,
            rows: 3,
            cols: 4,
            child: ChartTds(),
          ),
          CardDash(txt: status),
          CardDash(txt: status),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Go Back'),
          ),
          const StaggeredGridTile.extent(
            mainAxisExtent: 1000,
            crossAxisCellCount: 80,
            child: Text(""),
          ),
        ],
      ),
    ]);
  }
}
