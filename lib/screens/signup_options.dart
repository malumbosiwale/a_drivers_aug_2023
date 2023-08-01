import 'package:a_drivers/components/rounded_button.dart';
import 'package:flutter/material.dart';

import '../constatnts.dart';
import 'DriverRegistration.dart';

class SignupOptions extends StatefulWidget {
  const SignupOptions({Key? key}) : super(key: key);

  @override
  State<SignupOptions> createState() => _SignupOptionsState();
}

class _SignupOptionsState extends State<SignupOptions> {
  static const List<String> registration_type = <String>[
    'Driver',
    'Car Hire',
    'Bike Delivery',
    'Truck Hire',
    'Truck Driver',
    'Van Delivery'
  ];

  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Select Registration Type"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                RoundedButton(
                    text: registration_type[0],
                    press: () {openMe(registration_type[0]);},
                    color: primaryDarkColor,
                    textcolor: whitebg,
                    widthbtn: sizes.width * 0.8,
                    padding_vertical: 15,
                    padding_horizontal: 10,
                    br: 10),
                RoundedButton(
                    text: registration_type[1],
                    press: () {openMe(registration_type[1]);},
                    color: primaryDarkColor,
                    textcolor: whitebg,
                    widthbtn: sizes.width * 0.8,
                    padding_vertical: 15,
                    padding_horizontal: 10,
                    br: 10),
                RoundedButton(
                    text: registration_type[2],
                    press: () {openMe(registration_type[2]);},
                    color: primaryDarkColor,
                    textcolor: whitebg,
                    widthbtn: sizes.width * 0.8,
                    padding_vertical: 15,
                    padding_horizontal: 10,
                    br: 10),
                RoundedButton(
                    text: registration_type[3],
                    press: () {openMe(registration_type[3]);},
                    color: primaryDarkColor,
                    textcolor: whitebg,
                    widthbtn: sizes.width * 0.8,
                    padding_vertical: 15,
                    padding_horizontal: 10,
                    br: 10),
                RoundedButton(
                    text: registration_type[4],
                    press: () {openMe(registration_type[4]);},
                    color: primaryDarkColor,
                    textcolor: whitebg,
                    widthbtn: sizes.width * 0.8,
                    padding_vertical: 15,
                    padding_horizontal: 10,
                    br: 10),
                RoundedButton(
                    text: registration_type[5],
                    press: () {openMe(registration_type[5]);},
                    color: primaryDarkColor,
                    textcolor: whitebg,
                    widthbtn: sizes.width * 0.8,
                    padding_vertical: 15,
                    padding_horizontal: 10,
                    br: 10),
              ],
            ),
          )),
    );
  }

  void openMe(String registrationType) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>  RegisterDriver(registration_type: registrationType)),
    );
  }
}
