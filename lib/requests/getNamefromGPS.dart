import 'package:a_drivers/constatnts.dart';
import 'package:http/http.dart' as http;
Future<http.Response> getNamefromGps(double lat, double lon) async {
  http.Response response;
  // print("placeid: " + place_id);
  // var url = "https://maps.googleapis.com/maps/api/geocode/json?place_id=$place_id&key=$apikey";
  var url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$apikey";
  response = await http.get(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},);

  // print(jsonDecode(response.body));
  return response;
}