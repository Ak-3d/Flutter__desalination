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
        title: Text('Pins Configurations'),
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
              border: TableBorder.all(color: Colors.black),
              columnWidths: {
                0: FlexColumnWidth(5),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              // columnWidths:Map(),

              children: [
                TableRow(
                    decoration: BoxDecoration(
                      // backgroundBlendMode: BlendMode.colorDodge,
                      color: const Color.fromARGB(255, 147, 180, 196),
                    ),
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Item',
                            selectionColor: Colors.blueAccent,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Pin no',
                            selectionColor: Colors.amber,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'GPIO Mode',
                            selectionColor: Colors.amber,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Label',
                            selectionColor: Colors.amber,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ]),
                // FullRow('Item', 'Pin no', 'GPIO Mode', 'Label'),
                FullRow('In Pump', '21', 'O/P', '0'),
                FullRow('Plant valve', '16', 'O/P', '2'),
                FullRow('Drink valve', '5', 'O/P', '7'),
                FullRow('Plant pump', '18', 'O/P', '6'),
                FullRow('Drink pump', '4', 'O/P', '5'),
                FullRow('Permit flow Sensor', '14', 'I/P', '1'),
                FullRow('Concentrate flow Sensor', '27', 'I/P', '4'),
                FullRow('Temperature sensor', '12', 'I/P', '66'),
                FullRow('TDS sensor', '35', 'I/P', '8'),
                FullRow('Servo', '26', 'O/P', '22'),
                FullRow('Trigger drink', '25', 'O/P', '38'),
                FullRow('Trigger plant', '2', 'O/P', '83'),
                FullRow('Echo drink', '34', 'I/P', '48'),
                FullRow('Echo plant', '32', 'I/P', '84'),
                FullRow('Voltage sensor', '36', 'I/P', '55'),
                FullRow('Current sensor', '33', 'I/P', '11'),
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

  TableRow FullRow(String a, String b, String c, String d) {
    // this function creat n cells
    return TableRow(
        decoration: BoxDecoration(
          // backgroundBlendMode: BlendMode.colorDodge,
          color: const Color.fromARGB(255, 127, 203, 238),
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

class RowCell extends StatelessWidget {
  //// this class creat one cell
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
          selectionColor: Colors.blueGrey,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
