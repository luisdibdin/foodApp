import 'package:flutter/material.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/screens/home/Pages/profile/avatar.dart';
import 'package:food_app/services/user_controller.dart';

import '../../../../locator.dart';

class FriendTile extends StatelessWidget {

  final UserModel friend;
  final int tileType;
  FriendTile({this.friend, this.tileType});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Avatar(avatarUrl: friend?.avatarUrl, radius: 25),
      title: Text(friend?.username, style: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w500,
      )),
      children: <Widget>[
        if (tileType == 1)
          FlatButton(
            child: Text('Accept Request'),
            onPressed: () async {
              await locator.get<UserController>().acceptFriendRequest(friend);
            },
          ),
        if (tileType == 1)
          FlatButton(
            child: Text('Delete Request'),
            onPressed: () async {
              await locator.get<UserController>().deleteFriendRequest(friend.uid);
            },
          ),
        if (tileType == 0)
          FlatButton(
            child: Text('Delete Friend'),
            onPressed: () async {
              await locator.get<UserController>().deleteFriend(friend.uid);
            },
          ),
      ],
    );
  }
}
