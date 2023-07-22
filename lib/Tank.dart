

import 'package:flutter/material.dart';
import 'package:final_project/Resources.dart';

class Tank extends StatelessWidget {
  const Tank({Key? key, this.value = 0, this.width, this.height})
      : super(key: key);

  final double? width;
  final double? height;
  final double value;

  @override
  Widget build(BuildContext context) {
    double tempv = value * 2.55;

    double actualValue = value / 100;
    Color actualColor = Color.fromARGB(
        255,
        (Resources.tankFullColor.red +
                (Resources.tankFullColor.red - Resources.tankEmptyColor.red) *
                    actualValue)
            .toInt(),
        (Resources.tankFullColor.green +
                (Resources.tankFullColor.green -
                        Resources.tankEmptyColor.green) *
                    actualValue)
            .toInt(),
        (Resources.tankFullColor.blue +
                (Resources.tankFullColor.blue - Resources.tankEmptyColor.blue) *
                    actualValue)
            .toInt());

    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width / 7,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [actualColor, Colors.grey],
              stops: [actualValue - 0.1, actualValue]),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Center(
          child: Text(
        '${value.toInt()}%',
        textScaleFactor: 2,
      )),
    );
  }
}
