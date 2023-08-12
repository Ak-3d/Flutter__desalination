import 'dart:convert';

import 'package:final_project/Components/Common.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:final_project/Models/WaterFlow.dart';

// import 'package:final_project/Resources.dart';
import 'package:final_project/main.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:final_project/Components/ChartTds.dart';
import '../Components/CardDash.dart';
import '../Models/Production.dart';

class TdsMainPage extends StatefulWidget {
  const TdsMainPage({Key? key}) : super(key: key);

  @override
  State<TdsMainPage> createState() => _TdsMainPageState();
}

class _TdsMainPageState extends State<TdsMainPage>
    implements ConnectionInterface {
  String status = "";
  double tValue = 0;

  double time = 0;
  double step = 2;
  int max = 1000;

  late List<LiveData> chartData;
  late ChartSeriesController chartController;

  int colsN = 3;
  num defaultRows = 3;

  late ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();
  @override
  void initState() {
    super.initState();

    //get last saturday, monday = 1, saturday = 6
    final now = DateTime.now();
    final sat = ((now.weekday + 2) % 7) + 1;
    //database query
    Query<WaterFlow> q = objectbox.waterFlow
        .query(WaterFlow_.date.greaterOrEqual(now.subtract(Duration(days: sat)).millisecondsSinceEpoch))
        .order(WaterFlow_.date)
        .build(); //~/ gives

    q.limit = (max ~/ 2);

    chartData = q.find().map<LiveData>((e) {
      double temp = time;
      time += step;
      return LiveData(temp, e.tds);
    }).toList();

    debugPrint('describing:  ${q.describeParameters()}');
    ciw.setInterface(this);

    //TODO this is will be used for testing

    // Timer.periodic(Duration(milliseconds: 1), (timer) {
    //   updateDataSource(800 + Random().nextInt(100).toDouble());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AppScofflding(title: 'TDS', listView: [
      StaggeredGrid.count(
        crossAxisCount: colsN,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          CardDash(
            title: status,
            rows: 1.5,
            cols: 4,
            child: ChartTds(
                chartData: chartData,
                xMin: 0,
                xMax: max.toDouble(),
                yMin: 0,
                yMax: 1000,
                onRendererCreated: (ChartSeriesController cc) =>
                    chartController = cc),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go Back'),
          ),
          const StaggeredGridTile.extent(
            mainAxisExtent: 100,
            crossAxisCellCount: 1,
            child: Text(""),
          ),
        ],
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    ciw.dispose();
  }

  @override
  void connected() {}

  @override
  void interrupted(data) {
    // TODO: implement interrupted
  }

  @override
  void listen(data) {
    var obj = data['flow'];
    if (obj == null) return;

    double tdsV = double.parse(obj['TDS']);
    double tmp = 23;
    double f1 = double.parse(obj['F1']);
    double f2 = 20;
    updateDataSource(tdsV);
    debugPrint('obj recieved ${jsonEncode(data)}');
    if (tdsV > 1) {
      WaterFlow w = WaterFlow(tdsV, f1, f2, tmp, DateTime.now());
      objectbox.waterFlow.put(w);
      debugPrint(
          'new tds inserted: ${w.tds}, F1:${w.flow1}, F2:${w.flow2}');
    }
  }

  void updateDataSource(double v) {
    time = time + step;

    if (time > max) {
      time = 0;
      chartController.updateDataSource(
          removedDataIndexes:
              List<int>.generate(chartData.length, (index) => index));
      chartData.clear();
    }

    chartData.add(LiveData(time, v));
    chartController.updateDataSource(addedDataIndex: chartData.length - 1);
  }
}
