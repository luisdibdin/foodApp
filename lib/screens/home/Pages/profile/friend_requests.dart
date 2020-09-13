import 'package:flutter/material.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/screens/home/Pages/profile/friends_list.dart';
import 'package:food_app/services/database.dart';
import 'package:provider/provider.dart';

class FriendRequests extends StatefulWidget {
  @override
  _FriendRequestsState createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
          backArrow(),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 5.0, 0.0, 0.0),
            child: Text('friends requests:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
          ),
          StreamProvider<List<UserModel>>.value(
            initialData: List(),
            value: DatabaseService(uid: user.uid).friendRequests,
            child: Expanded(
              child: ListView(
                children: <Widget>[
                  FriendList(tileType: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget backArrow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 15,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
