import 'package:a_drivers/components/homecard.dart';
import 'package:a_drivers/components/rounded_button.dart';
import 'package:a_drivers/constatnts.dart';
import 'package:a_drivers/utils/activeRides.dart';
import 'package:a_drivers/utils/jobs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as slippery;

import '../requests/directions_model.dart';
import '../requests/directions_repository.dart';

class AcceptAndNavigateFromJobs extends StatefulWidget {
  AcceptAndNavigateFromJobs({Key? key, required this.data, required this.phone})
      : super(key: key);

  ActiveRides data;
  String phone;

  @override
  State<AcceptAndNavigateFromJobs> createState() => _AcceptAndNavigateFromJobsState();
}

class _AcceptAndNavigateFromJobsState extends State<AcceptAndNavigateFromJobs> {
  LatLng _initialPosition = LatLng(-15.416667, 28.283333);
  GoogleMapController? mapController;
  late Directions? _info = null;
  var hide = false;

  @override
  void initState() {
    checkState();
    getCurrentLocation(widget.data);
    setActiveJob(widget.data, widget.phone);
    pickupToDestination(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var snackBar = const SnackBar(
          content: Text('Mark or cancel job to exit.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Active Job"),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialPosition, zoom: 10.0),
              onMapCreated: onCreated,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: true,
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
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  // THIS NOT APPLYING !!!
                  elevation: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: customText(
                          s: 'DRIVE TO CLIENTS LOCATION',
                          size: 20,
                          alignment: Alignment.topLeft,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: SizedBox(
                          height: 1,
                          child: Container(
                            color: primaryDarkColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: customText(
                          s: 'John Doe',
                          size: 17,
                          alignment: Alignment.topLeft,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      RoundedButton(
                        text: 'Notify Of Arrival',
                        press: () {},
                        color: primaryColor,
                        textcolor: whitebg,
                        widthbtn: 0.9,
                        padding_vertical: 16,
                        padding_horizontal: 16,
                        br: 32,
                      ),
                      hide
                          ? RoundedButton(
                              text: 'Cancel Job',
                              press: () {
                                DeleteJob(widget.phone, context);
                              },
                              color: primaryColor,
                              textcolor: whitebg,
                              widthbtn: 0.9,
                              padding_vertical: 16,
                              padding_horizontal: 16,
                              br: 32,
                            )
                          : const SizedBox(
                              height: 1,
                            ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  void dispose() {
    super.dispose();
    mapController?.dispose();
  }

  void getCurrentLocation(ActiveRides data) async {
    var locationstatus = await Permission.location.status;
    if (!locationstatus.isGranted) {
      await Permission.location.request();
    }
    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      slippery.Location location = new slippery.Location();

      var ddd = data.pickup;
      var dddlon = double.parse(ddd["lon"].toString());
      var dddlat = double.parse(ddd["lat"].toString());

      var pickup = LatLng(dddlat, dddlon);

      location.onLocationChanged
          .listen((slippery.LocationData currentLocation) {
        // Use current location

        showPoly(LatLng(currentLocation.latitude!, currentLocation.longitude!),
            pickup);

        setState(() {
          _initialPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);

          mapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _initialPosition, zoom: 15.0)));
        });
      });
    } else {}
  }

  void setActiveJob(ActiveRides data, String phone) {
    var docid = data.docid;

    final jobd = <String, String>{"docid": docid};

    FirebaseFirestore.instance
        .collection("drivers_active")
        .doc(phone)
        .set(jobd)
        .onError((e, _) => print("Error writing document: $e"));
  }

  void pickupToDestination(ActiveRides data) {}

  void showPoly(LatLng current, LatLng pickup) async {
    var directions = await DirectionsRepository()
        .getDirections(origin: current, destination: pickup);

    setState(() {
      _info = directions;
    });
  }

  void DeleteJob(String phone, BuildContext context) {
    FirebaseFirestore.instance
        .collection("drivers_active")
        .doc(phone)
        .delete()
        .onError((e, _) => print("Error writing document: $e"))
        .then((value) {
      Navigator.of(context).pop();
    });
  }

  void checkState() {


  }
}
