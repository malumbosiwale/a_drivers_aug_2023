import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActiveRides {
  ActiveRides({
    required this.curent_location,
    required this.date,
    required this.destination,
    required this.geohash,
    required this.destination_name,
    required this.pickup,
    required this.phone,
    required this.status,
    required this.amount,
    required this.docid,
    required this.drivername,
    required this.driverphone,
    required this.driverimage,
    required this.username,
    required this.userimage,
    required this.messagingid,
  });

  ActiveRides.fromJson(String docid, Map<String, Object?> json)
      : this(
          curent_location: json['curent_location']! as String,
          date: json['date']! as String,
          destination: json['destination']! as Map<String, dynamic>,
          geohash: json['geohash']! as Map<String, dynamic>,
          destination_name: json['destination_name']! as String,
          pickup: json['pickup']! as Map<String, dynamic>,
          phone: json['phone']! as String,
          status: json['status']! as String,
          amount: json['amount']! as double,
          docid: docid,
          drivername: json['drivername'] == null ? "" : json['drivername'].toString(),
          driverphone: json['driverphone'] == null ? "" : json['driverphone'].toString(),
          driverimage: json['driverimage'] == null ? "" : json['driverimage'].toString(),
          username: json['username'] == null ? "" : json['username'].toString(),
          userimage: json['userimage'] == null ? "" : json['userimage'].toString(),
          messagingid: json['messagingid'] == null ? "" : json['messagingid'].toString(),
        );

  final String curent_location;
  final String date;
  final Map<String, dynamic> destination;
  final Map<String, dynamic> geohash;
  final Map<String, dynamic> pickup;
  final String destination_name;
  final String phone;
  final String status;
  final double amount;
  final String docid;
  final String drivername;
  final String driverphone;
  final String driverimage;
  final String username;
  final String userimage;
  final String messagingid;

  Map<String, Object?> toJson() {
    return {
      'curent_location': curent_location,
      'date': date,
      'destination': destination,
      'geohash': geohash,
      'pickup': pickup,
      'pickup': pickup,
      'destination_name': destination_name,
      'phone': phone,
      'status': status,
      'amount': amount,
      'docid': docid,
      'drivername': drivername,
      'driverphone': driverphone,
      'driverimage': driverimage,
      'username': username,
      'userimage': userimage,
      'messagingid': messagingid,
    };
  }
}
