import 'package:final_project/Models/Tanks.dart';
import 'package:flutter/material.dart';

class TanksCards extends StatefulWidget {
  final Tanks? tank;
  
  const TanksCards({Key? key, required this.tank}) : super(key: key);

  @override
  _TanksCardsState createState() => _TanksCardsState();
}

class _TanksCardsState extends State<TanksCards> {
  double level = 0;
  @override
  void initState() {
    super.initState();
   
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 243, 243),
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
                      widget.tank!.plantName,
                       style: 
                                const TextStyle(
                                    fontSize: 15.0,
                                    height: 1.0,
                                    color: Color.fromARGB(255, 106, 106, 106),
                                    decoration: TextDecoration.lineThrough)
                        )
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text("Assigned to: ${widget.tank!.createdDate}",
                            style: 
                                const TextStyle(
                                    fontSize: 15.0,
                                    height: 1.0,
                                    color: Color.fromARGB(255, 106, 106, 106),
                                    decoration: TextDecoration.lineThrough)
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ) 
    )]),
          );
  }
}
