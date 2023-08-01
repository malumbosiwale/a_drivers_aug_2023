import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyPolyline {
  final String polylineId;
  final List<LatLng> points;
  final Color color;

  MyPolyline({
    required this.polylineId,
    required this.points,
    this.color = Colors.blue,
  });
}
