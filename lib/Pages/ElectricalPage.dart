import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:final_project/Components/Common.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Components/CardDash.dart';
import '../Components/TankCard.dart';
import '../main.dart';

class ElectricalPage extends StatefulWidget {
  const ElectricalPage({
    super.key,
  });

  @override
  State<ElectricalPage> createState() => _ElectricalPage();
}

class _ElectricalPage extends State<ElectricalPage>
    implements ConnectionInterface {
  String status = "";
  String msgs = "";
  double value = 0;
  String title = '';

  int colsN = 3;

  ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();
  @override
  void initState() {
    super.initState();

    ciw.setInterface(this);
  }

  @override
  Widget build(BuildContext context) {
    return AppScofflding(title: 'ElectricalPage', listView: [
      StaggeredGrid.count(
        crossAxisCount: colsN,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          CardDash(
            title: 'Total Power Drawn From AC Source',
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text('126 W',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ]),
          ),
          CardDash(
            title: 'Total Power Drawn From Battery',
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text('50 W',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ]),
          ),
          CardDash(
            title: 'Total Power Drawn From the Solar Energy',
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text('76 W',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ]),
          ),
          CardDash(
            title: 'Real Time Calculation',
            cols: 3,
            rows: 3,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: TriangleCirclesWithArrows(),
              ),
              Expanded(
                child: RandomHorizontalLineGraph(),
              ),
            ]),
          ),
          // CardDash(
          //   title: 'Signal from Solar Energy',
          //   cols: 2,
          //   child:
          //       Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //     Expanded(
          //       child: RandomHorizontalLineGraph(),
          //     ),
          //   ]),
          // ),

          // CardDash(
          //   title: 'TDS',
          //   child: ElevatedButton(
          //     onPressed: () => Navigator.pushNamed(context, '/TdsMainPage'),
          //     child: const Text('TDS'),
          //   ),
          // ),

          // const CardDash(title: 'flow 1'),
          // const CardDash(
          //   title: 'flow 2',
          // ),
          // CardDash(
          //   child: Slider(
          //       value: value,
          //       min: 0,
          //       max: 100,
          //       onChanged: (v) {
          //         setState(() {
          //           value = v;
          //         });
          //       }),
          // ),
          // const StaggeredGridTile.extent(
          //   mainAxisExtent: 500,
          //   crossAxisCellCount: 3,
          //   child: Text(""),
          // )
        ],
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    admin.close();
    ciw.dispose();
  }

  @override
  void connected() {
    setState(() {
      status = 'Connected';
    });
  }

  @override
  void interrupted(data) {
    setState(() {
      status = 'Disconnect: $data';
    });
  }

  @override
  void listen(data) {
    // List<String> d = data.toString().split(':');
    // value = double.parse(d[1]);
    setState(() {
      msgs = data.toString();
    });
  }
}

class TriangleCirclesWithArrows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: TriangleCirclesPainter(),
      ),
    );
  }
}

class TriangleCirclesPainter extends CustomPainter {
  final int powerfromAcSource = 126; // Speed value between 1 and 100
  final int speedValue = 30;
  final int powerConsumption = 76;
  final int chargingPowerofSolar = 50;
  final double maxAngle = pi; // Maximum angle for the speedometer arc
  final double minAngle = 0 - pi / 4; // Minimum angle for the speedometer arc

  //TriangleCirclesPainter(this.speedValue);

  @override
  void paint(Canvas canvas, Size size) {
    final circleRadius = 70.0;
    final arrowSize = 10.0;
    final spaceBetweenCircles = 200.0;
    final triangleSize = 20.0;

    final powerfromAcSourceText = powerfromAcSource.toInt().toString();
    final batteryLevelText = speedValue.toInt().toString();
    final powerConsumptionText = powerConsumption.toInt().toString();
    final chargingPowerofSolarText = chargingPowerofSolar.toInt().toString();

    final circle1Center =
        Offset(size.width / 2, size.height / 2 - circleRadius + 50);
    final circle2Center = Offset(
        circle1Center.dx - cos(pi / 6) * (circleRadius + spaceBetweenCircles),
        circle1Center.dy + sin(pi / 6) * (circleRadius + spaceBetweenCircles));
    final circle3Center = Offset(
        circle1Center.dx + cos(pi / 6) * (circleRadius + spaceBetweenCircles),
        circle1Center.dy + sin(pi / 6) * (circleRadius + spaceBetweenCircles));

    final circle4Center = Offset(
        circle1Center.dx - cos(pi / 6) * (circleRadius + spaceBetweenCircles),
        circle1Center.dy +
            sin(pi / 6) * (circleRadius + spaceBetweenCircles) -
            200);

    final paint1 = Paint()
      ..color = Color.fromARGB(255, 204, 8, 201)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = Color.fromARGB(255, 17, 168, 32)
      ..style = PaintingStyle.fill;

    final paint3 = Paint()
      ..color = Color.fromARGB(255, 7, 105, 202)
      ..style = PaintingStyle.fill;

    final paint4 = Paint()
      ..color = Color.fromARGB(255, 204, 171, 8)
      ..style = PaintingStyle.fill;

    // Draw circles
    canvas.drawCircle(circle1Center, circleRadius, paint1);
    canvas.drawCircle(circle2Center, circleRadius, paint2);
    canvas.drawCircle(circle3Center, circleRadius, paint3);
    canvas.drawCircle(circle4Center, circleRadius, paint4);

    // Draw arrows
    final arrowPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = arrowSize
      ..strokeCap = StrokeCap.round;

    final arrowStart1 =
        Offset(circle1Center.dx, circle1Center.dy + circleRadius);
    final arrowEnd1 = Offset(
        circle1Center.dx,
        circle1Center.dy +
            sin(pi / 6) * (circleRadius + spaceBetweenCircles - 20));
    canvas.drawLine(arrowStart1, arrowEnd1, arrowPaint);

    final arrowStart2 =
        Offset(circle2Center.dx + circleRadius, circle2Center.dy);
    final arrowEnd2 = Offset(circle1Center.dx - 10, circle3Center.dy);
    canvas.drawLine(arrowStart2, arrowEnd2, arrowPaint);

    final arrowStart3 = Offset(circle1Center.dx + 10, circle2Center.dy);
    final arrowEnd3 =
        Offset(circle1Center.dx + spaceBetweenCircles - 40, circle2Center.dy);
    canvas.drawLine(arrowStart3, arrowEnd3, arrowPaint);

    final arrowStart4 =
        Offset(circle4Center.dx, circle4Center.dy + circleRadius);
    final arrowEnd4 = Offset(
        circle4Center.dx,
        circle4Center.dy +
            sin(pi / 6) * (circleRadius + spaceBetweenCircles - 10) -
            10);
    canvas.drawLine(arrowStart4, arrowEnd4, arrowPaint);

    // Draw arrowheads (small triangles)
    final arrowheadPath = Path()
      ..moveTo(arrowEnd1.dx, arrowEnd1.dy + 10)
      ..lineTo(arrowEnd1.dx - triangleSize, arrowEnd1.dy - triangleSize)
      ..lineTo(arrowEnd1.dx + triangleSize, arrowEnd1.dy - triangleSize)
      ..close();

    canvas.drawPath(arrowheadPath, arrowPaint);

    final arrowheadPath2 = Path()
      ..moveTo(arrowEnd2.dx + 10, arrowEnd2.dy)
      ..lineTo(arrowEnd2.dx - triangleSize, arrowEnd2.dy - triangleSize)
      ..lineTo(arrowEnd2.dx - triangleSize, arrowEnd2.dy + triangleSize)
      ..close();

    canvas.drawPath(arrowheadPath2, arrowPaint);

    final arrowheadPath3 = Path()
      ..moveTo(arrowEnd3.dx + 10, arrowEnd3.dy)
      ..lineTo(arrowEnd3.dx - triangleSize, arrowEnd3.dy - triangleSize)
      ..lineTo(arrowEnd3.dx - triangleSize, arrowEnd3.dy + triangleSize)
      ..close();

    canvas.drawPath(arrowheadPath3, arrowPaint);

    final arrowheadPath4 = Path()
      ..moveTo(arrowEnd4.dx, arrowEnd4.dy + 10)
      ..lineTo(arrowEnd4.dx - triangleSize, arrowEnd4.dy - triangleSize)
      ..lineTo(arrowEnd4.dx + triangleSize, arrowEnd4.dy - triangleSize)
      ..close();

    canvas.drawPath(arrowheadPath4, arrowPaint);

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );

    final textPainter1 = TextPainter(
      text: TextSpan(
          text: 'Power from AC Source\n\n\n               ' +
              powerfromAcSourceText +
              'W',
          style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter1.paint(
        canvas, Offset(circle1Center.dx - 50, circle1Center.dy - 15));

    final textPainter2 = TextPainter(
      text: TextSpan(
          text: 'Battery Level\n\n        ' + batteryLevelText + '%',
          style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter2.paint(
        canvas, Offset(circle2Center.dx - 30, circle2Center.dy - 5));

    final textPainter3 = TextPainter(
      text: TextSpan(
          text:
              'Power Consumption\n\n             ' + powerConsumptionText + 'W',
          style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter3.paint(
        canvas, Offset(circle3Center.dx - 40, circle3Center.dy - 10));

    final textPainter4 = TextPainter(
      text: TextSpan(
          text: 'Charging Power of the Solar\n\n\n                     ' +
              chargingPowerofSolarText +
              'W',
          style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter4.paint(
        canvas, Offset(circle4Center.dx - 60, circle4Center.dy - 15));

    // Draw speedometer circle
    final speedometerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final speedometerPaint1 = Paint()
      ..color = Color.fromARGB(255, 18, 2, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final speedometerRect = Rect.fromCenter(
      center: circle2Center,
      width: circleRadius + 40,
      height: circleRadius + 40,
    );

    canvas.drawArc(speedometerRect, pi - pi / 4, pi, false, speedometerPaint);

    canvas.drawArc(speedometerRect, pi - pi / 4, maxAngle * (speedValue / 100),
        false, speedometerPaint1);

    // Draw indicator line at the speedometer's angle
    final indicatorPaint = Paint()
      ..color = Color.fromARGB(255, 26, 12, 215)
      ..strokeWidth = 4;

    final indicatorStart = Offset(
        circle2Center.dx -
            cos(minAngle + (maxAngle * (speedValue / 100))) *
                (circleRadius - 25),
        circle2Center.dy -
            sin(minAngle + (maxAngle * (speedValue / 100))) *
                (circleRadius - 25));
    final indicatorEnd = Offset(
        circle2Center.dx -
            cos(minAngle + (maxAngle * (speedValue / 100))) *
                (circleRadius - 5),
        circle2Center.dy -
            sin(minAngle + (maxAngle * (speedValue / 100))) *
                (circleRadius - 5));

    canvas.drawLine(indicatorStart, indicatorEnd, indicatorPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RandomHorizontalLineGraph extends StatefulWidget {
  @override
  _RandomHorizontalLineGraphState createState() =>
      _RandomHorizontalLineGraphState();
}

class _RandomHorizontalLineGraphState extends State<RandomHorizontalLineGraph> {
  double _randomValue = 80.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (_) {
      setState(() {
        _randomValue = Random().nextInt(21) + 80.0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('      Signal from Solar Energy'),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Low'),
            Container(
              width: 200,
              height: 10,
              color: Colors.grey,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: (_randomValue - 80) * 2,
                  height: 8,
                  color: Color.fromARGB(250, 224, 5, 52),
                ),
              ),
            ),
            Text('High'),
          ],
        ),
        SizedBox(height: 10),
        Text('                  Value: $_randomValue'),
      ],
    );
  }
}
