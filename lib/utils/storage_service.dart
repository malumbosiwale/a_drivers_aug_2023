import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as fbstpor;
import 'package:firebase_core/firebase_core.dart' as fbcore;

class Storage {
  final fbstpor.FirebaseStorage storage = fbstpor.FirebaseStorage.instance;

  Future<String?> uploadFile(
      File filePath, String fileName, String phonenumber) async {
    fbstpor.Reference ref = fbstpor.FirebaseStorage.instance
        .ref()
        .child('userfiles')
        .child("driver_"+phonenumber)
        .child(fileName);
    try {
      await ref.putFile(filePath);
      String url = await ref.getDownloadURL();
      print('Url' + url);
      return url;
    } on fbcore.FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> downloadURLExample(
      File filePath, String fileName, String phonenumber) async {
    String downloadURL = await fbstpor.FirebaseStorage.instance
        .ref('userfiles/$phonenumber/$fileName')
        .getDownloadURL();

    return downloadURL;
  }
}
