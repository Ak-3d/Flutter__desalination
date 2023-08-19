import 'package:final_project/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

String hamod = "Edit user name,password,or phone num";

class SettingAndInfo extends StatefulWidget {
  const SettingAndInfo({super.key});
  // final String title;
  @override
  _SettingAndInfoState createState() => _SettingAndInfoState();
}

class _SettingAndInfoState extends State<SettingAndInfo> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Resources.bgcolor_100,
      appBar: AppBar(
        
        title: const Text('Setting & Support'),
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "General",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 15,
            ),
            buildSettingOptionRow(context, "Edit Password", '/PasswordSetup',
                "You can edit the User info !!"),
            buildSettingOptionRow(context, "Tanks Setting", '/TanksPage',
                "View All Setup Tanks and You can edit or delete Tanks !!"),
            buildSettingOptionRow(
                context,
                "Scheduling Setting",
                '/SchedulePage',
                "View All Recorded scheduled for each Tank and You can edit or delete schedule for each tank !!"),
            // buildSettingOptionRow(context, "Reports", '/ReportsView',
            // "View All Reports and issues Recorded"),
            const SizedBox(
              height: 25,
            ),
            const Row(
              children: [
                Icon(
                  Icons.info,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "info",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 15,
            ),
            buildSettingOptionRow(context, "Structure Project Hardware", '/TechInfo',
                "Show All ports and DataSheet diagram for Hardware Components  "),
            buildSettingOptionRow(context, "About Us", '/About',
                "about Our Version and Licenses @"),
          ],
        ),
      ),
    );
  }

  GestureDetector buildSettingOptionRow(
      BuildContext context, String title, String rote, String tip) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, rote),
      onLongPress: () {
        longPressedSetting(context, title, tip);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> longPressedSetting(
      BuildContext context, String title, String info) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(info),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close")),
            ],
          );
        });
  }
}
