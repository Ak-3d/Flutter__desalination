

import 'package:flutter/material.dart';
import 'package:final_project/Resources.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';





class CardDash extends StatelessWidget {
  const CardDash(
      {Key? key,
      this.txt = "card",
      this.color = Resources.bgcolor_100,
      this.cols = 1,
      this.rows = 1,
      this.widget = const Text('')})
      : super(key: key);

  final String txt;
  final Color color;
  final int cols;
  final int rows;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
      crossAxisCellCount: cols,
      mainAxisCellCount: rows,
      child: Container(
        decoration: const BoxDecoration(
            color: Resources.bgcolor_100,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(2, 0), blurRadius: 4)
            ]),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: widget,
          // Text(
          //   txt,
          //   style: const TextStyle(color: Colors.white),
          // ),
        ),
      ),
    );
  }
}