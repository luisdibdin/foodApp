import 'package:flutter/material.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/screens/home/Pages/profile/friends_tile.dart';
import 'package:provider/provider.dart';

class FriendList extends StatelessWidget {

  final int tileType;
  FriendList({this.tileType});

  @override
  Widget build(BuildContext context) {

    final friends = Provider.of<List<UserModel>>(context);

    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: friends.length + 1,
        itemBuilder: (context, index) {
          if (index < friends.length) {
            return FriendTile(friend: friends[index], tileType: tileType);
          } else {
            return SizedBox(height: 5.0);
          }
        });
  }
}
