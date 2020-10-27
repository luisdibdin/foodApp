import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/locator.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/screens/home/Pages/leaderboards/friend_rank_tile.dart';
import 'package:food_app/services/database.dart';
import 'package:food_app/services/user_controller.dart';
import 'package:provider/provider.dart';

class FriendLeaderBoard extends StatelessWidget {

  final int tileType;
  FriendLeaderBoard({this.tileType});

  final DatabaseService _databaseService = DatabaseService();
  UserModel _currentUser = locator.get<UserController>().currentUser;

  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<UserModel>>(context);
      friends.forEach((friend) async {
        DocumentSnapshot allTimeScore = await _databaseService.getAllTimeScores(
            friend.uid);
        DocumentSnapshot weeklyScore = await _databaseService.getLatestWeek(
            friend.uid);
        friend.score = allTimeScore.data['all_time_score'];
        friend.totalQuestions = allTimeScore.data['total'];
        friend.weekScore = weeklyScore.data['score'];
        friend.weekTotal = weeklyScore.data['total'];
      });
    List<UserModel> sortUsersWeekly(List<UserModel> friends) {
      friends.sort((a, b) =>
          ((a.weekScore ?? 0) / (a.weekTotal ?? 1)).compareTo((b.weekScore ?? 0)/ (b.weekTotal ?? 1)));
      List<UserModel> weeklySorted = friends;
      return weeklySorted;
    }

    List<UserModel> sortUsersAllTime(List<UserModel> friends) {
      friends.sort((a, b) =>
          ((a.score ?? 0)/ (a.totalQuestions ?? 1)).compareTo((b.score ?? 0)/ (b.totalQuestions ?? 1)));
      List<UserModel> allTimeSorted = friends;
      return allTimeSorted;
    }

    List<UserModel> weeklySortedFriends = sortUsersWeekly(friends);
    List<UserModel> allTimeSorted = sortUsersAllTime(friends);

    if (tileType == 0) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: friends.length + 1,
          itemBuilder: (context, index) {
            if (index < friends.length) {
              return FriendRankTile(friend: weeklySortedFriends[index], tileType: tileType);
            } else {
              return FriendRankTile(friend: _currentUser, tileType: tileType);
            }
          });
    } else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: friends.length + 1,
          itemBuilder: (context, index) {
            if (friends.length == 0) {
              return SizedBox(height: 5);
            }
            if (index < friends.length) {
              return FriendRankTile(friend: allTimeSorted[index], tileType: tileType);
            } else {
              return FriendRankTile(friend: _currentUser, tileType: tileType);
            }
          });
    }
  }
}