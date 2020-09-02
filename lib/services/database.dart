import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/services/scan.dart';

class DatabaseService {

  final String uid;
  final DateTime currentDate;
  DatabaseService({this.uid, this.currentDate});

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

  Future newScanData(String name, double calories, double carbs, double fat, double protein, double grams) async {
    return await scanCollection.document(uid).collection('scans').document(DateTime.now().millisecondsSinceEpoch.toString()).setData({
      'food_name': name,
      'calories': calories,
      'carbohydrates': carbs,
      'fat': fat,
      'protein': protein,
      'date_time': DateTime.now(),
      'amount_had': grams,
    });
  }

  Future updateScanData(String productID, double calories, double carbs, double fat, double protein) async {
    return await scanCollection.document(uid).collection('scans').document(productID).updateData({
      'calories': calories,
      'carbohydrates': carbs,
      'fat': fat,
      'protein': protein,
    });
  }

  Future<void> deleteScan(String productID) async {
    await scanCollection.document(uid).collection('scans').document(productID).delete();
  }

  List<Scan> _scanListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Scan(
        productID: doc.documentID,
        productName: doc.data['food_name'] ?? '',
        productCalories: doc.data['calories'] ?? 0,
        productCarbs: doc.data['carbohydrates'] ?? 0,
        productFat: doc.data['fat'] ?? 0,
        productProtein: doc.data['protein'] ?? 0,
        dateTime: doc.data['date_time'] ?? null,
        grams: doc.data['amount_had'] ?? 0,
      );
    }).toList();
  }

  Stream<List<Scan>> get scans {
    return scanCollection.document(uid).collection('scans').snapshots()
    .map(_scanListFromSnapshot);
  }

}