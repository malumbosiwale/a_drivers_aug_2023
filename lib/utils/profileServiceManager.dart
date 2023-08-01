// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../constatnts.dart';
//
// void getOnlineStatus(String phone, BuildContext context, String username,
//     String profileImage) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString(const_phone, phone);
//
//   print("running here");
//   FirebaseFirestore.instance
//       .collection('drivers')
//       .doc(phone)
//       .get()
//       .then((DocumentSnapshot documentSnapshot) async {
//     var first_name;
//     var last_name;
//     var alternate_number;
//     var residential_area;
//     var city;
//     var province;
//     var car_type;
//     var gender;
//     var dob;
//     var agent_name;
//
//     if (documentSnapshot.data().toString().contains(const_first_name)) {
//       first_name = documentSnapshot.get(const_first_name);
//       await prefs.setString(
//           const_fullname, documentSnapshot.get(const_first_name));
//     } else {
//       await prefs.setString(const_fullname, "");
//       first_name = "";
//     }
//
//     if (documentSnapshot.data().toString().contains(const_last_name)) {
//       last_name = documentSnapshot.get(const_last_name);
//       await prefs.setString(
//           const_last_name, documentSnapshot.get(const_last_name));
//     } else {
//       last_name = "";
//       await prefs.setString(const_last_name, "");
//     }
//
//     if (documentSnapshot.data().toString().contains(const_alternate_number)) {
//       alternate_number = documentSnapshot.get(const_alternate_number);
//       await prefs.setString(
//           const_alternate_number, documentSnapshot.get(const_alternate_number));
//     } else {
//       alternate_number = "";
//       await prefs.setString(const_alternate_number, "");
//     }
//
//     if (documentSnapshot.data().toString().contains(const_residential_area)) {
//       residential_area = documentSnapshot.get(const_residential_area);
//       await prefs.setString(
//           const_residential_area, documentSnapshot.get(const_residential_area));
//     } else {
//       residential_area = "";
//       await prefs.setString(const_residential_area, "");
//     }
//
//     if (documentSnapshot.data().toString().contains(const_city)) {
//       city = documentSnapshot.get(const_city);
//       await prefs.setString(const_city, documentSnapshot.get(const_city));
//     } else {
//       city = "";
//       await prefs.setString(const_city, "");
//     }
//
//     if (documentSnapshot.data().toString().contains(const_province)) {
//       province = documentSnapshot.get(const_province);
//       await prefs.setString(
//           const_province, documentSnapshot.get(const_province));
//     } else {
//       province = "";
//       await prefs.setString(const_province, "");
//     }
//
//     if (documentSnapshot.data().toString().contains(const_car_type)) {
//       car_type = documentSnapshot.get(const_car_type);
//       await prefs.setString(car_type, documentSnapshot.get(car_type));
//     } else {
//       car_type = "";
//       await prefs.setString(car_type, "");
//     }
//
//     if (documentSnapshot.data().toString().contains(const_gender)) {
//       gender = documentSnapshot.get(const_gender);
//       await prefs.setString(const_gender, documentSnapshot.get(const_gender));
//     } else {
//       gender = "";
//       await prefs.setString(const_gender, "");
//     }
//
//     if (documentSnapshot.data().toString().contains(const_dob)) {
//       dob = documentSnapshot.get(const_dob);
//       await prefs.setString(const_dob, documentSnapshot.get(const_dob));
//     } else {
//       dob = "";
//       await prefs.setString(const_dob, "");
//     }
//
//     if (documentSnapshot.data().toString().contains(const_agent_name)) {
//       agent_name = documentSnapshot.get(const_agent_name);
//       await prefs.setString(
//           const_agent_name, documentSnapshot.get(const_agent_name));
//     } else {
//       agent_name = "";
//       await prefs.setString(const_agent_name, "");
//     }
//
//     // if (documentSnapshot.get(const_online_status) != null) {
//     //
//     //   activityb = true;
//     //   online_s = documentSnapshot.get(const_online_status).toString();
//     //
//     // } else {
//     //
//     //   activityb = true;
//     //   online_s = "online";
//     //
//     // }
//     //
//     //
//     // if (documentSnapshot.get("photo_person") != null) {
//     //   await prefs.setString(
//     //       const_photo_person, documentSnapshot.get("photo_person"));
//     // } else {
//     //
//     //   online_s = "online";
//     //
//     // }
//
//     final profile_info = <String, dynamic>{
//       "phonee": phone,
//       "username": username,
//       "profile_image": profileImage,
//       "first_name": first_name,
//       "last_name": last_name,
//       "alternate_number": alternate_number,
//       "residential_area": residential_area,
//       "city": city,
//       "province": province,
//       "car_type": car_type,
//       "gender": gender,
//       "dob": dob,
//       "agent_name": agent_name
//     };
//
//     if (first_name.replaceAll(' ', '') == "" ||
//         last_name.replaceAll(' ', '') == "" ||
//         alternate_number.replaceAll(' ', '') == "" ||
//         residential_area.replaceAll(' ', '') == "" ||
//         city.replaceAll(' ', '') == "" ||
//         province.replaceAll(' ', '') == "" ||
//         car_type.replaceAll(' ', '') == "" ||
//         gender.replaceAll(' ', '') == "" ||
//         dob.replaceAll(' ', '') == "" ||
//         agent_name.replaceAll(' ', '') == "") {
//       Fluttertoast.showToast(
//           msg: const_fullname,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => AddProfileInfo(profile_info: profile_info),
//       //   ),
//       // ).then((value) {
//       //   loginCheckFuture = getProfileInformation();
//       //
//       // });
//     } else {
//       Fluttertoast.showToast(
//           msg: "Everything looks fine!",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//   });
// }
