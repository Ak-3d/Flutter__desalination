import 'dart:async';
import 'dart:math';
import 'package:final_project/Components/Common.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:final_project/Resources.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:final_project/Components/ChartTds.dart';
import '../Components/CardDash.dart';

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

  List<LiveData> chartData = [];
  late ChartSeriesController chartController;

  @override
  void initState() {
    super.initState();
    ConnectionHandler.setInterface(this);

    //TODO this is will be used for testing

    // Timer.periodic(Duration(milliseconds: 1), (timer) {
    //   updateDataSource(800 + Random().nextInt(100).toDouble());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AppScofflding(title: 'TDS', listView: [
      StaggeredGrid.count(
        crossAxisCount: 5,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          CardDash(
            txt: status,
            child: Column(
              children: [
                Slider(
                    value: tValue,
                    min: 0,
                    max: 500,
                    onChanged: (v) {
                      setState(() {
                        tValue = v;
                      });
                      updateDataSource(v);
                    }),
                ElevatedButton(
                    onPressed: () => updateDataSource(tValue),
                    child: Text('add Point'))
              ],
            ),
          ),
          CardDash(
            txt: status,
            rows: 1.5,
            cols: 4,
            child: ChartTds(
                chartData: chartData,
                xMin: 0,
                xMax: 1000,
                yMin: 0,
                yMax: 1000,
                onRendererCreated: (ChartSeriesController cc) =>
                    chartController = cc),
          ),
          CardDash(txt: status),
          CardDash(txt: status),
          ElevatedButton(
            onPressed: () {
              popEdited(context);
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

  @override
  void connected() {}

  @override
  void interrupted(data) {
    // TODO: implement interrupted
  }

  @override
  void listen(data) {
    List<String> pairs = data.toString().split(',');
    for (var p in pairs) {
      List<String> pair = p.split(":");
      if (pair[0] == 'TDS') {
        updateDataSource(double.parse(pair[1]));
        break;
      }
    }
  }

  void updateDataSource(double v) {
    time = time + step;

    if (time > 1000) {
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
