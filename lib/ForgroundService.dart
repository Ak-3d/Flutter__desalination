import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:final_project/ConnectionHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.none, // importance must be at low or higher level
    playSound: false,
    enableVibration: false,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_bg_service_small'),
        ), onDidReceiveNotificationResponse: (details) {
      switch (details.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          debugPrint('tapped notef');
          break;
        case NotificationResponseType.selectedNotificationAction:
          debugPrint('tapped notef action');
          break;

        default:
      }
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,
      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
    ),
  );

  service.startService();
}

const String disconnectID = 'disconnectID';
const String stopServiceID = 'stopServiceID';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint(notificationResponse.toString());
  switch (notificationResponse.actionId) {
    case disconnectID:
      disconnect();
      break;
    case stopServiceID:
      FlutterBackgroundService().invoke('stopService');
      debugPrint('stopped service'); //TODO Delete
      break;
    default:
  }
}

void tryReconnect(String origin) {
  String d = 'trying again from: $origin';
  debugPrint(d); //TODO Delete
  updateNotification(d);

  Future.delayed(const Duration(seconds: 2), () {
    connect();
  });
}

void udpConnected(Stream<dynamic> udp) {
  updateNotification('udp connected, looking for IP');

  late Stream<dynamic>? webSocket;
  udp.listen((data) {
    if (data == null) return;
    var str = String.fromCharCodes(data.data);
    var substr = str.toString().substring(4);

    var r = RegExp(r"^(\d{1,3}\.){3}\d{1,3}$");
    if (!r.hasMatch(substr)) return;

    connectionHandler.closeUDP();
    webSocket = connectionHandler.connectWebSocket(ipaddress: substr);
    if (webSocket == null) {
      tryReconnect('websocket connection');
      return;
    }
    webSocketConnected(webSocket);
  }, onError: (e) {
    if (connectionHandler.isWebsocketCreated) return;
    connectionHandler.closeUDP();
    tryReconnect('udp error');
  }, onDone: () {
    if (connectionHandler.isWebsocketCreated) return;
    connectionHandler.closeUDP();
    tryReconnect('udp done');
  }, cancelOnError: true);
}

void webSocketConnected(Stream<dynamic>? websocket) {
  updateNotification('Connected to websocket');

  websocket!.listen((data) {
    srv.invoke('update', {'data': data});
    updateNotification(data.toString());
  }, onError: (e) {
    connectionHandler.closeWebsocket();
    tryReconnect('websocket error');
  }, onDone: () {
    connectionHandler.closeWebsocket();
    tryReconnect('websocket done');
  }, cancelOnError: true);
}

updateNotification(String txt) {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.show(
    888,
    'Disalination System',
    txt,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'my_foreground',
        'MY FOREGROUND SERVICE',
        icon: 'ic_bg_service_small',
        ongoing: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            disconnectID,
            'Disconnect',
            // icon: DrawableResourceAndroidBitmap('food'),
          ),
          AndroidNotificationAction(
            stopServiceID,
            'Stops',
            titleColor: Color.fromARGB(255, 255, 0, 0),
            // icon: DrawableResourceAndroidBitmap('secondary_icon'),
          ),
        ],
      ),
    ),
  );
}

late ConnectionHandler connectionHandler;
late ServiceInstance srv;
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  srv = service;
  connectionHandler = ConnectionHandler();

  service.on('stopService').listen((event) {
    connectionHandler.dispose();
    service.stopSelf();
  });
  service.on('Connect').listen((e) => connect());
  service.on('ConnectDirectly').listen((e) {
    connectDirectly(e?['ip'] ?? '192.168.1.102');
  });
  service.on('Send').listen((e) {
    connectionHandler.sendWebsocket(e?['msg'].toString() ?? '.');
  });
  service.on('Disconnect').listen((event) {
    connectionHandler.dispose();
  });

  Timer.periodic(const Duration(seconds: 10), (timer) {
    if (!connectionHandler.isWebsocketCreated) return;

    connectionHandler.sendWebsocket('check:${timer.tick}');
  });

  // connectDirectly('192.168.43.133');
  connect();
}

void connect() async {
  if (connectionHandler.isWebsocketCreated || connectionHandler.isUDPCreated) {
    return;
  }

  Stream<dynamic>? udp = await connectionHandler.connectUDP();
  if (udp == null) {
    tryReconnect('udp connection');
    return;
  }
  udpConnected(udp);
}

void connectDirectly(String ip) {
  try {
    var webSocket = connectionHandler.connectWebSocket(ipaddress: ip);
    webSocketConnected(webSocket);
  } catch (e) {
    updateNotification('$e');
  }
}

void disconnect() {
  FlutterBackgroundService().invoke('Disconnect');
}
