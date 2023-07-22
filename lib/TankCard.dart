import 'package:flutter/material.dart';

import 'Tank.dart';



class TankCard extends StatelessWidget {
  const TankCard({Key? key, this.v1 = 0, this.v2 = 0}) : super(key: key);

  final double v1;
  final double v2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Tank(
            value: v1,
          ),
          Tank(
            value: v2,
          )
        ],
      ),
    );
  }
}
