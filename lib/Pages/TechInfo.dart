import 'package:flutter/material.dart';

class TechInfo extends StatefulWidget {
  const TechInfo({super.key});

  @override
  State<TechInfo> createState() => _TechInfoState();
}

class _TechInfoState extends State<TechInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: Text('Pin Configurations'),
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Table(
              border: TableBorder.all(color: Colors.white30),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              // columnWidths:Map(),

              children: [
                FullRow('Item', 'Pin no', 'GPIO Mode', 'Label'),
                FullRow('In Pump', '21', 'O/P', '0'),
                FullRow('Plant valve', '16', 'O/P', '2'),
                FullRow('Drink valve', '5', 'O/P', '7'),
                FullRow('Plant pump', '18', '1', '6'),
                FullRow('Drink pump', '4', '1', '5'),
                FullRow('Permit flow Sensor', '14', '1', '1'),
                FullRow('Concentrate flow Sensor', '27', '1', '4'),
                FullRow('Temperature sensor', '12', '1', '66'),
                FullRow('TDS sensor', '35', '1', '8'),
                FullRow('Servo', '1', '26', '22'),
                FullRow('Trigger drink', '25', '1', '38'),
                FullRow('Trigger plant', '2', '1', '83'),
                FullRow('Echo drink', '34', '1', '48'),
                FullRow('Echo plant', '32', '1', '84'),
                FullRow('Voltage sensor', '36', '1', '55'),
                FullRow('Current sensor', '33', '1', '11'),
                FullRow('Vcc “5v”', '---', '---', '77'),
                FullRow('Vcc “12v”', '---', '---', '50'),
                FullRow('ground', '---', '---', '76&60'),
                FullRow('1', '1', '1', '1'),
                FullRow('1', '1', '1', '1'),
                FullRow('1', '1', '1', '1'),
                FullRow('1', '1', '1', '1'),
                FullRow('1', '1', '1', '1'),
                FullRow('1', '1', '1', '1'),
                FullRow('1', '1', '1', '1'),
                FullRow('1', '1', '1', '1'),
                FullRow('1', '1', '1', '1'),
                FullRow('1', '1', '1', '1'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow FullRow(String a, String b, String c, String d) {  // this function creat n cells
    return TableRow(
        decoration: BoxDecoration(
          // backgroundBlendMode: BlendMode.colorDodge,
          color: Colors.blueGrey.shade400,
        ),
        children: [
          RowCell(
            content: a,
          ),
          RowCell(
            content: b,
          ),
          RowCell(
            content: c,
          ),
          RowCell(
            content: d,
          ),
        ]);
  }
}

class RowCell extends StatelessWidget { //// this class creat one cell
  final String content;
  const RowCell({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          content,
          selectionColor: Colors.amber,
          style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
