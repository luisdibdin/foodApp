import 'package:flutter/material.dart';
import 'package:food_app/locator.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/screens/home/Pages/profile/friend_requests.dart';
import 'package:food_app/screens/home/Pages/profile/friends_list.dart';
import 'package:food_app/services/database.dart';
import 'package:food_app/services/user_controller.dart';
import 'package:provider/provider.dart';

class FriendView extends StatefulWidget {
  @override
  _FriendViewState createState() => _FriendViewState();
}

class _FriendViewState extends State<FriendView> {

  String friendId = '';

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          backArrow(),
          Center(
            child: Column(
              children: <Widget>[
                Text('Your Code:'),
                Text(user.uid),
              ],
            ),
          ),
          addFriend(),
          friendsRequestButton(),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 5.0, 0.0, 0.0),
            child: Text('friends:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
          ),
          friendList(user.uid),
        ],
      ),
    );
  }

  Widget friendsRequestButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: FlatButton(
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.people),
                  SizedBox(width: 10),
                  Text('friend requests')
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 15.0),
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendRequests()),
          );
        },
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

  Widget addFriend() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: FlatButton(
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.add),
                  SizedBox(width: 10),
                  Text('add friend')
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 15.0),
            ],
          ),
        ),
        onPressed: () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text('Enter your friends User ID:'),
              content: showUserIdInput(),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context), // passing false
                  child: Text('Cancel'),
                ),
                FlatButton(
                  child: Text('Add'),
                  onPressed: () async {
                    await locator.get<UserController>().addFriend(friendId);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
        },
      ),
    );
  }

  Widget showUserIdInput() {
      return Container(
        child: new TextFormField(
            maxLines: 1,
            autofocus: false,
            decoration: new InputDecoration(
              fillColor: Colors.black12.withOpacity(0.07),
              filled: true,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              hintText: 'User ID',
            ),
            onChanged: (value) {
              setState(() => friendId = value.trim());
            },
        ),
      );
  }

  Widget friendList(String uid) {
    return StreamProvider<List<UserModel>>.value(
      initialData: List(),
      value: DatabaseService(uid: uid).friends,
      child: Expanded(
        child: ListView(
          children: <Widget>[
            FriendList(tileType: 0),
          ],
        ),
      ),
    );
  }

}
