import 'package:flutter/material.dart';

class _cartItemState extends StatelessWidget {
  final IconData icondata;
  final String text;
  final bool hasNav;

  const _cartItemState({
    Key? key,
    required this.text,
    required this.hasNav,
    required this.icondata,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: MediaQuery.of(context).size.width * 0.02,
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
    );
  }
}
