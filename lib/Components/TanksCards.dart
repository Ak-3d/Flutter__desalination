import 'package:final_project/Components/CardDash.dart';
import 'package:final_project/Components/Tank.dart';
import 'package:final_project/Core/Tanks_setup.dart';
import 'package:final_project/Models/SingleTank.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Widgets/SmallTank.dart';

class TanksCards extends StatefulWidget {
  final List<SingleTank> tanks;

  const TanksCards({Key? key, required this.tanks}) : super(key: key);

  @override
  _TanksCardsState createState() => _TanksCardsState();
}

class _TanksCardsState extends State<TanksCards> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (con, box) {
      const mx = 2;
      final w =
          box.maxWidth / widget.tanks.length - widget.tanks.length * mx / 2;
      // debugPrint('$mx');
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.tanks.length,
          itemBuilder: (c, int i) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: mx * 0.5),
              width: w,
              // decoration: BoxDecoration(border: Border.all()),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/TankPage',
                      arguments: widget.tanks[i].id);
                },
                child: Tank(
                  tankTitle: 'Tank ${widget.tanks[i].id}',
                  isFilling: false,
                  value: widget.tanks[i].level,
                ),
              ),
            );
          });
    });
  }
}
