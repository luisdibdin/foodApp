import 'package:flutter/material.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/screens/home/Pages/profile/avatar.dart';
import 'package:food_app/services/user_controller.dart';

import '../../../../locator.dart';

class FriendRankTile extends StatelessWidget {

  final UserModel friend;
  final int tileType;
  FriendRankTile({this.friend, this.tileType});

  @override
  Widget build(BuildContext context) {
    if (tileType == 0) {
      return ListTile(
        leading: Avatar(avatarUrl: friend?.avatarUrl, radius: 25),
        title: Text(friend?.username, style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w500,
        )),
        subtitle: Text((((friend?.weekScore ?? 0)/(friend?.weekTotal ?? 1))*100).toStringAsFixed(0) + '%'),
      );
    } else {
      return ListTile(
        leading: Avatar(avatarUrl: friend?.avatarUrl, radius: 25),
        title: Text(friend?.username, style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w500,
        )),
        subtitle: Text(friend.calculateExpertiseTitle()),
      );
    }
  }
}