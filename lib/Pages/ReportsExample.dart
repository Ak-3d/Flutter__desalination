import 'package:final_project/Components/CardDash.dart';
import 'package:final_project/Components/Common.dart';
import 'package:final_project/Components/ReportCardEx.dart';
import 'package:final_project/Models/Report.dart';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late List<ReportCardEx> reports;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<Report> rps = objectbox.report.getAll();
    reports = [];
    for (var r in rps) {
      reports.add(ReportCardEx(
        title: '${r.id}',
        note: r.note,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScofflding(listView: [
      StaggeredGrid.count(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        children: reports,
      )
    ]);
  }
}
