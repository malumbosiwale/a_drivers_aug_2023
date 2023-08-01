import 'package:a_drivers/screens/DriverHome.dart';
import 'package:a_drivers/screens/DriverLogin.dart';
import 'package:a_drivers/utils/notificationClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constatnts.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void checkNotificationPermissions() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Noti.showNotification(title: "title", body: message.data["body"], flp: flutterLocalNotificationsPlugin);

    if (kDebugMode) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.data["title"],
        message.data["body"],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            // other properties...
          ),
        ),
      );
    }

    if (message.notification != null) {
      if (kDebugMode) {
        print('Message also contained a notification: ${message.notification}');
      }
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  checkNotificationPermissions();
  Noti.initialize(flutterLocalNotificationsPlugin);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atwende',
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: whitebg),
          primaryColor: whitebg,
          scaffoldBackgroundColor: whitebg),
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  late Future<bool> loginCheckFuture;
  String? phone;

  @override
  void initState() {
    super.initState();
    loginCheckFuture = _checkIfLoggedIn();
  }

  Future<bool> _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString(const_phone);
    if (token != null) {
      setState(() {
        phone  = token;
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loginCheckFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return  DriverHome(phone: phone);
            } else {
              return const DriverLogin();
            }
          } else {
            // future hasnt completed yet
            return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              semanticsLabel: 'Linear progress indicator',
            );
          }
        });
  }
}
