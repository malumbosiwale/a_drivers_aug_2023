import 'package:flutter/material.dart';

class ImageHolder extends StatefulWidget {
  ImageHolder({
    Key? key,
    required this.label,
    required this.childe,
    required this.onPress,
  }) : super(key: key);

  String label;
  Widget childe;
  VoidCallback onPress;

  @override
  State<ImageHolder> createState() => _ImageHolderState();
}

class _ImageHolderState extends State<ImageHolder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
      ),
      child: PhysicalModel(
        elevation: 10,
        color: Colors.white,
        child: InkWell(
          onTap: widget.onPress,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
            ),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 2,
                  child: widget.childe,
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "NimbusSanL",
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
