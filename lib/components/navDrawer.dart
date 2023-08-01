import 'package:a_drivers/screens/DriverLogin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constatnts.dart';




class NavDrawerWidget extends StatefulWidget {
  final String? image;
  final String? phoneNumber;
  final String? name;

  NavDrawerWidget({
    Key? key,
    required this.name,
    required this.image,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<NavDrawerWidget> createState() => _NavDrawerWidgetState();
}

class _NavDrawerWidgetState extends State<NavDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: primaryDarkColor,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: widget.image,
              name: widget.name,
              phone: widget.phoneNumber,
              onClciked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 15),
            buildMenuItem(
              text: 'Driver Profile',
              icon: Icons.people,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 15),
            buildMenuItem(
              text: 'Order History',
              icon: Icons.list,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 15),
            buildMenuItem(
              text: 'Notifications',
              icon: Icons.notifications,
              onClicked: () => selectedItem(context, 3),

            ),
            const SizedBox(height: 15),
            buildMenuItem(
              text: 'Settings',
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 4),

            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Log out',
              icon: Icons.logout,
              onClicked: () => selectedItem(context, 5),

            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    final color = Colors.white;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int i) {
    Navigator.of(context).pop();
    switch (i) {
      case 0:
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => orderHistory(),
        // ));
        break;
      case 2:
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => ProfileScreen(),
        // ));
        break;
      case 3:
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => DriverLogin(),
        // ));
        break;
        case 6:
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => const CarHire(),
        // ));
        break;
      case 5:

        logOut();
        break;
    }

  }

  Widget buildHeader(
          {required String? urlImage,
          required String? name,
          required String? phone,
          required VoidCallback onClciked}) =>
      InkWell(
        onTap: onClciked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              urlImage == ""
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage("assets/images/profile_image.jpg"))
                  : CircleAvatar(
                      radius: 30, backgroundImage: NetworkImage(urlImage!)),
              SizedBox(height: 20),
              Container(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name!,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      phone!,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DriverLogin()),
      );
    });
  }
}
