import 'package:flutter/material.dart';

class OutlinedCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color textcolor;
  final Color borderColor;
  final double padding_vertical;
  final double padding_horizontal;

  const OutlinedCustomButton({
    Key? key,
    required this.text,
    required this.press,
    required this.borderColor,
    required this.textcolor,
    required this.padding_vertical,
    required this.padding_horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: OutlinedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
            side: MaterialStateProperty.all(BorderSide(color: borderColor)),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                vertical: padding_vertical, horizontal: padding_horizontal)),
          ),
          onPressed: press,
          child: Text(text,
              style: TextStyle(
                fontFamily: "NimbusSanL",
                fontWeight: FontWeight.w700,
                color: textcolor,
                fontSize: 14,
              ))),
    );
  }
}
