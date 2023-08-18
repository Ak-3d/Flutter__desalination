import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () async {
              await showNotification(
                  'Complete Process Successfully !', "Done");
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}

Future<void> alertDialog(
    BuildContext context, String message, String title)async  {
  return await showNotification(title, message);
}

Future<void> showNotification(String title, String message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.show(
      222,
      title,
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          importance:Importance.max,
          priority:Priority.max,
          timeoutAfter: 5000,
          '111',
          'show',
          icon: 'ic_bg_service_small',
          ongoing: false,
          
        ),
        
      ), payload: 'Notification Payload');
}
