import 'package:a_drivers/screens/PrivacyPolicy.dart';
import 'package:a_drivers/screens/signup_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../components/background.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../constatnts.dart';
import '../utils/userData.dart';
import 'DriverHome.dart';
import 'DriverRegistration.dart';
import 'otp.dart';

class DriverLogin extends StatefulWidget {
  const DriverLogin({Key? key}) : super(key: key);

  @override
  State<DriverLogin> createState() => _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
  String? validation_status;
  bool visibility = false;
  bool circularP = false;
  TextEditingController phonenumber_cc = TextEditingController();

  //must be true
  bool login_visibility = false;
  bool checked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text("Welcome to something",
            //     style: TextStyle(fontWeight: FontWeight.bold)),
            Image.asset("assets/images/logo.png",
                height: size.height * 0.4, width: size.width * 0.8),
            SizedBox(height: size.height * 0.03),
            Visibility(
              visible: circularP,
              child: CircularProgressIndicator(
                semanticsLabel: 'Linear progress indicator',
              ),
            ),
            RoundedInputField(
              hintText: "Phone Number",
              icon: Icons.phone,
              inputType: TextInputType.number,
              maxLength: 10,
              onchanged: (value) {},
              ccontroller: phonenumber_cc,
            ),

            Visibility(
              visible: false,
              child: SizedBox(
                height: 50,
                child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                  customWidths:
                      CustomSliderWidths(progressBarWidth: 5, handlerSize: 2),
                  customColors: CustomSliderColors(
                      trackColor: primaryLightColor,
                      progressBarColor: primaryColor),
                  spinnerMode: true,
                )),
              ),
            ),
            CheckboxListTile(
              checkColor: whitebg,
              activeColor: primaryColor,
              value: checked,
              onChanged: (bool? value) {
                setState(() {
                  checked = value!;

                  if (value) {
                    login_visibility = value;
                    visibility = value;
                  } else {
                    login_visibility = false;
                    visibility = false;
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              enableFeedback: true,
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy()),
                  );
                },
                child: Text(
                  'I agree to the Privacy Policy',
                  style: GoogleFonts.openSans(color: Colors.black),
                ),
              ),
            ),
            Visibility(
                visible: login_visibility,
                child: RoundedButton(
                    text: "LOGIN",
                    widthbtn: 0.8,
                    textcolor: Colors.white,
                    color: primaryColor,
                    padding_vertical: 20,
                    padding_horizontal: 40,
                    br: 30,
                    press: () {
                      if (phonenumber_cc.text.length < 1) {
                        Fluttertoast.showToast(
                            msg: "Phone number required!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }

                      if (phonenumber_cc.text.length != ZambianPhoneLength) {
                        Fluttertoast.showToast(
                            msg: "Phone number must be 10 chaacters long!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        return;
                      }

                      setState(() {
                        login_visibility = false;
                      });
                      String phonenumber = phonenumber_cc.text;

                      var docRef = FirebaseFirestore.instance
                          .collection("drivers")
                          .doc(phonenumber);
                      docRef.get().then(
                        (DocumentSnapshot doc) {
                          if (doc.exists) {
                            var data = doc.data() as Map<String, dynamic>;

                            var validation_status =
                                data["validation status"].toString();

                            if (validation_status == "active") {
                              setState(() {
                                login_visibility = true;
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OTPScreen(phone: phonenumber)),
                              );
                            } else {
                              setState(() {
                                login_visibility = true;
                              });
                              toastDataError(
                                  "Your account has been registered but not been approved ");
                            }
                          } else {
                            setState(() {
                              login_visibility = true;
                            });
                            toastDataError(
                                "Your account does not exist, please register");
                          }
                        },
                        onError: (e) {
                          setState(() {
                            login_visibility = true;
                          });
                          toastDataError(
                              "Error connecting to a network, please check your connection.");
                          print("Error getting document: $e");
                        },
                      );

                      // check if account is verified before going to OTP
                    })),

            Visibility(
              visible: visibility,
              child: RoundedButton(
                  text: "Registration",
                  widthbtn: 0.8,
                  textcolor: Colors.white,
                  color: primaryDarkColor,
                  padding_vertical: 20,
                  padding_horizontal: 40,
                  br: 30,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupOptions()),
                    );
                  }),
            ),
            SizedBox(height: 10),
            Visibility(
                visible: false,
                child: const Text(
                    "Please wait while your information gets verified .",
                    style: TextStyle(color: primaryDarkColorMuted))),
          ],
        ),
      ),
    );
  }

  void getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    validation_status = prefs.getString("validation status");
    setState(() {
      circularP = false;
    });
    if (validation_status == "submitted") {
      setState(() {
        if (checked) {
          visibility = true;
        }
      });
    } else if (validation_status == "active") {
      setState(() {
        if (checked) {
          visibility = true;
        }
      });
      String? pp = prefs.getString(const_phone);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DriverHome(phone: pp)),
      );
    } else {
      setState(() {
        if (checked) {
          visibility = true;
        }
      });
    }
  }
}
