import 'package:a_drivers/components/rounded_button.dart';
import 'package:a_drivers/components/rounded_input_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constatnts.dart';
import '../screens/otp.dart';
import 'background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController controller = TextEditingController();

    //this size provides total height and width of screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text("Welcome to something",
            //     style: TextStyle(fontWeight: FontWeight.bold)),
            Image.asset("assets/images/logo.png",
                height: size.height * 0.4, width: size.width * 0.8),
            SizedBox(height: size.height * 0.03),

            // RoundedButton(
            //     text: "SIGNIN",
            //     color: primaryLightColor,
            //     textcolor: Colors.black,
            //     press: () {}),
            RoundedInputField(
              hintText: "Phone Number",
              onchanged: (value) {},
              ccontroller: controller,
            ),

            RoundedButton(
                text: "LOGIN",
                widthbtn: 0.8,
                textcolor: Colors.white,
                color: primaryColor,
                padding_vertical: 20,
                padding_horizontal: 40,
                br: 30,
                press: () {
                  if (controller.text.length < 1) {
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

                  if (controller.text.length != ZambianPhoneLength) {
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

                  String phonenumber = controller.text;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OTPScreen(phone: phonenumber)),
                  );
                }),
            SizedBox(height: size.height * 0.02),

            const Text("Enter your phone number to login or signup.",
                style: TextStyle(color: primaryDarkColorMuted))
          ],
        ),
      ),
    );
  }
}

class OTPWidget extends StatelessWidget {
  OTPWidget(BuildContext context, String text);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
