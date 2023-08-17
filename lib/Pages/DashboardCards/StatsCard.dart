import 'package:final_project/Components/CustomCard.dart';
import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';

class StatsBody extends StatelessWidget {
  const StatsBody(
      {super.key,
      this.data = 'data | unit',
      this.title = 'Title',
      required this.icon});

  final String title;
  final String data;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 30;
    return CustomCard(
        rows: 0.3,
        title: title,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              data,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Icon(
              icon,
              size: width,
              color: Resources.primaryColor,
            )
          ],
        ));
  }
}
