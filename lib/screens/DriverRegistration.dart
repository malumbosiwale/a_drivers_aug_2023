import 'dart:io';

import 'package:a_drivers/utils/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/storage_service.dart';
import '../components/imageHolder.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';
import '../constatnts.dart';

class RegisterDriver extends StatefulWidget {
  final String registration_type;

  const RegisterDriver({Key? key, required this.registration_type})
      : super(key: key);

  @override
  State<RegisterDriver> createState() => _RegisterDriverState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _RegisterDriverState extends State<RegisterDriver> {
  File? fileimage1;
  File? fileimage2;
  File? fileimage3;
  File? fileimage4;
  File? fileimage5;
  File? fileimage6;
  File? fileimage7;

  bool uploading = false;

  String image_name1 = "drivers_licence_front";
  String image_name2 = "drivers_licence_back";
  String image_name3 = "vehicle_front";
  String image_name4 = "vehicle_back";
  String image_name5 = "photo_person";
  String image_name6 = "photo_person_card";
  String image_name7 = "vehicle_side";

  // String? phone_number;

  TextEditingController controller_fullname = TextEditingController();
  TextEditingController controller_id_number = TextEditingController();
  TextEditingController controller_numberplate = TextEditingController();
  TextEditingController controller_email = TextEditingController();
  TextEditingController controller_phone_number = TextEditingController();

  bool ischecked = false;
  final Storage storageme = Storage();

  Future pickImage(int pos) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      File file = (await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3))) as File;
      if (file == null) return;

      file = await compressImage(file.path, 80);

      final imaeTemp = file;

      setState(() {
        if (pos == 1) {
          this.fileimage1 = imaeTemp;
        } else if (pos == 2) {
          this.fileimage2 = imaeTemp;
        } else if (pos == 3) {
          this.fileimage3 = imaeTemp;
        } else if (pos == 4) {
          this.fileimage4 = imaeTemp;
        } else if (pos == 5) {
          this.fileimage5 = imaeTemp;
        } else if (pos == 6) {
          this.fileimage6 = imaeTemp;
        } else if (pos == 7) {
          this.fileimage7 = imaeTemp;
        }
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to pick image $e!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      newPath,
      minWidth: 800,
      minHeight: 800,
      quality: quality,
    );

    return result!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPref();
  }


  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }


  @override
  Widget build(BuildContext context) {
    String? selectedValue = widget.registration_type;

    return Scaffold(
      drawerScrimColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Driver Registration"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          ImageHolder(
            label: "Drivers Licence - Front",
            childe: fileimage1 != null
                ? Image.file(fileimage1!, fit: BoxFit.cover)
                : Image.asset(
              "assets/images/placeholder_image.png",
              fit: BoxFit.cover,
            ),
            onPress: () {
              pickImage(1);
            },
          ),
          ImageHolder(
            label: "Drivers Licence - Back",
            childe: fileimage2 != null
                ? Image.file(fileimage2!, fit: BoxFit.cover)
                : Image.asset(
              "assets/images/placeholder_image.png",
              fit: BoxFit.cover,
            ),
            onPress: () {
              pickImage(2);
            },
          ),
          ImageHolder(
            label: "Vehicle - Front",
            childe: fileimage3 != null
                ? Image.file(fileimage3!, fit: BoxFit.cover)
                : Image.asset(
              "assets/images/placeholder_image.png",
              fit: BoxFit.cover,
            ),
            onPress: () {
              pickImage(3);
            },
          ),
          ImageHolder(
            label: "Vehicle - Side",
            childe: fileimage7 != null
                ? Image.file(fileimage7!, fit: BoxFit.cover)
                : Image.asset(
              "assets/images/placeholder_image.png",
              fit: BoxFit.cover,
            ),
            onPress: () {
              pickImage(7);
            },
          ),
          ImageHolder(
            label: "Vehicle - Back",
            childe: fileimage4 != null
                ? Image.file(fileimage4!, fit: BoxFit.cover)
                : Image.asset(
              "assets/images/placeholder_image.png",
              fit: BoxFit.cover,
            ),
            onPress: () {
              pickImage(4);
            },
          ),
          ImageHolder(
            label: "Picture of your face",
            childe: fileimage5 != null
                ? Image.file(fileimage5!, fit: BoxFit.cover)
                : Image.asset(
              "assets/images/placeholder_image.png",
              fit: BoxFit.cover,
            ),
            onPress: () {
              pickImage(5);
            },
          ),
          ImageHolder(
            label: "Picture of card holder holding a card",
            childe: fileimage6 != null
                ? Image.file(fileimage6!, fit: BoxFit.cover)
                : Image.asset(
              "assets/images/placeholder_image.png",
              fit: BoxFit.cover,
            ),
            onPress: () {
              pickImage(6);
            },
          ),
          Align(
            alignment: Alignment.topLeft,
            child: CheckboxListTile(
                title: const Text(
                  "Tinted Windows",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "NimbusSanL",
                  ),
                ),
                checkColor: Colors.white,
                activeColor: primaryColor,
                value: ischecked,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    ischecked = !ischecked;
                  });
                }),
          ),
          RoundedInputField(
              hintText: "Full Name",
              onchanged: (value) {},
              icon: Icons.person,
              inputType: TextInputType.name,
              width: 0.9,
              maxLength: 30,
              ccontroller: controller_fullname),
          RoundedInputField(
              hintText: "Phone Number",
              icon: Icons.phone,
              width: 0.9,
              maxLength: 10,
              inputType: TextInputType.name,
              onchanged: (value) {},
              ccontroller: controller_phone_number),
          RoundedInputField(
              hintText: "ID Number",
              icon: Icons.verified_user,
              width: 0.9,
              maxLength: 30,
              inputType: TextInputType.name,
              onchanged: (value) {},
              ccontroller: controller_id_number),
          RoundedInputField(
              hintText: "Number Plate",
              width: 0.9,
              maxLength: 30,
              icon: Icons.confirmation_number,
              onchanged: (value) {},
              inputType: TextInputType.name,
              ccontroller: controller_numberplate),
          RoundedInputField(
              hintText: "Email Address",
              width: 0.9,
              maxLength: 30,
              icon: Icons.email_outlined,
              onchanged: (value) {},
              inputType: TextInputType.emailAddress,
              ccontroller: controller_email),
          uploading == false
              ? RoundedButton(
              text: "Submit",
              press: () {
                if (fileimage1 == null) {
                  Fluttertoast.showToast(
                      msg: "Divers licence front image required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }

                if (fileimage2 == null) {
                  Fluttertoast.showToast(
                      msg: "Divers licence back image required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }

                if (fileimage3 == null) {
                  Fluttertoast.showToast(
                      msg: "Vehicle front image required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }

                if (fileimage7 == null) {
                  Fluttertoast.showToast(
                      msg: "Vehicle side image required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                if (fileimage4 == null) {
                  Fluttertoast.showToast(
                      msg: "Vehicle back image required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                if (fileimage5 == null) {
                  Fluttertoast.showToast(
                      msg: "Picture of your face required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                if (fileimage6 == null) {
                  Fluttertoast.showToast(
                      msg: "Picture of your face required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                if (controller_fullname.text.length < 1) {
                  Fluttertoast.showToast(
                      msg: "Full name required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                if (controller_id_number.text.length < 1) {
                  Fluttertoast.showToast(
                      msg: "NRC number required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }

                if (controller_email.text.length < 1) {
                  Fluttertoast.showToast(
                      msg: "Email address required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }

                if (controller_phone_number.text.length !=
                    ZambianPhoneLength ||
                    controller_phone_number.text.length < 1) {
                  Fluttertoast.showToast(
                      msg: "Invalid Phone Number!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                if (controller_numberplate.text.length < 1) {
                  Fluttertoast.showToast(
                      msg: "Numberplate required",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }

                if (selectedValue == "") {
                  Fluttertoast.showToast(
                      msg: "Registration Category Required",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                String business_numberplate = controller_numberplate.text;
                String business_fullname = controller_fullname.text;
                String business_id_number = controller_id_number.text;
                String business_email = controller_email.text;
                String phone_number = controller_phone_number.text;

                var docRef = FirebaseFirestore.instance
                    .collection("drivers")
                    .doc(phone_number);
                docRef.get().then((DocumentSnapshot doc) {
                  setState(() {
                    uploading = true;
                  });

                  if (doc.exists) {
                    setState(() {
                      uploading = false;
                    });

                    toastDataError(
                        "Your account has already been registered ");
                  } else {
                    // toastData("Account clean");
                    storageme
                        .uploadFile(fileimage1!, image_name1, phone_number)
                        .then((value_image_1) =>
                        storageme
                            .uploadFile(
                            fileimage2!, image_name2, phone_number)
                            .then((value_image_2) =>
                        (storageme
                            .uploadFile(
                            fileimage3!, image_name3, phone_number)
                            .then((value_image_3) =>
                        (storageme
                            .uploadFile(
                            fileimage4!, image_name4, phone_number)
                            .then((value_image_4) =>
                        (storageme
                            .uploadFile(
                            fileimage5!, image_name5, phone_number)
                            .then((value_image_5) =>
                        (storageme
                            .uploadFile(fileimage6!, image_name6, phone_number)
                            .then((value_image_6) =>
                        (storageme.uploadFile(
                            fileimage7!, image_name7, phone_number).then(
                              (value_image_7) =>
                          (uploadData(
                              value_image_1,
                              value_image_2,
                              value_image_3,
                              value_image_4,
                              value_image_5,
                              value_image_6,
                              value_image_7,

                              business_numberplate,
                              business_fullname,
                              business_id_number,
                              ischecked,
                              phone_number,
                              business_email)),
                        ))))))))))));
                  }
                }, onError: (e) {
                  // toastData("No document");
                });
              },
              color: primaryDarkColor,
              textcolor: Colors.white,
              widthbtn: 0.9,
              padding_vertical: 20,
              padding_horizontal: 20,
              br: 30)
              : Container(
              margin: const EdgeInsets.all(20),
              child: const CircularProgressIndicator.adaptive(
                  backgroundColor: primaryColor,
                  valueColor: AlwaysStoppedAnimation(primaryDarkColor)))
        ]),
      ),
    );
  }

  // String image_name1 = "drivers_licence_front";
  // String image_name2 = "drivers_licence_back";
  // String image_name3 = "vehicle_front";
  // String image_name4 = "vehicle_back";
  // String image_name5 = "photo_person";
  // String image_name6 = "photo_person_card";
  // String image_name7 = "vehicle_side";

  void uploadData(String? drivers_licence_front,
      String? drivers_licence_back,
      String? vehicle_front,
      String? vehicle_back,
      String? photo_person,
      String? photo_person_card,
      String? vehicle_side,

      String? business_numberplate,
      String? business_fullname,
      String? business_id_number,
      bool? tinded_windows,
      String? phone_number,
      String? business_email) {
    Future<void> addUser() async {
      // Call the user's CollectionReference to add a new user

      DocumentReference useracount =
      FirebaseFirestore.instance.collection('drivers').doc(phone_number!);
      return useracount.set({
        'drivers_licence_front': drivers_licence_front, // John Doe
        'drivers_licence_back': drivers_licence_back, // Stokes and Sons
        'vehicle_front': vehicle_front, // Stokes and Sons
        'vehicle_side': vehicle_side, // Stokes and Sons
        'vehicle_back': vehicle_back, // Stokes and Sons
        'photo_person': photo_person, // Stokes and Sons
        'photo_person_card': photo_person_card, // Stokes and Sons
        'business_numberplate': business_numberplate, // Stokes and Sons
        'fullname': business_fullname, // 42
        'business_id_number': business_id_number, // 42
        'phone_number': phone_number, // 42
        'validation status': "submitted", // 42
        'tinded_windows': tinded_windows, // 42
        'email': business_email, // 42
      }).then((value) async {
        // print("User Added");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("validation status", "submitted").then((value) {
          String message =
              "Thank you for registering to be a driver under Atwende, "
              "you will receive an email once your account has been approved.";
          String subject = "Thank you for registering with us.";
          sendEmail(message, business_email!, subject, business_fullname!);

          Fluttertoast.showToast(
              msg:
              "Submission successful, please check your email for a response!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context, true);
        });
      }).catchError((error) {
        print("Failed to add user: $error");
        setState(() {
          uploading = false;
        });
      });
    }

    addUser();
  }

  void getSharedPref() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // phone_number = localStorage.getString('phone');
  }
}
