import 'package:final_project/Models/Schedule.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: Text('Setting & Support'),
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(
              height: 5,
            ),
            Row(
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
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 15,
            ),
            buildSettingOptionRow(context, "Account Setting", '/TdsMainPage'),
            buildSettingOptionRow(context, "Tanks Setting", '/TanksSetup'),
            buildSettingOptionRow(context, "Scheduling Setting", '/TanksSetup'),
            buildSettingOptionRow(context, "TDS Setting", '/TdsMainPage'),
            SizedBox(
              height: 25,
            ),
            Row(
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
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 15,
            ),
            buildSettingOptionRow(context, "About the Project", '/TechInfo'),
            buildSettingOptionRow(context, "About the App", '/TanksSetup'),
          ],
        ),
      ),
    );
  }

  GestureDetector buildSettingOptionRow(
      BuildContext context, String title, String rote) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, rote),
      onLongPress: () {
        longPressedSetting(context, title, hamod);
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
                  child: Text("Close")),
            ],
          );
        });
  }
}
