import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constatnts.dart';

Future<http.Response> getLocationData(String text) async {
  http.Response response;

  response = await http.get(
    Uri.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&language=en&key=$apikey&components=country:zm"),
    headers: {"Content-Type": "application/json"},);


  // print(jsonDecode(response.body));
  return response;
}


Future<String> getLocationData2(String text) async {
  http.Response response;

  response = await http.get(
    Uri.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&language=en&key=$apikey&components=country:zm"),
    headers: {"Content-Type": "application/json"},);

  // print(jsonDecode(response.body));
  return response.body;
}