import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  static Future initialize(FlutterLocalNotificationsPlugin fp) async {
    var androidInitialize =
        new AndroidInitializationSettings("mipmap/ic_launcher");
    var iOSInit = new DarwinInitializationSettings();
    var initSettings =
        new InitializationSettings(android: androidInitialize, iOS: iOSInit);
    await fp.initialize(initSettings);
  }

  static Future showNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin flp}) async {
    AndroidNotificationDetails apcs = const AndroidNotificationDetails(
        "mychannellike", "channelName",
        playSound: true,
        // sound: RawResourceAndroidNotificationSound('NOTIFICATION'),
        importance: Importance.max,
        priority: Priority.max);

    var not =
        NotificationDetails(android: apcs, iOS: DarwinNotificationDetails());

    await flp.show(0, title, body, not);
  }
}
