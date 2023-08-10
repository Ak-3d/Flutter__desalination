import 'package:final_project/Components/CardDash.dart';
import 'package:final_project/Components/ChartTds.dart';
import 'package:final_project/Components/Common.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:final_project/main.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TankPage extends StatelessWidget {
  final int tankID;
  const TankPage({super.key, required this.tankID});

  @override
  Widget build(BuildContext context) {
    return AppScofflding(listView: [
      TankPageStfl(
        tankID: tankID,
      )
    ]);
  }
}

class TankPageStfl extends StatefulWidget {
  final int tankID;
  const TankPageStfl({super.key, required this.tankID});
  @override
  State<TankPageStfl> createState() => _TankPageState();
}

class _TankPageState extends State<TankPageStfl>
    implements ConnectionInterface {
  late List<LiveData> levelData;
  late ChartSeriesController chartController;

  double unit = 0;
  late double max;

  double totalIrregation = 0;
  bool isRunning = false;

  ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final now = DateTime.now();
    final sat = ((now.weekday + 2) % 7) - 1;
    final hours = now.hour;

    final lastSat =
        now.subtract(Duration(days: sat, hours: hours)).millisecondsSinceEpoch;

    var builder = objectbox.singleTank
        .query(SingleTank_.createdDate.greaterOrEqual(lastSat));

    builder.link(SingleTank_.tanks, Tanks_.id.equals(widget.tankID));
    var query = builder.build();
    var tankData = query.find();

    max = (tankData.length / (sat + 1)) * 7;

    levelData = tankData.map<LiveData>((tnk) {
      final u = unit;
      unit += 1;
      return LiveData(u, tnk.level);
    }).toList();

    var qi = objectbox.irregation
        .query(Irrigation_.tankID.equals(widget.tankID))
        .build();
    var irrgs = qi.find();
    for (var element in irrgs) {
      totalIrregation += element.irrigationVolume;
    }

    ciw.setInterface(this);
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 1,
      mainAxisSpacing: 10,
      children: [
        CardDash(
          rows: 4,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: ChartTds(
                    xMax: max,
                    xMin: 0,
                    yMax: 1000,
                    yMin: 0,
                    chartData: levelData,
                    onRendererCreated: (controller) =>
                        chartController = controller),
              ),
              Expanded(child: Text('total prodcution: $totalIrregation'))
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ciw.dispose();
  }

  @override
  void connected() {
    // TODO: implement connected
  }

  @override
  void interrupted(data) {
    // TODO: implement interrupted
  }

  @override
  void listen(data) {
    var objs = data.toString().split('|');
    for (var o in objs) {
      var pair = o.split('=');
      if (pair[0] != 'sTank') continue;

      getData(pair[1]);
      break;
    }
  }

  void getData(String d) {
    var pairs = d.split(',');
    double value;
    for (var pair in pairs) {
      switch (pair[0]) {
        case 'level':
          value = double.tryParse(pair[1]) ?? 0;
          break;
      }
    }
  }
}
