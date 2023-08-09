import 'package:final_project/Components/ReportCard.dart';
import 'package:flutter/material.dart';
import '../../Models/Report.dart';
import '../../main.dart';



class Report_list_view extends StatefulWidget {
  const Report_list_view({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Report_list_viewState createState() => _Report_list_viewState();
}

class _Report_list_viewState extends State<Report_list_view>
    {
 

  ReportCard Function(BuildContext, int) _itemBuilder(List<Report> reports) {
    return (BuildContext context, int index) =>
        ReportCard(report: reports[index]);
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Report>>(
        stream: objectbox.getReports(),
        builder: (context, snapshot) {
          if (snapshot.data?.isNotEmpty ?? false) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                itemBuilder: _itemBuilder(snapshot.data ?? []));
          } else {
            return const Center(child: Text("Press the + icon to add report"));
          }
        });
  }

}
