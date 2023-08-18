import 'package:final_project/Components/Common.dart';
import 'package:final_project/Components/ReportCardEx.dart';
import 'package:final_project/ConnectionHandler.dart';
import 'package:final_project/Models/Report.dart';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    implements ConnectionInterface {
  late List<ReportCardEx> reports;

  ConnectionInterfaceWrapper ciw = ConnectionInterfaceWrapper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ciw.setInterface(this);

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

  @override
  void dispose() {
    // TODO: implement dispose
    ciw.dispose();
    super.dispose();
  }

  @override
  void connected() {
    // TODO: implement connected
  }

  @override
  void interrupted(data) {
    // TODO: implement interrupted
  }

  @override
  void listen(Map<int, dynamic> data) {
    // TODO: implement listen
  }
}
