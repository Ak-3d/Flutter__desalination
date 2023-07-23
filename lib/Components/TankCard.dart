import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';
import 'Tank.dart';



class TankCard extends StatelessWidget {
  const TankCard({Key? key, this.v1 = 0, this.v2 = 0}) : super(key: key);

  final double v1;
  final double v2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Tank(
          value: v1,
        ),
        Container(
          width: 2,
          decoration: const BoxDecoration(
            gradient: RadialGradient(colors: [Colors.white, Resources.bgcolor_100],radius: 50,)
          ),
        ),
        Tank(
          value: v2,
        )
      ],
    );
  }
}
