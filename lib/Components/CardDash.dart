import 'package:flutter/material.dart';
import 'package:final_project/Resources.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CardDash extends StatelessWidget {
  static num defaultRows = 0.5;

  const CardDash(
      {Key? key,
      this.color = Resources.bgcolor_100,
      this.cols = 1,
      this.rows = 1,
      this.title = '',
      this.child = const Text('')})
      : super(key: key);

  final String title;
  final Color color;
  final int cols;
  final num rows;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.extent(
      crossAxisCellCount: cols,
      mainAxisExtent: 320 * rows.toDouble(),
      // mainAxisCellCount: rows ?? defaultRows,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Resources.bgcolor_100,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha((255 * 0.25).toInt()),
                  offset: const Offset(0, 7),
                  blurRadius: 4)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: child,
            )),
          ],
        ),
      ),
    );
  }
}

class PlaceHolderIcon extends StatelessWidget {
  const PlaceHolderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: Text(''),
    );
  }
}
