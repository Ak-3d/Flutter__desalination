import 'package:flutter/material.dart';
import 'package:final_project/Resources.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CardDash extends StatelessWidget {
  static num defaultRows = 0.5;

  const CardDash(
      {Key? key,
      this.txt = "card",
      this.color = Resources.bgcolor_100,
      this.cols = 1,
      this.rows,
      this.child = const Text('')})
      : super(key: key);

  final String txt;
  final Color color;
  final int cols;
  final num? rows;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
      crossAxisCellCount: cols,
      mainAxisCellCount: rows ?? defaultRows,
      child: Container(
        decoration: const BoxDecoration(
            color: Resources.bgcolor_100,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(2, 0), blurRadius: 4)
            ]),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                txt,
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: Center(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
