import 'package:final_project/Models/SingleTank.dart';
import 'package:flutter/material.dart';

class SingleTankCard extends StatefulWidget {
  final SingleTank? tank;
  const SingleTankCard({Key? key, required this.tank}) : super(key: key);

  @override
  _SingleTankCardState createState() => _SingleTankCardState();
}

class _SingleTankCardState extends State<SingleTankCard> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 1, 191, 249),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 168, 168, 168),
            blurRadius: 5,
            offset: Offset(1, 2),
          )
        ],
      ),
      child: Row(
        children: <Widget>[
          Transform.scale(
            scale: 1.3,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.tank!.level.toString(),
                      style: const TextStyle(
                          fontSize: 20.0,
                          height: 1.0,
                          color: Color.fromARGB(255, 73, 73, 73),
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          "Assigned to: ${widget.tank!.createdDate}",
                          style: const TextStyle(
                              fontSize: 20.0,
                              height: 1.0,
                              color: Color.fromARGB(255, 73, 73, 73),
                              overflow: TextOverflow.ellipsis,
                              decoration: TextDecoration.lineThrough),
                        )
                      ],
                    ),
                  ),
                )
              ]
            )
          )          
        ],
        
      ),
    );
  
  }
}
