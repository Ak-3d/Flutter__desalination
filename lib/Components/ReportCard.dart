import 'package:flutter/material.dart';

import 'package:final_project/main.dart';
import '../Models/Status.dart';
import '../Models/Report.dart';


class ReportCard extends StatefulWidget {
  final Report? report;
  const ReportCard({super.key, required this.report});

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  List<Status> statue = objectbox.status.getAll();
  Status? currentStatue;

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
                      widget.report!.note,
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
                          "Assigned to: ${currentStatue?.name}",
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSelected(BuildContext context, Report report) {
    objectbox.report.remove(report.id);
    debugPrint("Report ${report.id} deleted");
  }
}
