import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {

  String email = '';
  final _emailKey = GlobalKey<FormFieldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          showBackButton(),
          showTitle(),
          showInfoText(),
          showUsernameBox(),
          showSendButton(),
        ],
      ),
    );
  }

  Widget showBackButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
      ),
    );
  }

  Widget showTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Center(
            child: Text(
              'Reset Password',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Open Sans',
                  fontSize: 25),
            )
        )
    );
  }

  Widget showInfoText() {
    return Padding(
        padding: EdgeInsets.fromLTRB(70.0, 5.0, 70.0, 0.0),
        child: Center(
            child: Text(
              'Enter your email address and we\'ll send you a link to get back into your account.',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Open Sans',
                  fontSize: 15),
              textAlign: TextAlign.center,
            )
        )
    );
  }

  Widget showUsernameBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        key: _emailKey,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
            fillColor: Colors.black12.withOpacity(0.07),
            filled: true,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: new Icon(Icons.email),
            hintText: 'Email',
          ),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onChanged: (value) {
            setState(() => email = value);
          }
      ),
    );
  }

  Widget showSendButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          color: Colors.green,
          child: new Text('Send',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () async {
            if (_emailKey.currentState.validate()){
              _auth.sendPasswordResetEmail(email: email);
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
