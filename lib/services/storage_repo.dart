import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_app/locator.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/services/auth.dart';

class StorageRepo {
  FirebaseStorage storage = FirebaseStorage(
    storageBucket: 'gs://health-app-6098c.appspot.com/'
  );

  AuthService _auth = locator.get<AuthService>();

  Future<String> uploadFile(File image) async {
    UserModel user = await _auth.getUser();
    String userId = user.uid;

    StorageReference storageRef = storage.ref().child(userId);
    StorageUploadTask uploadTask = storageRef.putFile(image);
    StorageTaskSnapshot completedTask = await uploadTask.onComplete;
    String downloadUrl = await completedTask.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> getImageUrlFromStorage(String uid) async {
    try {
      StorageReference storageRef = storage.ref().child(uid);
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}