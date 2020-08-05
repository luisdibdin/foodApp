import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  final CollectionReference scanCollection = Firestore.instance.collection('scans');

  Future newUserData(String username, String email, String gender) async {
    return await userCollection.document(uid).setData({
      'username': username,
      'email': email,
      'gender': gender,
    });
  }

  Future newScanData(String name, double calories, double carbs, double fat, double protein) async {
    return await scanCollection.document(uid).collection('scans').document(DateTime.now().millisecondsSinceEpoch.toString()).setData({
      'food_name': name,
      'calories': calories,
      'carbohydrates': carbs,
      'fat': fat,
      'protein': protein,
    });
  }

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

}