import 'package:final_project/Components/ChartTds.dart';
import 'package:final_project/Models/Production.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SystemCard extends StatefulWidget {
  final Production production;

  final List<ColoredData> dataGood;
  final void Function(CircularSeriesController controller) cGoodRendererCreated;

  final List<ColoredData> dataWaste;
  final void Function(CircularSeriesController controller)
      cWasteRendererCreated;

  const SystemCard(
      {super.key,
      required this.production,
      required this.dataGood,
      required this.cGoodRendererCreated,
      required this.cWasteRendererCreated,
      required this.dataWaste});
  @override
  State<SystemCard> createState() => _SystemCardState();
}

class _SystemCardState extends State<SystemCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Main Pump Status: Running',
                  style: Theme.of(context).textTheme.bodyLarge),
              const Text(''),
              Text('TDS Value: ${widget.production.tdsValue} PPM'),
              Text('Temprature: ${widget.production.temperatureValue} C'),
            ],
          ),
        ),
      ),
      Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: CircleChart(
                title: 'Permeate Water',
                chartData: widget.dataGood,
                onRendererCreated: widget.cGoodRendererCreated,
                circleTxt: '${widget.production.flowWaterPermeate} ml',
              )),
              Expanded(
                  child: CircleChart(
                title: 'Concentrated Water',
                chartData: widget.dataWaste,
                onRendererCreated: widget.cWasteRendererCreated,
                circleTxt: '${widget.production.flowWaterConcentrate} ml',
              ))
            ],
          ))
    ]);
  }
}
