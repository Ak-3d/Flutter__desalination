import 'package:flutter/material.dart';
import 'package:final_project/Resources.dart';

class Tank extends StatelessWidget {
  const Tank(
      {Key? key,
      this.value = 0,
      this.isFilling = false,
      this.tankTitle = 'Tank 1'})
      : super(key: key);

  final double value;
  final bool isFilling;
  final String tankTitle;
  @override
  Widget build(BuildContext context) {
    // double tempv = value * 2.55;

    double actualValue = value / 100, r = 0.4;
    Color actualColor = Color.fromARGB(
        255,
        (Resources.tankFullColor.red * (actualValue + r) +
                Resources.tankEmptyColor.red * (1 - actualValue - r))
            .toInt(),
        (Resources.tankFullColor.green * (actualValue + r) +
                Resources.tankEmptyColor.green * (1 - actualValue - r))
            .toInt(),
        0);
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha((255 * 0.25).toInt()),
                      offset: const Offset(0, 4),
                      blurRadius: 4)
                ],
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Resources.tankFullColor,
                      actualColor,
                      Resources.tankNeutralColor,
                    ],
                    stops: [
                      actualValue - 0.01,
                      actualValue,
                      actualValue
                    ]),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                const Text(''),
                Text(tankTitle),
                Expanded(
                  child: Center(
                      child: Text(
                    '${value.toInt()}%',
                    textScaleFactor: 2,
                  )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
