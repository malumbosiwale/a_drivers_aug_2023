import 'dart:convert';

import 'package:a_drivers/requests/getGpsfromPlaceID.dart';
import 'package:a_drivers/requests/getNamefromGPS.dart';
import 'package:a_drivers/requests/location_service.dart';
import 'package:a_drivers/requests/parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import 'package:http/http.dart' as http;

class LocationController extends GetxController {
  Placemark _placemark = Placemark();

  Placemark get pickPlaceMark => pickPlaceMark;

  List<Prediction> _predictionList = [];

  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    if (text != null && text.isNotEmpty) {
      http.Response response = await getLocationData(text);
      var data = jsonDecode(response.body.toString());
      // print("my status is " + data["status"]);
      _predictionList = [];

      data["predictions"].forEach(
          (prediction) => _predictionList.add(Prediction.fromJson(prediction)));
    } else {}
    return _predictionList;
  }

  Future<LatLng> getPlaceIdgps(BuildContext context, String place_id) async {
    if (place_id != null && place_id.isNotEmpty) {
      http.Response response = await getGPSfromPlaceID(place_id);
      var data = jsonDecode(response.body.toString());
      // print("my status is " + data["status"]);
      var lat = data["results"][0]["geometry"]["location"]["lat"];
      var lng = data["results"][0]["geometry"]["location"]["lng"];
      LatLng ll = LatLng(lat, lng);

      return ll;
    } else {
      return LatLng(0, 0);
    }
  }

  Future<String> getLocationNameFromGps(BuildContext context, double latt, double lng) async {
    if (latt != null && lng != null) {
      http.Response response = await getNamefromGps(latt, lng);
      var data = jsonDecode(response.body.toString());
      // print("my status is " + data["status"]);
      return data["plus_code"]["compound_code"].toString();
    } else {
      return "";
    }
  }
}
