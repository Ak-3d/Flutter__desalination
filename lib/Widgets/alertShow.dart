import 'package:flutter/material.dart';

Future<bool> alertShow(
    BuildContext context, String message, String title) async {
  return await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Confirm'),
            onPressed: () async {
             await alertDialog(context,'Complete Process Successfully !',"Done");
              Navigator.pop(context, true);
              
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}

Future<bool> alertDialog(BuildContext context,String message ,String title)async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(title),
          content:  Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      });
}
