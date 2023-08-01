import 'package:a_drivers/components/rounded_button.dart';
import 'package:a_drivers/components/rounded_input_field.dart';
import 'package:a_drivers/constatnts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'DriverHome.dart';

class AddProfileInfo extends StatefulWidget {
  var profile_info;

  AddProfileInfo({Key? key, required this.profile_info}) : super(key: key);

  @override
  State<AddProfileInfo> createState() => _AddProfileInfoState();
}

var cc_first_name = TextEditingController();
var cc_last_name = TextEditingController();
var cc_alternate_number = TextEditingController();
var cc_residential_area = TextEditingController();
var cc_city = TextEditingController();
var cc_province = TextEditingController();
var cc_car_type = TextEditingController();
var cc_gender = TextEditingController();
var cc_dob = TextEditingController();
var cc_agent_name = TextEditingController();

var isvidible = true;

class _AddProfileInfoState extends State<AddProfileInfo> {
  @override
  Widget build(BuildContext context) {
    var phonee = widget.profile_info["phonee"];
    var username = widget.profile_info["username"];
    var profile_image = widget.profile_info["profile_image"];
    var first_name = widget.profile_info["first_name"];
    var last_name = widget.profile_info["last_name"];
    var alternate_number = widget.profile_info["alternate_number"];
    var residential_area = widget.profile_info["residential_area"];
    var city = widget.profile_info["city"];
    var province = widget.profile_info["province"];
    var car_type = widget.profile_info["car_type"];
    var gender = widget.profile_info["gender"];
    var dob = widget.profile_info["dob"];
    var agent_name = widget.profile_info["agent_name"];

    cc_first_name.text = first_name;
    cc_last_name.text = last_name;
    cc_alternate_number.text = alternate_number;
    cc_residential_area.text = residential_area;
    cc_city.text = city;
    cc_province.text = province;
    cc_car_type.text = car_type;
    cc_gender.text = gender;
    cc_dob.text = dob;
    cc_agent_name.text = agent_name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: Icon(Icons.question_mark),
        title: Text(
          "Some Information is missing",
          style: GoogleFonts.lato(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              RoundedInputField(
                  width: 1,
                  bc: tfbc,
                  icon: Icons.perm_identity,
                  inputType: TextInputType.text,
                  maxLength: 50,
                  hintText: "First Name",
                  onchanged: (value) {},
                  ccontroller: cc_first_name),
              RoundedInputField(
                  width: 1,
                  bc: tfbc,
                  inputType: TextInputType.text,
                  icon: Icons.perm_identity,
                  maxLength: 50,
                  hintText: "Last Name",
                  onchanged: (value) {},
                  ccontroller: cc_last_name),
              RoundedInputField(
                  width: 1,
                  bc: tfbc,
                  icon: Icons.phone,
                  maxLength: 50,
                  inputType: TextInputType.phone,
                  hintText: "Alternative Number",
                  onchanged: (value) {},
                  ccontroller: cc_alternate_number),
              RoundedInputField(
                  width: 1,
                  bc: tfbc,
                  icon: Icons.location_city,
                  maxLength: 50,
                  inputType: TextInputType.text,
                  hintText: "City",
                  onchanged: (value) {},
                  ccontroller: cc_city),
              RoundedInputField(
                  width: 1,
                  bc: tfbc,
                  icon: Icons.location_on,
                  maxLength: 50,
                  inputType: TextInputType.text,
                  hintText: "Residential Area",
                  onchanged: (value) {},
                  ccontroller: cc_residential_area),
              RoundedInputField(
                  width: 1,
                  bc: tfbc,
                  maxLength: 50,
                  icon: Icons.location_history,
                  inputType: TextInputType.text,
                  hintText: "Province",
                  onchanged: (value) {},
                  ccontroller: cc_province),
              RoundedInputField(
                  width: 1,
                  bc: tfbc,
                  maxLength: 50,
                  icon: Icons.car_crash_sharp,
                  inputType: TextInputType.text,
                  hintText: "Car Type",
                  onchanged: (value) {},
                  ccontroller: cc_car_type),
              RoundedInputField(
                  width: 1,
                  bc: tfbc,
                  maxLength: 50,
                  icon: Icons.female,
                  hintText: "Gender",
                  inputType: TextInputType.text,
                  onchanged: (value) {},
                  ccontroller: cc_gender),
              RoundedInputField(
                  width: 1,
                  bc: tfbc,
                  maxLength: 4,
                  icon: Icons.calendar_month,
                  inputType:
                      const TextInputType.numberWithOptions(signed: true),
                  hintText: "Year of Birth",
                  onchanged: (value) {},
                  ccontroller: cc_dob),
              RoundedInputField(
                  width: 1,
                  bc: tfbc,
                  maxLength: 50,
                  icon: Icons.person,
                  inputType: TextInputType.text,
                  hintText: "Agent Name",
                  onchanged: (value) {},
                  ccontroller: cc_agent_name),
              Visibility(
                visible: isvidible,
                child: RoundedButton(
                    text: "Save",
                    press: () {
                      updateProfile();
                    },
                    color: primaryColor,
                    textcolor: Colors.white,
                    widthbtn: 1,
                    padding_vertical: 16,
                    padding_horizontal: 16,
                    br: 32),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateProfile() {
    if (cc_first_name.text == "") {
      Fluttertoast.showToast(
          msg: "First name required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    if (cc_last_name.text == "") {
      Fluttertoast.showToast(
          msg: "Last name required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (cc_alternate_number.text == "") {
      Fluttertoast.showToast(
          msg: "Alternative number required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (cc_residential_area.text == "") {
      Fluttertoast.showToast(
          msg: "Residential area required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (cc_city.text == "") {
      Fluttertoast.showToast(
          msg: "City required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (cc_province.text == "") {
      Fluttertoast.showToast(
          msg: "Province required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (cc_car_type.text == "") {
      Fluttertoast.showToast(
          msg: "Car type required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (cc_gender.text == "") {
      Fluttertoast.showToast(
          msg: "Gender required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (cc_dob.text == "") {
      Fluttertoast.showToast(
          msg: "Year of birth required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (cc_agent_name.text == "") {
      Fluttertoast.showToast(
          msg: "Agent name required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      isvidible = false;
    });
    var db = FirebaseFirestore.instance;
    final docRef = db.collection("drivers").doc(widget.profile_info["phonee"]);
    docRef.update({
      const_first_name: cc_first_name.text.toString(),
      const_last_name: cc_last_name.text,
      const_alternate_number: cc_alternate_number.text,
      const_residential_area: cc_residential_area.text,
      const_city: cc_city.text,
      const_province: cc_province.text,
      const_car_type: cc_car_type.text,
      const_dob: cc_dob.text,
      const_gender: cc_gender.text,
      const_agent_name: cc_agent_name.text
    }).then((value) {
      Navigator.pop(context, true);
      // print("DocumentSnapshot successfully updated!");
    }, onError: (e) => print("Error updating document $e"));
  }
}
