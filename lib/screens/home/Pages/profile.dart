import 'package:flutter/material.dart';
import 'package:food_app/services/auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          showSignOutButton(),
        ],
      );
  }

  Widget showSignOutButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          color: Colors.green,
          child: new Text('Sign Out',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () async {
            await _auth.signOut();
          },
        ),
      ),
    );
  }
}
