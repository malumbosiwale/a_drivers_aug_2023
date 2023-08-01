import 'dart:async';
import 'dart:convert';

import 'package:a_drivers/components/homecard.dart';
import 'package:a_drivers/screens/selectJobs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as Bsh;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart' as geoMe;
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:http/http.dart' as http;
import '../../components/navDrawer.dart';
import '../../components/rounded_button.dart';
import '../../constatnts.dart';
import '../requests/directions_model.dart';
import '../utils/activeRides.dart';
import '../utils/jobs.dart';
import '../utils/notificationClass.dart';
import 'AcceptAndNavigation.dart';
import 'addProfileInfo.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DriverHome extends StatefulWidget {
  DriverHome({Key? key, required this.phone}) : super(key: key);

  var phone;

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

void checkNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   Noti.showNotification(
  //       title: message.data["title"],
  //       body: message.data["body"],
  //       flp: flutterLocalNotificationsPlugin);
  //
  //   if (kDebugMode) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');
  //   }
  //
  //   if (message.notification != null) {
  //     if (kDebugMode) {
  //       print('Message also contained a notification: ${message.notification}');
  //     }
  //   }
  // });
}

final kStartPosition = LatLng(-15.396223, 28.358053);
final kSantoDomingo = CameraPosition(target: kStartPosition, zoom: 15);
final kMarkerId = MarkerId('MarkerId1');
final kDuration = Duration(seconds: 20);
final kLocations = [
  kStartPosition,
  LatLng(-15.396233, 28.358471),
  LatLng(-15.396057, 28.359222),
  LatLng(-15.395985, 28.359716)
];

void checkFirebaseprofile(BuildContext context) {}

class _DriverHomeState extends State<DriverHome> {
  GoogleMapController? mapController;
  late Future<Map> loginCheckFuture;

  final geo = geoMe.GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;
  late Directions? _info = null;

  static LatLng _initialPosition = LatLng(-15.416667, 28.283333);
  String? phone;
  String? username;
  String? profileImage;
  String online_s = "online";
  bool activityb = false;

  var available_job = false;
  var amount = "";
  var job_phone = "";
  var job_curent_location = "";
  var job_destination_name = "";
  var jobs = [];
  bool checkjob = true;

  int avjobs = 0;

  LatLng pickup = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    checkMyJobActive(widget.phone);
    checkNotificationPermissions();
    Noti.initialize(flutterLocalNotificationsPlugin);
    stream.forEach((value) => newLocationUpdate(value));
    checkFirebaseprofile(context);
    loginCheckFuture = getProfileInformation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // Handle this case

        break;
      case AppLifecycleState.inactive:
        // Handle this case
        break;
      case AppLifecycleState.paused:
        // Handle this case
        break;

      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  Future<Map> getProfileInformation() async {
    Map myprofile = Map();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String phonee = localStorage.getString(const_phone).toString();
    String username = localStorage.getString(const_fullname).toString();
    String profile_image =
        localStorage.getString(const_photo_person).toString();

    myprofile["phone"] = phonee;
    myprofile["username"] = username;
    myprofile[const_photo_person] = profile_image;
    getUserLocation(mystuff, phonee);
    myToken(phonee);
    getOnlineStatus(phonee);
    setState(() {
      phone = phonee;
      username = username;
      profileImage = profileImage;
    });
    return myprofile;
  }

  @override
  void dispose() {
    super.dispose();
    mapController?.dispose();
  }

  int count = 0;

  final markers = <MarkerId, Marker>{};
  final controller = Completer<GoogleMapController>();
  final stream = Stream.periodic(kDuration, (count) => kLocations[count])
      .take(kLocations.length);
  bool mystuff = false;

  @override
  Widget build(BuildContext context) {
    return checkjob
        ? Container(
            color: whitebg,
            child: Center(
              child: SizedBox(
                height: 50,
                child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                  customWidths:
                      CustomSliderWidths(progressBarWidth: 5, handlerSize: 2),
                  customColors: CustomSliderColors(
                      trackColor: primaryLightColor,
                      progressBarColor: primaryColor),
                  spinnerMode: true,
                )),
              ),
            ),
          )
        : FutureBuilder(
            future: loginCheckFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map? mymap = snapshot.data as Map?;

                if (kDebugMode) {
                  print("object data " + snapshot.data.toString());
                }

                return myScaffold(mymap!);
              } else {
                return Container(
                  color: whitebg,
                  child: Center(
                    child: SizedBox(
                      height: 50,
                      child: SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                        customWidths: CustomSliderWidths(
                            progressBarWidth: 5, handlerSize: 2),
                        customColors: CustomSliderColors(
                            trackColor: primaryLightColor,
                            progressBarColor: primaryColor),
                        spinnerMode: true,
                      )),
                    ),
                  ),
                );
              }
            });
  }

  Scaffold myScaffold(Map<dynamic, dynamic> mymap) {
    return Scaffold(
      drawer: NavDrawerWidget(
          image: mymap[const_photo_person],
          name: mymap["username"],
          phoneNumber: mymap["phone"]),
      body: Builder(builder: (context) {
        return Stack(
          children: [
            Animarker(
              curve: Curves.ease,
              mapId: controller.future.then<int>((value) => value.mapId),
              markers: markers.values.toSet(),
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialPosition, zoom: 10.0),
                onMapCreated: onCreated,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                polylines: {
                  if (_info != null)
                    Polyline(
                        polylineId: const PolylineId('overview_polyline'),
                        color: primaryColor,
                        width: 5,
                        points: _info!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList())
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 253, 253, 253),
                      Color.fromARGB(55, 245, 245, 245)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Visibility(
                  // visible: true, child: showActivity(context)),
                  visible: true,
                  child: available_job == false
                      ? noActivity(context)
                      : showAvailableJob(context)),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: FloatingActionButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                child: const Icon(Icons.menu),
              ),
            ),
          ],
        );
      }),
    );
  }

  Card showAvailableJob(BuildContext context) {
    var texttt = "";
    if (avjobs == 1) {
      texttt = avjobs.toString() + " request near you";
    } else {
      texttt = avjobs.toString() + " requests near you";
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      // THIS NOT APPLYING !!!
      elevation: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                child: cardTextHeader(text: "You have " + texttt),
              ),
              subtitle: customText(
                  s: 'Click below to view available jobs.', size: 16),
            ),
          ),
          RoundedButton(
              text: "View",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectJobs(
                            phone: phone!,
                          )),
                );
              },
              color: primaryGreen,
              textcolor: whitebg,
              widthbtn: 0.85,
              padding_vertical: 16.0,
              padding_horizontal: 8.0,
              br: 16)
        ],
      ),
    );
  }

  Card noActivity(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      // THIS NOT APPLYING !!!
      elevation: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                child: cardTextHeader(text: "You curently have no activity"),
              ),
              subtitle: cardTextDescription(
                  text:
                      'Once a booking appears near your current location, you will receive a notification and details in this section.'),
            ),
          ),
          online_s == "online"
              ? Visibility(
                  visible: activityb,
                  child: RoundedButton(
                      text: "Set Offline",
                      press: () {
                        setOffline();
                      },
                      color: primaryColor,
                      textcolor: whitebg,
                      widthbtn: 0.85,
                      padding_vertical: 16.0,
                      padding_horizontal: 8.0,
                      br: 16),
                )
              : RoundedButton(
                  text: "Set Online",
                  press: () {
                    proceedOnline(context);
                  },
                  color: primaryGreen,
                  textcolor: whitebg,
                  widthbtn: 0.85,
                  padding_vertical: 16.0,
                  padding_horizontal: 8.0,
                  br: 16)
        ],
      ),
    );
  }

  Card showActivity(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('Accept Booking Request?'),
            subtitle: Text('Username User Phone Number.'),
            trailing: Icon(Icons.phone),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  /* ... */
                },
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Accept'),
                onPressed: () {
                  /* ... */
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void getUserLocation(bool checkme, String phone) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var fb_mid = localStorage.getString(const_fb_mid).toString();

    var locationstatus = await Permission.location.status;
    var fcmToken = await FirebaseMessaging.instance.getToken();

    if (!locationstatus.isGranted) {
      await Permission.location.request();
    }

    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        setGeohash(LatLng(position.latitude, position.longitude), phone,
            fcmToken, fb_mid);
        print("mylocation: " +
            LatLng(position.latitude, position.longitude).toString());
        _initialPosition = LatLng(position.latitude, position.longitude);
        _addMarker(
            LatLng(_initialPosition.latitude, _initialPosition.longitude),
            false);
      });
    } else {}
  }

  void setGeohash(
      LatLng latLng, String phone, String? fcmToken, String fb_mid) {
    GeoFirePoint myLocation =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    final washingtonRef =
        FirebaseFirestore.instance.collection("drivers").doc(phone);
    washingtonRef
        .update({"geohash": myLocation.data, "messaging_id": fcmToken}).then(
            (value) => print("geohash successfully updated!"),
            onError: (e) => print("Error updating document $e"));

    //upload to server

    Future<http.Response> uploadToTest(
        String user, String lat, String lon, String url) {
      return http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'user': user, 'lat': lat, 'lon': lon}),
      );
    }

    if (kDebugMode) {
      var complete = server_url + "twende_admin/api/post_gps.php";
      uploadToTest(phone, latLng.latitude.toString(),
          latLng.longitude.toString(), complete);
    } else {
      var complete = realurl + "twende_admin/api/post_gps.php";

      uploadToTest(phone, latLng.latitude.toString(),
          latLng.longitude.toString(), complete);
    }

    // myLocation.data
  }

  void _addMarker(LatLng pos, bool movecam) async {
    setState(() {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 15.0)),
      );
    });
  }

  void newLocationUpdate(LatLng latLng) {
    var marker = RippleMarker(
      markerId: kMarkerId,
      position: latLng,
      ripple: true,
    );
    setState(() => markers[kMarkerId] = marker);
  }

  void myToken(String phone) async {}

  void checkState() async {
    var state = "";
    if (state == "Active Ride") {
    } else if (state == "Reached Destination") {
    } else if (state == "Picking Up") {
    } else if (state == "Completed Up") {
    } else if (state == "Stand By") {
    } else if (state == "inactive") {}
  }

  void setOffline() {
    Bsh.showBarModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: Bsh.ModalScrollController.of(context),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                cardTextDescription(text: set_offline_text),
                RoundedButton(
                    text: "Proceed",
                    press: () {
                      proceedOffline(context);
                    },
                    color: primaryGreen,
                    textcolor: whitebg,
                    widthbtn: 1,
                    padding_vertical: 16.0,
                    padding_horizontal: 8.0,
                    br: 16),
                RoundedButton(
                    text: "Cancel",
                    press: () {
                      Navigator.pop(context);
                    },
                    color: primaryColor,
                    textcolor: whitebg,
                    widthbtn: 1,
                    padding_vertical: 16.0,
                    padding_horizontal: 8.0,
                    br: 16)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void proceedOffline(BuildContext cc) {
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(phone)
        .update({"online_status": "offline"}).then((value) {
      Navigator.pop(cc);
      getOnlineStatus(phone!);
      ("DocumentSnapshot successfully updated!");
    }, onError: (e) => print("Error updating document $e"));
  }

  void proceedOnline(BuildContext cc) {
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(phone)
        .update({"online_status": "online"}).then((value) {
      getOnlineStatus(phone!);
      ("DocumentSnapshot successfully updated!");
    }, onError: (e) => print("Error updating document $e"));
  }

  void getOnlineStatus(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(const_phone, phone);

    print("running here");
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(phone)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      final map = documentSnapshot.data() as Map<String, dynamic>;

      var first_name = "";
      var last_name = "";
      var alternate_number = "";
      var residential_area = "";
      var city = "";
      var province = "";
      var car_type = "";
      var gender = "";
      var dob = "";
      var agent_name = "";

      if (documentSnapshot.data().toString().contains(const_first_name)) {
        setState(() {
          first_name = map[const_first_name];
        });
      } else {
        setState(() {
          first_name = "";
        });
      }

      if (documentSnapshot.data().toString().contains(const_last_name)) {
        setState(() {
          last_name = map[const_last_name];
        });
      } else {
        setState(() {
          last_name = "";
        });
      }

      if (documentSnapshot.data().toString().contains(const_alternate_number)) {
        setState(() {
          alternate_number = map[const_alternate_number];
        });
      } else {
        setState(() {
          alternate_number = "";
        });
      }

      if (documentSnapshot.data().toString().contains(const_residential_area)) {
        setState(() {
          residential_area = map[const_residential_area];
        });
      } else {
        setState(() {
          residential_area = "";
        });
      }

      if (documentSnapshot.data().toString().contains(const_city)) {
        setState(() {
          city = map[const_city];
        });
      } else {
        setState(() {
          city = "";
        });
      }

      if (documentSnapshot.data().toString().contains(const_province)) {
        setState(() {
          province = map[const_province];
        });
      } else {
        setState(() {
          province = "";
        });
      }

      if (documentSnapshot.data().toString().contains(const_car_type)) {
        setState(() {
          car_type = map[const_car_type];
        });
      } else {
        setState(() {
          car_type = "";
        });
      }

      if (documentSnapshot.data().toString().contains(const_gender)) {
        setState(() {
          gender = map[const_gender];
        });
      } else {
        setState(() {
          gender = "";
        });
      }

      if (documentSnapshot.data().toString().contains(const_dob)) {
        setState(() {
          dob = map[const_dob];
        });
      } else {
        setState(() {
          dob = "";
        });
      }

      if (documentSnapshot.data().toString().contains(const_agent_name)) {
        setState(() {
          agent_name = map[const_agent_name];
        });
      } else {
        setState(() {
          agent_name = "";
        });
      }

      if (map["online_status"] != null) {
        setState(() {
          activityb = true;
          online_s = map["online_status"].toString();
        });
      } else {
        setState(() {
          activityb = true;
          online_s = "online";
        });
      }

      if (map["photo_person"] != null) {
        await prefs.setString(
            const_photo_person, documentSnapshot.get("photo_person"));
      } else {
        setState(() {
          online_s = "online";
        });
      }

      final profile_info = <String, dynamic>{
        "phonee": phone,
        "username": map[const_fullname],
        "profile_image": map[const_photo_person],
        "first_name": first_name,
        "last_name": last_name,
        "alternate_number": alternate_number,
        "residential_area": residential_area,
        "city": city,
        "province": province,
        "car_type": car_type,
        "gender": gender,
        "dob": dob,
        "agent_name": agent_name,
        "online_status": map["online_status"],
      };

      uploadDriverInfotoServer(profile_info);
      if (first_name.replaceAll(' ', '') == "" ||
          last_name.replaceAll(' ', '') == "" ||
          alternate_number.replaceAll(' ', '') == "" ||
          residential_area.replaceAll(' ', '') == "" ||
          city.replaceAll(' ', '') == "" ||
          province.replaceAll(' ', '') == "" ||
          car_type.replaceAll(' ', '') == "" ||
          gender.replaceAll(' ', '') == "" ||
          dob.replaceAll(' ', '') == "" ||
          agent_name.replaceAll(' ', '') == "") {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProfileInfo(profile_info: profile_info),
            ),
          ).then((value) {
            loginCheckFuture = getProfileInformation();
          });
        });
      } else {}
    });
  }

  void uploadDriverInfotoServer(Map<String, dynamic> profile_info) async {
    // print("print info: "+profile_info.toString());
    if (demo) {
      var url = login_url;
      print(url);

      var response = await http.post(url, body: profile_info);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } else {
      var url = login_url_live;
      print(url.toString());
      var response = await http.post(url, body: profile_info);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void checkMyJobActive(String phone) async {
    final docRef = await FirebaseFirestore.instance
        .collection("active_rides")
        .where("driver_phone", isEqualTo: phone)
        .where("status", isNotEqualTo: "completed")
        .get();

    if (docRef.docs.isNotEmpty) {
      var documentSnapshot = docRef.docs[0];

      if (documentSnapshot != null && documentSnapshot.exists) {
        var data = documentSnapshot.data();

        // do something with the data
        var docdata = ActiveRides.fromJson(documentSnapshot.id, data);
        // AcceptAndNavigate(data: docid, phone: phone);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AcceptAndNavigate(data: docdata, phone: phone)),
        );
        print('Document data: $data');
      } else {
        setState(() {
          checkjob = false;
        });
        // handle the case where the document does not exist
        print('Document does not exist');
        checkAvailableJobs();
      }
    } else {
      setState(() {
        checkjob = false;
      });
      checkAvailableJobs();
      // handle the case where no documents match the query
      print('No documents found');
    }

    //check available jobs
  }

  void checkAvailableJobs() async {
    var users = FirebaseFirestore.instance
        .collection('active_rides')
        .where("status", isEqualTo: "created");

    await users.get().then((querySnapshot) {
      count = querySnapshot.size;
      setState(() {
        avjobs = count;
      });
      if (count != 0) {
        available_job = true;
      }
    });
  }
}

class cardTextHeader extends StatelessWidget {
  final String text;

  cardTextHeader({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'OpenSans', fontWeight: FontWeight.w700, fontSize: 20),
    );
  }
}

class cardTextDescription extends StatelessWidget {
  final String text;

  const cardTextDescription({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'OpenSans', fontWeight: FontWeight.w300, fontSize: 17),
    );
  }
}
