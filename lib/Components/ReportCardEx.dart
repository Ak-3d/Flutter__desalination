import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';

class ReportCardEx extends StatelessWidget {
  const ReportCardEx({super.key, this.title = '', this.note = ''});

  final String title;
  final String note;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Resources.bgcolor_100,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  note,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () => {debugPrint('$title is pressed')},
                    child: Text('Action')),
              )
            ],
          )
        ],
      ),
    );
  }
}
