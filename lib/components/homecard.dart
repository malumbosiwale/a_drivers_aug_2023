import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../constatnts.dart';
import 'customImageHolder.dart';

class HomeCard extends StatelessWidget {
  Map<String, dynamic> mydata;

  final VoidCallback press;

  HomeCard({
    Key? key,
    required this.mydata,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // if (index == 0)
      SizedBox(
        height: 20,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: AspectRatio(
          aspectRatio: 3 / 2,
          child: Card(
            elevation: 10,
            shadowColor: Colors.grey.withOpacity(0.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: InkWell(
                  onTap: press,
                  child: customImageHolder(image: mydata['imagelink1']),
                ),
              ),
            ),
          ),
        ),
      ),

      Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            ListTile(
              leading: customText(s: "Car Make", size: 16),
              trailing: customText(s: mydata['car_make'], size: 16),
            ),
            ListTile(
              leading: customText(s: "Car Model", size: 16),
              trailing: customText(s: mydata['car_model'], size: 16),
            ),
            ListTile(
              leading: customText(s: "Fuel Type", size: 16),
              trailing: customText(s: mydata['fuel_type'], size: 16),
            ),
            ListTile(
              leading: customText(s: "Number Of Seats", size: 16),
              trailing: customText(s: mydata['number_of_seats'], size: 16),
            ),
            ListTile(
              leading: customText(s: "Transmission", size: 16),
              trailing: customText(s: mydata['transmission'], size: 16),
            ),
            ListTile(
              leading: customText(s: "Daily Rental Charge", size: 16),
              trailing: customText(
                  s: "ZMW ${mydata['daily_rental_price']}", size: 16),
            ),
            const Divider(height: 1, color: primaryDarkColor)
          ],
        ),
      ),
    ]);
  }
}

class customText extends StatefulWidget {
  customText(
      {Key? key,
      required this.s,
      required this.size,
      this.alignment = Alignment.center,
      this.color = primaryDarkColor,
      this.fontWeight = FontWeight.w400})
      : super(key: key);

  final Alignment alignment;
  final FontWeight fontWeight;
  final String s;
  final double size;
  var color;

  @override
  State<customText> createState() => _customTextState();
}

class _customTextState extends State<customText> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Text(
        widget.s,
        style: TextStyle(
            fontFamily: "OpenSans",
            fontWeight: widget.fontWeight,
            color: widget.color,
            fontSize: widget.size),
      ),
    );
  }
}
