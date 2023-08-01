import 'package:flutter/material.dart';

import '../constatnts.dart';
import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final double width;
  final int maxLength;
  final Color bc;
  final TextInputType inputType;
  final TextEditingController ccontroller;
  final ValueChanged<String> onchanged;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.phone,
    this.inputType = TextInputType.phone,
    this.obscureText = false,
    this.width = 0.8,
    this.maxLength = 10,
    this.bc = primaryLightColor,
    required this.onchanged,
    required this.ccontroller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      backgroundcolor: bc,
      width: width,
      child: TextField(
        obscureText: obscureText,
          onChanged: onchanged,
          keyboardType: inputType,
          controller: ccontroller,
          maxLength: maxLength,
          decoration: InputDecoration(
              icon: Icon(icon, color: primaryColor),
              hintText: hintText,
              counterStyle: TextStyle(
                height: double.minPositive,
              ),
              counterText: "",
              border: InputBorder.none)),
    );
  }
}
