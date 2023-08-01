import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:a_drivers/constatnts.dart';

import 'directions_model.dart';

class DirectionsRepository {
  static const String _baseurl =
      "https://maps.googleapis.com/maps/api/directions/json?";

  final Dio dio;

  DirectionsRepository({Dio? dio}) : dio = dio ?? Dio();

  Future<Directions> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await dio.get(_baseurl, queryParameters: {
      'origin': '${origin.latitude}, ${origin.longitude}',
      'destination': '${destination.latitude}, ${destination.longitude}',
      'key': apikey,
    });

    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }

    // debugPrint('mapresponse:  ${response.data}');

    return Directions.fromMap(response.data);
  }
}
