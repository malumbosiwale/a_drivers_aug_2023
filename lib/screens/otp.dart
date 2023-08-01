import 'package:a_drivers/utils/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constatnts.dart';
import 'DriverHome.dart';


class OTPScreen extends StatefulWidget {
  final String phone;

  const OTPScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  late String _verificationCode;
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  void pushToScreen(String pp) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  DriverHome(phone: pp,)),
    );
  }


  void getUserData(String pp) {
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(pp)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        String phone = documentSnapshot.get("phone_number");
        String fullname = documentSnapshot.get("fullname");
        String validation_status = documentSnapshot.get("validation status");
        String photo_person = documentSnapshot.get("photo_person");

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(const_phone, pp);
        if (documentSnapshot.get("fullname") != null) {
          await prefs.setString(const_fullname, fullname);
        } else {
          await prefs.setString(const_fullname, "");

        }
        if (documentSnapshot.get("validation status") != null) {
          await prefs.setString(const_validation_status, validation_status);
        }

        if (documentSnapshot.get("photo_person") != null) {
          await prefs.setString(const_photo_person, photo_person);
        }
        pushToScreen(pp);
      } else {
        print(pp);
        toastDataError("Could not find user data, something went wrong...");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 110),
          child: Center(
            child: Text("Verify +26${widget.phone}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Pinput(
              length: 6,
              showCursor: true,
              onCompleted: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(
                    PhoneAuthProvider.credential(
                        verificationId: _verificationCode, smsCode: pin),
                  )
                      .then((value) async {
                    if (value.user != null) {
                      String pp = widget.phone;
                      getUserData(pp);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  Fluttertoast.showToast(
                      msg: "Invalid OTP!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              }),
        )
      ]),
    );
  }

  _veryfiyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+26${widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            String pp = widget.phone;

            getUserData(pp);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          Fluttertoast.showToast(
              msg: "The provided phone number is not valid",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _veryfiyPhone();
  }
}
