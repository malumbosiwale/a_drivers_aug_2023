import 'package:google_maps_flutter/google_maps_flutter.dart';

class JobList {
  JobList({
    required this.curent_location,
    required this.amount,
    required this.destination_name,
    required this.phone,
    required this.pickup,
    required this.timestamp,
    required this.docid,
  });

  JobList.fromJson(String docid, Map<String, Object?> json)
      : this(
          amount: json['amount']! as double,
          curent_location: json['curent_location']! as String,
          destination_name: json['destination_name']! as String,
          phone: json['phone']! as String,
          pickup: json['pickup']! as Map<String, dynamic>,
          timestamp: json['timestamp']! as String,
          docid: docid,
        );

  final String curent_location;
  final String destination_name;
  final String phone;
  final double amount;
  final Map<String, dynamic> pickup;
  final String timestamp;
  final String docid;

  Map<String, Object?> toJson() {
    return {
      'amount': amount,
      'curent_location': curent_location,
      'destination_name': destination_name,
      'phone': phone,
      'curent_location': curent_location,
      'pickup': pickup,
      'timestamp': timestamp,
      'docid': docid,
    };
  }
}
