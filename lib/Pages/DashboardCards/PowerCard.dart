import 'package:final_project/Components/CustomCard.dart';
import 'package:final_project/Models/Power.dart';
import 'package:final_project/Pages/PowerPage.dart';
import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';

class PowerCard extends StatelessWidget {
  const PowerCard({super.key, required this.electricity});
  final Power electricity;

  final double w = 20;
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Power',
      rows: 1,
      child: TextButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ElectricalPage())),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                children: [
                  Column(
                    children: List<Widget>.generate(12, (i) {
                      return i % 2 == 0
                          ? Expanded(
                              flex: 4,
                              child: Container(
                                width: w,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                              ),
                            )
                          : const Spacer();
                    }),
                  ),
                  Container(
                    width: w,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: const [
                          Resources.bgcolor,
                          Color(0x00FFFFFF)
                        ],
                            stops: [
                          (100 - electricity.batteryLevel) / 100,
                          (100 - electricity.batteryLevel) / 100
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Battery',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${electricity.batteryLevel} %',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Usage',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${electricity.currentOut * 36 / 1000} WH',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                              electricity.isBattery
                                  ? Icons.battery_full
                                  : Icons.power,
                              color: Colors.green,
                              grade: 100),
                          Text(
                            electricity.isBattery ? 'Battery' : 'Pluged in',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          // const Icon(Icons.solar_power, color: Colors.grey),
                          Icon(
                            electricity.currentIn > 100
                                ? Icons.flash_on
                                : Icons.flash_off,
                            color: electricity.currentIn > 100
                                ? Colors.green
                                : Colors.grey,
                          ),
                          Text(
                            electricity.currentIn > 100
                                ? 'Charging'
                                : 'not Charging',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
