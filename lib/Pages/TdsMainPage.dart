import 'package:final_project/Components/Common.dart';
import 'package:final_project/ConnectionHandler.dart';

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

    //database query
    Query<Production> q = objectbox.production.query().build(); //~/ gives
    q.limit = (max ~/ 2);

    chartData = q.find().map<LiveData>((e) {
      double temp = time;
      time += step;
      return LiveData(temp, e.tdsValue);
    }).toList();

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
            txt: status,
            child: ListView(
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
                    child: const Text('add Point'))
              ],
            ),
          ),
          CardDash(txt: status),
          CardDash(txt: status),
          CardDash(
            txt: status,
            rows: 3,
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
            mainAxisExtent: 1000,
            crossAxisCellCount: 80,
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
    List<String> pairs = data.toString().split(',');
    double tdsV = 0;
    double tmp = 23;
    double f1 = 10;
    double f2 = 20;

    for (var p in pairs) {
      List<String> pair = p.split(":");
      switch (pair[0]) {
        case 'TDS':
          tdsV = double.parse(pair[1]);
          updateDataSource(tdsV);
          break;

        case 'F1':
          f1 = double.parse(pair[1]);
          break;
        default:
      }
    }
    if (tdsV > 1) {
      Production w = Production(tdsV, f1, f2, tmp);
      objectbox.production.put(w);
      debugPrint(
          'new tds inserted: ${w.tdsValue}, F1:${w.flowWaterConcentrate}');
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
