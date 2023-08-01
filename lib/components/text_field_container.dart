import 'package:flutter/material.dart';

import '../constatnts.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final Color  backgroundcolor;
  const TextFieldContainer({
    Key? key,
    required this.child,
    required this.width,
    required this.backgroundcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * width,
      decoration: BoxDecoration(
        color: backgroundcolor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
