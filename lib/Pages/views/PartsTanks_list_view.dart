import 'package:flutter/material.dart';
import '../../Components/SingleTankCard.dart';
import '../../Models/SingleTank.dart';
import '../../main.dart';



class PartsTanks_list_view extends StatefulWidget {
  final int tankId;
  const PartsTanks_list_view({Key? key, required this.tankId}) : super(key: key);

  @override
  _PartsTanks_list_viewState createState() => _PartsTanks_list_viewState();
}

class _PartsTanks_list_viewState extends State<PartsTanks_list_view> {
  SingleTankCard Function(BuildContext, int) _itemBuilder(
      List<SingleTank> eachTank) {
    return (BuildContext context, int index) =>
        SingleTankCard(tank: eachTank[index]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      StreamBuilder<List<SingleTank>>(
          stream: objectbox.getAllSingleTanks(widget.tankId),
          builder: (context, snapshot) {
            if (snapshot.data?.isNotEmpty ?? false) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                  itemBuilder: _itemBuilder(snapshot.data ?? []));
            } else {
              return const Center(child: Text("Press the + icon to add Tanks"));
            }
          }),
    ]);
  }
}
