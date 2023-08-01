import 'package:a_drivers/components/rounded_button.dart';
import 'package:a_drivers/screens/AcceptAndNavigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../components/homecard.dart';
import '../constatnts.dart';
import '../utils/activeRides.dart';
import 'AcceptAndNavigationFromJobs.dart';
import 'DriverHome.dart';

class SelectJobs extends StatefulWidget {
  var phone;

  SelectJobs({Key? key, required this.phone}) : super(key: key);

  @override
  State<SelectJobs> createState() => _SelectJobsState();
}

class _SelectJobsState extends State<SelectJobs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getJobs(widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    // final usersQuery = FirebaseFirestore.instance
    //     .collection('jobscreen')
    //     .doc(widget.phone)
    //     .collection("myjobs")
    //     .orderBy('timestamp', descending: true)
    //     .withConverter<JobList>(
    //       fromFirestore: (snapshot, _) =>
    //           JobList.fromJson(snapshot.id, snapshot.data()!),
    //       toFirestore: (user, _) => user.toJson(),
    //     );

    final usersQuery = FirebaseFirestore.instance
        .collection('active_rides')
        .where("status", isEqualTo: "status")
        .orderBy('date', descending: true)
        .withConverter<ActiveRides>(
          fromFirestore: (snapshot, _) =>
              ActiveRides.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
    var www = MediaQuery.of(context).size.width;
    timeago.setLocaleMessages('en', timeago.EnMessages());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("View requests"),
      ),
      body: FirestoreListView<ActiveRides>(
        query: usersQuery,
        itemBuilder: (context, snapshot) {
          // Data is now typed!
          ActiveRides user = snapshot.data();
          var locale = 'en';

          final currentTime = new DateTime.now();

          print(user.amount.toString());
          final fifteenAgo = currentTime
              .subtract(Duration(microseconds: int.parse(user.date)));
          var dateTime =
              DateTime.fromMillisecondsSinceEpoch(int.parse(user.date));
          var timeAgo = timeago.format(dateTime);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              // THIS NOT APPLYING !!!
              elevation: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 0.0),
                        child: cardTextHeader(
                            text: "You earn ZMW " + user.amount.toString()),
                      ),
                      subtitle: Column(
                        children: [
                          customText(
                              s: 'Current Location: ' +
                                  user.curent_location.toString(),
                              size: 16),
                          SizedBox(
                            height: 16,
                          ),
                          customText(
                            s: 'Destination: ' +
                                user.destination_name.toString(),
                            size: 16,
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 1,
                            child: Container(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 16),
                          customText(
                            s: timeAgo,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                          child: RoundedButton(
                              text: "Cancel",
                              press: () {
                                deleteActiveJob(user.docid, widget.phone);
                              },
                              color: primaryColor,
                              textcolor: whitebg,
                              widthbtn: 0.85,
                              padding_vertical: 16.0,
                              padding_horizontal: 8.0,
                              br: 16),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                          child: RoundedButton(
                              text: "Accept",
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AcceptAndNavigateFromJobs(
                                          data: user, phone: widget.phone)),
                                );
                              },
                              color: primaryGreen,
                              textcolor: whitebg,
                              widthbtn: 0.85,
                              padding_vertical: 16.0,
                              padding_horizontal: 8.0,
                              br: 16),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void deleteActiveJob(String docid, String phone) {
    FirebaseFirestore.instance
        .collection("jobscreen")
        .doc(phone)
        .collection("myjobs")
        .doc(docid)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }
}
