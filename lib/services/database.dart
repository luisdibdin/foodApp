import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future newUserData(String username, String email, String gender) async {
    return await userCollection.document(uid).setData({
      'username': username,
      'email': email,
      'gender': gender,
    });
  }

}