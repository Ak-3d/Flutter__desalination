import 'package:flutter/material.dart';
import 'Pages/TdsMainPage.dart';
import 'Pages/Dashboard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Water Desalination Project';
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
