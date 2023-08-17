// import 'package:flutter/material.dart';

// import '../Resources.dart';

// Widget smallTank(double quantity ,BuildContext context ) {
//     // double tempv = value * 2.55;

//     double actualValue = quantity / 100, r = 0.4;
//     Color actualColor = Color.fromARGB(
//         255,
//         (Resources.tankFullColor.red * (actualValue + r) +
//                 Resources.tankEmptyColor.red * (1 - actualValue - r))
//             .toInt(),
//         (Resources.tankFullColor.green * (actualValue + r) +
//                 Resources.tankEmptyColor.green * (1 - actualValue - r))
//             .toInt(),
//         0);
//     return Container(
//       height: MediaQuery.of(context).size.height / 6,
//       width: MediaQuery.of(context).size.width / 6,
//       decoration: BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [actualColor, const Color.fromARGB(255, 255, 255, 255)],
//               stops: [actualValue, actualValue + 0.1]),
//           borderRadius: const BorderRadius.all(Radius.circular(20))),
//       child: Center(
//           child: Text(
  
//         '${actualValue.toInt()}%',
//         style: TextStyle(fontSize: 10),
//         textScaleFactor: 2,
//       )),
//     );
//   }
import 'package:flutter/material.dart';
import 'package:final_project/Resources.dart';

class SmallTank extends StatelessWidget {
  const SmallTank({Key? key, this.value = 0, this.isFilling = false})
      : super(key: key);

  final double value;
  final bool isFilling;

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
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 6,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [actualColor, Resources.tankNeutralColor],
              stops: [actualValue, actualValue + 0.1]),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Center(
          child: Text(
        '${value.toInt()}%',
         style: const TextStyle(fontSize: 10),
        textScaleFactor: 2,
      )),
    );
  }
}
