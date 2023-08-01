import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String not_set = "Not set";

void getUserData(phonenumber) {
  var db = FirebaseFirestore.instance;
  final docRef = db.collection("users").doc(phonenumber);
  docRef.get().then(
    (DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      String vfs = data["validation status"] ?? not_set;
      String businessIdNumber = data["business_id_number"] ?? not_set;
      String businessNumberplate = data["business_numberplate"] ?? not_set;
      String driversLicenceBack = data["drivers_licence_back"] ?? not_set;
      String driversLicenceFront = data["drivers_licence_front"] ?? not_set;
      String driverstatus = data["driverstatus"] ?? not_set;
      String fullname = data["fullname"] ?? not_set;
      String phone = data["phone"] ?? not_set;
      String photoPerson = data["photo_person"] ?? not_set;
      String vehicleBack = data["vehicle_back"] ?? not_set;
      String vehicleFront = data["vehicle_front"] ?? not_set;

      // toastData(vfs);
      updateDriverStatus(vfs);
    },
    onError: (e) => print("Error getting document: $e"),
  );
}

void toastData(data) {
  Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

void toastDataError(data) {
  Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void sendEmail(String message, String emailAddress, String subject,
    String fullname) async {
  var url = Uri.parse("https://root.zeecoder.tech/twende/email/sendMail.php");

  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var request = http.Request('POST', url);
  request.bodyFields = {
    'email': emailAddress,
    'subject': subject,
    'fullname': fullname,
    'message': message,
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // toastDataError(await response.stream.bytesToString());

    print(await response.stream.bytesToString());
  } else {
    // toastDataError(await response.statusCode);
    print(response.statusCode);
  }
}

void updateDriverStatus(String vfs) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("validation status", vfs);
}

void initializeFcm(phonenumber) async {
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
  firebaseNotificationUpdate(phonenumber);
}

void firebaseNotificationUpdate(phonenumber) {
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    toastData(fcmToken);

    updateData(phonenumber, "messagingId", fcmToken);
  }).onError((err) {
    toastData("token error");
    // Error getting token.
  });
}

void addRideData(data, GeoFlutterFire geo) {
  // final data = {"name": "Tokyo", "country": "Japan"};
  var db = FirebaseFirestore.instance;

  db
      .collection("active_rides")
      .doc(data["phone"].toString())
      .set(data)
      .then((documentSnapshot) => beginDriverSearch(data, geo));
}

void beginDriverSearch(data, GeoFlutterFire geo) {
  // Create a geoFirePoint
  GeoFirePoint center = geo.point(
      latitude: double.parse(data["pickup"]["lat"].toString()),
      longitude: double.parse(data["pickup"]["lon"].toString()));

  var db = FirebaseFirestore.instance;

  var collectionReference =
      db.collection('users').where("validation status", isEqualTo: "active");

  double radius = 50;
  String field = 'geohash';

  Stream<List<DocumentSnapshot>> stream = geo
      .collection(collectionRef: collectionReference)
      .within(center: center, radius: radius, field: field);
}

void updateData(phonenumber, field, value) {
  var db = FirebaseFirestore.instance;
  final docRef = db.collection("users").doc(phonenumber);
  docRef.update({field: value}).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"));
}
