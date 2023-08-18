import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class EditButton extends StatelessWidget {
  final Widget editPage;
  const EditButton({super.key, required this.editPage});

  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.extent(
      crossAxisCellCount: 1,
      mainAxisExtent: 320 * 0.3,
      child: Container(
        decoration: BoxDecoration(
            color: Resources.bgcolor_100,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha((255 * 0.25).toInt()),
                  offset: const Offset(0, 7),
                  blurRadius: 4)
            ]),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,

            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            /////// HERE
          ),
          onPressed: () async {
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => editPage));
          },
          child: const Text('Edit'),
        ),
      ),
    );
  }
}
