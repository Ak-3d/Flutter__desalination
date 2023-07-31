import 'package:final_project/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'ObjectBox.dart';
import 'Pages/TdsMainPage.dart';
import 'Pages/Dashboard.dart';

late ObjectBox objectbox;
late Admin admin;
late Size screenSize;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  if (Admin.isAvailable()) {
    //for development, the phone broadcast database into the network
    //eneter it using the uri followed by index.html
    admin = Admin(objectbox.store, bindUri: 'http://192.168.1.101:8090');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Water Desalination Project';
    screenSize = MediaQuery.of(context).size;

    return MaterialApp(
      title: title,
      home: const Dashboard(),
      routes: {
        '/TdsMainPage': (context) => TdsMainPage(),
      },
      darkTheme: ThemeData.dark(),
    );
  }
}
