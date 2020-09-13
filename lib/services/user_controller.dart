import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/locator.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/services/auth.dart';
import 'package:food_app/services/database.dart';
import 'package:food_app/services/storage_repo.dart';

class UserController {
  UserModel _currentUser;
  AuthService _authService = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  DatabaseService _databaseService = locator.get<DatabaseService>();
  Future init;

  UserController() {
    init = initUser();
  }

  Future<UserModel> initUser() async {
    _currentUser = await _authService.getUser();
    return _currentUser;
  }

  UserModel get currentUser => _currentUser;

  Future<void> uploadProfilePicture(File image) async {
    _currentUser.avatarUrl = await _storageRepo.uploadFile(image);
  }

  Future<String> getDownloadUrl() async {
    return await _storageRepo.getImageUrlFromStorage(currentUser.uid);
  }

  Future<String> getUsername() async {
    return await _databaseService.getUserData(currentUser.uid);
  }

  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    _currentUser = await _authService.signInWithEmailAndPassword(email, password);
    return _currentUser;
  }

  Future<UserModel> registerWithEmailAndPassword(String email, String password, String username) async {
    _currentUser = await _authService.registerWithEmailAndPassword(email, password);
    await _databaseService.newUserData(currentUser.uid, username, email);
    return _currentUser;
  }

  Future<void> setCurrentUserUsername() async {
    _currentUser.username = await getUsername();
  }

  Future<void> setCurrentUserAvatarUrl() async {
    _currentUser.avatarUrl = await getDownloadUrl();
  }

  void setUserData() {
    setCurrentUserUsername();
    setCurrentUserAvatarUrl();
    setAllTimeUserScores();
    setLatestWeek();
  }

  Future<void> updateUserScore(int score, int total) async {
    _databaseService.updateUserScore(currentUser.uid, score, total);
  }

  Future<void> setAllTimeUserScores() async {
    DocumentSnapshot scores = await _databaseService.getAllTimeScores(currentUser.uid);
    _currentUser.totalQuestions = scores.data['total'];
    _currentUser.score = scores.data['all_time_score'];
  }

  Future<List<double>> getLastSixUserScores() async {
    List<double> percentageScores = await _databaseService.getLastSixWeeks(currentUser.uid);
    return percentageScores;
  }

  Future<void> setLatestWeek() async {
    DocumentSnapshot latestWeek = await _databaseService.getLatestWeek(currentUser.uid);
    if (latestWeek == null) {
      _currentUser.weekTotal = 0;
      _currentUser.weekScore = 0;
    } else {
      _currentUser.weekScore = latestWeek.data['score'] ?? 0;
      _currentUser.weekTotal = latestWeek.data['total'] ?? 0;
    }
  }

  Future<void> addFriend(String friendUid) async {
    _databaseService.addFriend(currentUser.uid, friendUid, currentUser.username);
  }

  Future<void> deleteFriendRequest(String friendUid) async {
    _databaseService.deleteFriendRequest(currentUser.uid, friendUid);
  }

  Future<void> acceptFriendRequest(UserModel friendUid) async {
    _databaseService.acceptFriendRequest(currentUser.uid, currentUser.username, currentUser.avatarUrl, friendUid);
  }

  Future<void> deleteFriend(String friendUid) async {
    _databaseService.deleteFriend(currentUser.uid, friendUid);
  }
}