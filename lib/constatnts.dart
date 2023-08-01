import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const primaryGreen = Color(0xff00c853);
const primaryColor = Color(0xFFfd2e1d);
const primaryLightColor = Color(0XFFfc9900);
const primaryLightColor2 = Color(0XFFffcc00);
const primaryDarkColor = Color(0XFF444444);
const primaryDarkColorMuted = Color.fromARGB(183, 68, 68, 68);
const tfbc = Color.fromARGB(183, 178, 178, 178);
const whitebg = Color.fromARGB(255, 243, 243, 243);

const bool demo = true;

Uri login_url =
    Uri.http('192.168.8.104', 'twende_admin/api/postDriverInfo.php');
Uri login_url_live =
    Uri.https('root.zeecoder.tech', 'twende/api/postDriverInfo.php');

const kSpacingUnit = 10;
int ZambianPhoneLength = 10;

const String apikey = 'AIzaSyAuG_xTYm7ZC2O6wyRwEjMdtciaocYK9QM';
// const String apikey = 'AIzaSyD_2OZ5Mt7KFiNhFfzjhs8pF6okeFhDFhU';
const kTitleTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

int NumbersOnly(String value) {
  String numbers = value.replaceAll(new RegExp(r"\D"), "");

  var myInt = int.parse(numbers);
  assert(myInt is int);
  return myInt;
}

String generateRandom(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

const const_phone = "phone";
const const_fullname = "fullname";
const const_validation_status = "validation status";
const const_photo_person = "photo_person";
const const_fb_mid = "firebase_messagingid";
const set_offline_text =
    "You will not receive any notification of customers near you if you turn off your online status, are you sure you want to continue?";

const server_url = "http://192.168.8.104/";
const realurl = "https://root.zeecoder.tech/";

const const_first_name = "first_name";
const const_last_name = "last_name";
const const_alternate_number = "alternate_number";
const const_residential_area = "residential_area";
const const_city = "city";
const const_province = "province";
const const_car_type = "car_type";
const const_gender = "gender";
const const_dob = "dob";
const const_agent_name = "agent_name";
const const_online_status = "online_status";

void toastData(data) {
  Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: primaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

List<LatLng> decodePolyline(String encoded) {
  List<LatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;

    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    int dLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dLat;

    shift = 0;
    result = 0;

    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    int dLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dLng;

    LatLng p = LatLng((lat / 1E5), (lng / 1E5));
    poly.add(p);
  }

  return poly;
}

void sendNotification(List<String> messagingid, String title, String message,
    BuildContext context) async {
  final response = await http.post(
    Uri.parse('https://root.zeecoder.tech/notifications/index.php'),
    // headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    // },
    body: <String, String>{
      "title": title,
      "messagingid": messagingid.toString(),
      "message": message,
    },
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    if (kDebugMode) {
      print(response.body);
    }
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to post. ' + response.statusCode.toString());
  }
}
