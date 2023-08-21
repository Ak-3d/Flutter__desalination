import 'package:final_project/ConnectionHandler.dart';
import 'package:final_project/Core/Tanks_setup.dart';
import 'package:final_project/Core/password_setup.dart';
import 'package:final_project/Pages/About.dart';
import 'package:final_project/Pages/IrrigationPage.dart';
import 'package:final_project/Pages/ReportsExample.dart';
import 'package:final_project/Pages/SchedulePage.dart';
import 'package:final_project/Pages/SettingAndInfo.dart';
import 'package:final_project/Pages/TanksPage.dart';
import 'package:final_project/Pages/SystemPage.dart';
import 'package:final_project/Pages/TechInfo.dart';
import 'package:final_project/objectbox.g.dart';
import 'package:final_project/ForgroundService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Core/loginPage.dart';
import 'ObjectBox.dart';
import 'Pages/TdsMainPage.dart';
import 'Pages/Dashboard.dart';

late ObjectBox objectbox;

late Admin admin;
late Size screenSize;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission()
      .then((value) async => await initializeService());
  try {
    objectbox = await ObjectBox.create();
    if (Admin.isAvailable()) {
      //for development, the phone broadcast database into the network
      //eneter it using the uri followed by index.html
      admin = Admin(objectbox.store, bindUri: 'http://127.0.0.1:8090');
      /* TODO do this command ```adb forward tcp:8090 tcp:8090``` to
       Expose the IP into localhost:8090 in computer */
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
    bool isFirst = objectbox.user.isEmpty();
    ConnectionInterfaceWrapper.defaultInterface();

    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.light,
          // fontFamily: 'Roboto',
          fontFamily: 'Inter',
          textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black, fontSize: 20),
              bodyLarge: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
              bodySmall: TextStyle(color: Colors.black, fontSize: 16),
              titleSmall: TextStyle(
                  color: Color.fromARGB(255, 71, 71, 71), fontSize: 12))),
      title: title,
      home: const Dashboard(),

      routes: {
        '/TdsMainPage': (context) => const TdsMainPage(),
        '/Dashboard': (context) => const Dashboard(),
        '/ReportsView': (context) => const ReportsPage(),
        '/TanksSetup': (context) => const TanksSetup(),
        '/PasswordSetup': (context) => const PasswordSetup(passwordId: 1),
        '/login': (context) => LoginPage(),
        '/SchedulePage': (context) => const SchedulePage(),
        '/TanksPage': (context) => const TanksPage(),
        '/SystemPage': (context) => const SystemPage(),
        '/Settings': (context) => const SettingAndInfo(),
        '/TechInfo': (context) => const TechInfo(),
        '/About': (context) => const About(),
        '/IrrigationPage': (context) => const IrrigationPage(),
      },
      // initialRoute: '/Settings',
      // darkTheme: ThemeData.dark(),
    );
  }
}
