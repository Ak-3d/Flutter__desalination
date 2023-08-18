import 'package:final_project/Components/CustomCard.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:final_project/Pages/DashboardCards/StatsCard.dart';
import 'package:final_project/main.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Components/Tank.dart';
import '../Components/TankVolume.dart';
import '../Models/Tanks.dart';

class SingleTankPage extends StatelessWidget {
  final int tankID;
  const SingleTankPage({super.key, this.tankID = 2});
  @override
  Widget build(BuildContext context) {
    // final tankID = 1;
    final tank = objectbox.tanks.get(tankID);
    // debugPrint('this must be built only once if it is stateless');
    return Scaffold(
      appBar: AppBar(
        title: Text(" ${tank!.plantName} Tank"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              children: [TankPageStfl(tankID: tankID)],
            ),
          )),
    );
    // AppScofflding(listView: [TankPageStfl(tankID: tankID)]);
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
  late Tanks tank;
  double unit = 0;
  double step = 1;
  late double max;

  double level = 0;
  double totalIrrigation = 20;
  bool isFilling = true;
  ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();

  @override
  void initState() {
    super.initState();
    ciw.setInterface(this);
    tank = objectbox.tanks.get(widget.tankID)!;

    final now = DateTime.now();
    final sat = ((now.weekday + 2) % 7) + 1;
    final hours = now.hour;

    final lastSat =
        now.subtract(Duration(days: sat, hours: hours)).millisecondsSinceEpoch;

    var builder = objectbox.singleTank
        .query(SingleTank_.createdDate.greaterOrEqual(lastSat));

    builder.link(SingleTank_.tanks, Tanks_.id.equals(widget.tankID));
    var query = builder.order(SingleTank_.createdDate).build();
    var tankData = query.find();

    if (tankData.isNotEmpty) {
      level = tankData[tankData.length - 1].level;
      isFilling = tankData[tankData.length - 1].isFilling;
    }
    max = (tankData.length / (sat + 1)) * 7;
    max = max < 20 ? 20 : max;
    unit = 0;
    levelData = tankData.map<LiveData>((tnk) {
      final u = unit;
      unit += step;
      return LiveData(u, tnk.level);
    }).toList();
    // debugPrint('unit at initState:$unit');
    var qi = objectbox.irregation
        .query(Irrigation_.tankID.equals(widget.tankID))
        .build();
    // debugPrint(qi.describe());
    var irrgs = qi.find();
    for (var element in irrgs) {
      totalIrrigation += element.irrigationVolume;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 30,
      crossAxisSpacing: 20,
      children: [
        CustomCard(
          cols: 4,
          rows: 1.3,
          child: Expanded(
            flex: 4,
            child: TankVolume(
                xMax: max,
                xMin: 0,
                yMax: 100,
                yMin: 0,
                chartData: levelData,
                onRendererCreated: (controller) =>
                    chartController = controller),
          ),
        ),
        StatsBody(
            icon: Icons.takeout_dining_rounded,
            title: "Tank Name:",
            data: tank.plantName),
        CustomCard(
          cols: 2,
          rows: 0.7,
          child:
              Tank(tankTitle: "tank Level", value: level, isFilling: isFilling),
        ),
        StatsBody(
            icon: isFilling ? Icons.battery_full : Icons.battery_0_bar,
            title: "Tank State :",
            data: '${isFilling ? "Full" : "NOT Full"} '),
        StatsBody(
            icon: Icons.spa_outlined,
            title: "TDS Value :",
            data: "${tank.tdsValue} PPM"),
        StatsBody(
            icon: Icons.water,
            title: "Total Production :",
            data: '$totalIrrigation  Liter'),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ciw.dispose();
    super.dispose();
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
    var obj = data['stank'];
    if (obj == null) return;

    isFilling = obj['isFill'] == '1';
    final level = double.parse(obj['level']);

    if (mounted) {
      //this to double check that the page is disposed
      setState(() {
        this.level = level;
      });
    }
    updateGraph(level);

    // debugPrint('unit: $unit');
    // debugPrint('listenning in tank page');
  }

  void updateGraph(double v) {
    if (unit > max) {
      unit = 0;
      chartController.updateDataSource(
          removedDataIndexes:
              List<int>.generate(levelData.length, (index) => index));
      levelData.clear();
    }

    levelData.add(LiveData(unit, v));
    chartController.updateDataSource(addedDataIndex: levelData.length - 1);
    unit = unit + step;
  }
}
