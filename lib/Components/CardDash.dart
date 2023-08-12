import 'package:flutter/material.dart';
import 'package:final_project/Resources.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CardDash extends StatelessWidget {
  static num defaultRows = 0.5;

  const CardDash(
      {Key? key,
      this.color = Resources.bgcolor_100,
      this.cols = 1,
      this.rows,
      this.title = '',
      this.child = const Text('')})
      : super(key: key);

  final String title;
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
                  color: Colors.black, offset: Offset(0, 1), blurRadius: 1)
            ]),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                )),
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
