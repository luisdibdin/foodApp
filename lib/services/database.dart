import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/services/scan.dart';
import 'package:food_app/services/storage_repo.dart';

class DatabaseService {

  final String uid;
  final DateTime currentDate;
  DatabaseService({this.uid, this.currentDate});

  final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final DateTime weekStart = DateTime(2020, 09, 07);
  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference scanCollection = Firestore.instance.collection('scans');
  final CollectionReference scoreCollection = Firestore.instance.collection('scores');
  final CollectionReference friendCollection = Firestore.instance.collection('friends');

  Future newUserData(String uid, String username, String email) async {
    await userCollection.document(uid).setData({
      'username': username,
      'email': email,
    });
    setUserScore(uid);
    updateUserScore(uid, 0, 0);
  }

  Future<String> getUserData(String uid) async {
    DocumentSnapshot snapshot = await userCollection.document(uid).get();
    return snapshot.data['username'].toString();
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

  Future setUserScore(String uid) async {
     await scoreCollection.document(uid).setData({
      'all_time_score': 0,
      'total': 0,
    });
     scoreCollection.document(uid).collection('weekly_scores');
  }
  Future updateUserScore(String uid, int score, int total) async {
    int weeksSinceStart = (today.difference(weekStart).inDays) ~/ 7;
    int daysToNewWeek = 7 * weeksSinceStart;
    DateTime newWeekStart = weekStart.add(Duration(days: daysToNewWeek));

    DocumentSnapshot allTimeDocument = await scoreCollection.document(uid).get();
    int allTimeTotal = allTimeDocument.data['total'];
    int allTimeScore = allTimeDocument.data['all_time_score'];
    DocumentSnapshot weeklyDocument = await scoreCollection.document(uid).collection('weekly_scores')
        .document(newWeekStart.year.toString() + '-' + newWeekStart.month.toString()
        + '-' + newWeekStart.day.toString()).get();
    int weeklyTotal = 0;
    int weeklyScore = 0;
    if (weeklyDocument.exists) {
      weeklyTotal = weeklyDocument.data['total'];
      weeklyScore = weeklyDocument.data['score'];
    }

    await scoreCollection.document(uid).updateData({
      'all_time_score': allTimeScore + score,
      'total': allTimeTotal + total,
    });
    await scoreCollection.document(uid).collection('weekly_scores').document(newWeekStart.year.toString()
        + '-' + newWeekStart.month.toString() + '-' + newWeekStart.day.toString())
        .setData({
      'total': weeklyTotal + total,
      'score': weeklyScore + score,
      'date': newWeekStart,
    }, merge: true);
  }

  Future<DocumentSnapshot> getAllTimeScores(String uid) async {
    DocumentSnapshot allTimeDocument = await scoreCollection.document(uid).get();
    return allTimeDocument;
  }

  Future<DocumentSnapshot> getLatestWeek(String uid) async {
    QuerySnapshot weekQuery = await scoreCollection.document(uid).collection('weekly_scores').orderBy('date', descending: true).limit(1).getDocuments();
    if (weekQuery.documents.length > 0) {
      DocumentSnapshot latestDocument = weekQuery.documents.first;
      return latestDocument;
    } else {
      return null;
    }
  }

  Future<List<double>> getLastSixWeeks(String uid) async {
    List<double> percentageScores = [];
    QuerySnapshot weekQuery = await scoreCollection.document(uid).collection('weekly_scores').orderBy('date', descending: true).limit(6).getDocuments();
    List<DocumentSnapshot> lastSixDocuments = weekQuery.documents.toList();
    for (DocumentSnapshot doc in lastSixDocuments) {
      int total;
      int score;
      if (doc.exists == true) {
        if (doc.data['total'] == 0) {
          total = 1;
          score = 0;
          percentageScores.add((score / total) * 100);
        } else {
          total = doc.data['total'];
          score = doc.data['score'];
          percentageScores.add((score / total) * 100);
        }
      }
    }
      if (percentageScores.length < 6) {
        for (int i = percentageScores.length; i != 6; i++) {
          percentageScores.add(0);
        }
      }
    return percentageScores;
  }

  Future<void> addFriend(String uid, String friendUid, String username) async {
    await friendCollection.document(uid).collection('sentRequests').document(friendUid).setData({
      'date': DateTime.now(),
    });
    await friendCollection.document(friendUid).collection('receivedRequests').document(uid).setData({
      'date': DateTime.now(),
      'username': username ?? 'user',
      'downloadUrl': await StorageRepo().getImageUrlFromStorage(uid),
    });
  }

  Future<void> acceptFriendRequest(String uid, String username, String avatarUrl, UserModel friendUid) async {
    await friendCollection.document(uid).collection('receivedRequests').document(friendUid.uid).delete();
    await friendCollection.document(friendUid.uid).collection('sentRequests').document(uid).delete();

    await friendCollection.document(uid).collection('friends').document(friendUid.uid).setData({
      'date': DateTime.now(),
      'username': friendUid.username,
      'downloadUrl': friendUid.avatarUrl,
    });
    await friendCollection.document(friendUid.uid).collection('friends').document(uid).setData({
      'date': DateTime.now(),
      'username': username,
      'downloadUrl': avatarUrl,
    });
  }

  Future<void> deleteFriend(String uid, String friendUid) async {
    await friendCollection.document(uid).collection('friends').document(friendUid).delete();
    await friendCollection.document(friendUid).collection('friends').document(uid).delete();
  }

  Future<void> deleteFriendRequest(String uid, String friendUid) async {
    await friendCollection.document(uid).collection('receivedRequests').document(friendUid).delete();
    await friendCollection.document(friendUid).collection('sentRequests').document(uid).delete();
  }

  Stream<List<UserModel>> get friendRequests{
    return friendCollection.document(uid).collection('receivedRequests').snapshots()
        .map(_friendsFromSnapshot);
  }

  List<UserModel> _friendsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return UserModel(
        uid: doc.documentID,
        username: doc.data['username'],
        avatarUrl: doc.data['downloadUrl'],
      );
    }).toList();
  }

  Stream<List<UserModel>> get friends{
    return friendCollection.document(uid).collection('friends').snapshots()
        .map(_friendsFromSnapshot);
  }
}