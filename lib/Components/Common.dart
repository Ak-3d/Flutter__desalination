import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppScofflding extends StatelessWidget {
  const AppScofflding({Key? key, final String this.title = 'title', required this.widget}) : super(key: key);

  final String title;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar:AppBar(
          title: Title(
            color: Colors.black,
            title: title,
            child: Text(title),
            ),
          ),
          body: widget,
        ),
    );
  }
}