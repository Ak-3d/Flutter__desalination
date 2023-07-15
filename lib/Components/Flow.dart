
import 'package:flutter/cupertino.dart';

class FlowAnimation extends StatefulWidget {
  const FlowAnimation({Key? key}) : super(key: key);

  @override
  State<FlowAnimation> createState() => _FlowAnimationState();
}

class _FlowAnimationState extends State<FlowAnimation> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // painter: FluidPaint(),
      child: const SizedBox(
        width: 100,
        height: 100,
      ),
    );
  }
}

// class FluidPaint extends CustomPaint{
//   @override
//   void paint(Canvas canvas, Size size){

//   }
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate){
//     return false;
//   }
// }
