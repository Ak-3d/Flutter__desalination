import 'package:final_project/Components/CardDash.dart';
import 'package:final_project/Core/Tanks_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Widgets/SmallTank.dart';

class TanksCards extends StatefulWidget {
  final int tankId;
  final int portNumber;
  final String plantName;
  final double tdsValue;
  final double quantity;
  const TanksCards(
      {Key? key,
      this.tankId = 0,
      this.portNumber = 0,
      this.plantName = "tankName",
      this.tdsValue = 0.0,
      this.quantity = 0.0})
      : super(key: key);

  @override
  _TanksCardsState createState() => _TanksCardsState();
}

class _TanksCardsState extends State<TanksCards> {
  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 76, 74, 76),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 1)
          ]),
      child: Column(children: [
        StaggeredGrid.count(
          crossAxisCount: 5,
          mainAxisSpacing: 5,
          crossAxisSpacing: 10,
          children: [
            Container(
                height: 150,
                width: 300,
                child: SmallTank(value: widget.quantity, isFilling: false)),
            CardDash(
              cols: 3,
              title: 'Tank Name',
              child: Text(widget.plantName),
            ),
            CardDash(
              cols: 1,
              title: 'Port pin',
              child: Text(widget.portNumber.toString()),
            ),
            CardDash(
              cols: 3,
              title: 'TDS value',
              child: Text(widget.tdsValue.toString()),
            ),
            SizedBox(
              width: 100, // <-- Your width
              height: 75,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minimumSize: Size(100, 40), //////// HERE
                ),
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TanksSetup(tankId: widget.tankId)));
                  setState(() {});
                },
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
