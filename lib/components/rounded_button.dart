import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final double widthbtn;
  final VoidCallback press;
  final Color color, textcolor;
  final double padding_vertical;
  final double padding_horizontal;
  final double br;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    required this.color,
    required this.textcolor,
    required this.widthbtn,
    required this.padding_vertical,
    required this.padding_horizontal,
    required this.br,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * widthbtn,
      child:TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(br))),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                  vertical: padding_vertical, horizontal: padding_horizontal)),
              backgroundColor: MaterialStateProperty.all<Color>(color)),
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
