import 'package:faker/faker.dart';
import 'package:final_project/Models/Status.dart';
import 'package:final_project/Models/Tanks.dart';
import 'package:final_project/Models/User.dart';
import 'package:final_project/Models/WaterFlow.dart';
import 'package:final_project/Pages/ReportsExample.dart';
import 'package:final_project/Pages/TankPage.dart';
import 'package:final_project/Pages/views/Tanks_view.dart';
import 'package:final_project/Resources.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:final_project/ForgroundService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'ObjectBox.dart';
import 'Pages/TdsMainPage.dart';
import 'Pages/Dashboard.dart';
import 'Pages/views/Report_list_view.dart';

late ObjectBox objectbox;

late Admin admin;
late Size screenSize;

void flushData (){
  objectbox.waterFlow.removeAll();
  objectbox.singleTank.removeAll();
  objectbox.tanks.removeAll();
  objectbox.status.removeAll();

  debugPrint('4 models are flushed');
}
void addDefaults(){
  objectbox.tanks.put(Tanks(0, 'Test 1', 120, 0));
  objectbox.tanks.put(Tanks(1, 'Test 2', 500, 300));

  objectbox.status.put(Status('Pending'));
  objectbox.status.put(Status('Done'));
  objectbox.status.put(Status('Running'));

  // objectbox.user.put(User('Abdulkareem Alhamdani', '700', password))
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.requestPermission().then((value) async =>
      await initializeService()
      );

  try {
    objectbox = await ObjectBox.create();

    if (Admin.isAvailable()) {
      //for development, the phone broadcast database into the network
      //eneter it using the uri followed by index.html
      admin = Admin(objectbox.store, bindUri: 'http://127.0.0.1:8090');
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  // flushData();
  // addDefaults();
  // for (var i = 0; i < 1000; i++) {
  //   DateTime d = faker.date.dateTimeBetween(
  //       DateTime.now().subtract(const Duration(days: 10)), DateTime.now());

  //   double f1 = faker.randomGenerator.decimal(min: 0, scale: 100);
  //   double f2 = 100 - f1;

  //   WaterFlow w = WaterFlow(
  //       faker.randomGenerator.decimal(min: 200, scale: 800), f1, f2, 27, d);
  //   objectbox.waterFlow.put(w);
  //   debugPrint('$i');
  // }

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
          primarySwatch: Colors.purple,
          brightness: Brightness.light,
          textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black, fontSize: 20),
              bodyLarge: TextStyle(color: Colors.black, fontSize: 30),
              bodySmall: TextStyle(color: Colors.black, fontSize: 16),
              titleSmall: TextStyle(
                  color: Color.fromARGB(255, 71, 71, 71), fontSize: 12))),
      title: title,
      home: const Dashboard(),

      routes: {
        '/TdsMainPage': (context) => TdsMainPage(),
        // '/ReportsView': (context) => Report_list_view(),
        '/ReportsView': (context) => ReportsPage(),
        // '/TankView': (context) => Tanks_view(),
        '/TankView': (context) => TankPage(),
      },
      // darkTheme: ThemeData.dark(),
    );
  }
}
