import 'package:a_drivers/constatnts.dart';
import 'package:http/http.dart' as http;
Future<http.Response> getGPSfromPlaceID(String place_id) async {
  http.Response response;
  // print("placeid: " + place_id);
  var url = "https://maps.googleapis.com/maps/api/geocode/json?place_id=$place_id&key=$apikey";
  https://maps.googleapis.com/maps/api/geocode/json?place_id=ChIJg38mvtiNQBkROK7XRTDRw0k&key=AIzaSyAuG_xTYm7ZC2O6wyRwEjMdtciaocYK9QM
  response = await http.get(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},);

  // print(jsonDecode(response.body));
  return response;
}