import 'package:final_project/Components/Tank.dart';
import 'package:final_project/Models/SingleTank.dart';
import 'package:final_project/Pages/SingleTankPage.dart';
import 'package:flutter/material.dart';

class TanksCardDash extends StatefulWidget {
  final List<SingleTank> tanks;

  const TanksCardDash({Key? key, required this.tanks}) : super(key: key);

  @override
  _TanksCardDashState createState() => _TanksCardDashState();
}

class _TanksCardDashState extends State<TanksCardDash> {
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
              margin: const EdgeInsets.symmetric(horizontal: mx * 0.5),
              width: w,
              // decoration: BoxDecoration(border: Border.all()),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                   return SingleTankPage(tankID: widget.tanks[i].tanks.target!.id);
                  }));
                  //   Navigator.pushNamed(context, '/TankPage',
                  //       arguments: widget.tanks[i].tanks.target?.portNumber ?? 1);
                  // },
                },
                child: Tank(
                  tankTitle:
                      'Tank ${widget.tanks[i].tanks.target?.portNumber ?? 1}',
                  isFilling: false,
                  value: widget.tanks[i].level,
                ),
              ),
            );
          });
    });
  }
}
