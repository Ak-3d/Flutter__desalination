import 'package:final_project/Components/CardDash.dart';
import 'package:final_project/Components/ChartTds.dart';
import 'package:final_project/Components/Common.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:final_project/Resources.dart';
import 'package:final_project/main.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TankPage extends StatelessWidget {
  const TankPage({super.key});
  @override
  Widget build(BuildContext context) {
    final tankID = ModalRoute.of(context)!.settings.arguments as int;
    debugPrint('this must be built only once if it is stateless');
    return AppScofflding(listView: [TankPageStfl(tankID: tankID)]);
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
  double step = 1;
  late double max;

  double level = 0;
  double totalIrrigation = 0;
  bool isFilling = false;
  ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ciw.setInterface(this);

    final now = DateTime.now();
    final sat = ((now.weekday + 2) % 7) + 1;
    final hours = now.hour;

    final lastSat =
        now.subtract(Duration(days: sat, hours: hours)).millisecondsSinceEpoch;

    var builder = objectbox.singleTank
        .query(SingleTank_.createdDate.greaterOrEqual(lastSat));

    builder.link(SingleTank_.tanks, Tanks_.id.equals(widget.tankID));
    var query = builder.build();
    var tankData = query.find();

    max = (tankData.length / (sat + 1)) * 7;
    max = max < 20 ? 20 : max;
    unit = 0;
    levelData = tankData.map<LiveData>((tnk) {
      final u = unit;
      unit += step;
      return LiveData(u, tnk.level);
    }).toList();
    debugPrint('unit at initState:$unit');
    var qi =
    objectbox.irregation.query(Irrigation_.tankID.equals(widget.tankID)).build();
    debugPrint(qi.describe());
    var irrgs = qi.find();
    for (var element in irrgs) {
      totalIrrigation += element.irrigationVolume;
    }
  }
  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.8,
      child: Container(
        decoration: const BoxDecoration(color: Resources.bgcolor_100),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 8,
              child: ChartTds(
                  xMax: max,
                  xMin: 0,
                  yMax: 100,
                  yMin: 0,
                  chartData: levelData,
                  onRendererCreated: (controller) =>
                      chartController = controller),
            ),
            Expanded(child: Text('total prodcution: $totalIrrigation')),
            Expanded(child: Text('level: ${level <= 0 ? '' : level}')),
            Expanded(child: Text('being filled: $isFilling')),
            Expanded(child: Text('tank ID: ${widget.tankID}')),
          ],
        ),
      ),
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
      setState(() {
        this.level = level;
      });
    }
    updateGraph(level);

    debugPrint('unit: $unit');
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
