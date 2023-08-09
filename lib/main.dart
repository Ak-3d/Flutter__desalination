import 'package:final_project/Pages/views/Tanks_view.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:final_project/ForgroundService.dart';
import 'package:flutter/material.dart';
import 'ObjectBox.dart';
import 'Pages/TdsMainPage.dart';
import 'Pages/Dashboard.dart';
import 'Pages/views/Report_list_view.dart';
late ObjectBox objectbox;


late Admin admin;
late Size screenSize;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

  try {
    objectbox = await ObjectBox.create();
    

    if (Admin.isAvailable()) {
      //for development, the phone broadcast database into the network
      //eneter it using the uri followed by index.html
      admin = Admin(objectbox.store, bindUri: 'http://192.168.0.117:8090');
    }
  } catch (e) {
    debugPrint(e.toString());
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
      theme: ThemeData(
          brightness: Brightness.dark,
          textTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.white))),
      title: title,
      home: const Dashboard(),

      routes: {
        '/TdsMainPage': (context) => TdsMainPage(),
        '/ReportsView': (context) => Report_list_view(),
        '/TankView': (context) => Tanks_view(),
      },
      // darkTheme: ThemeData.dark(),
    );
  }
}
