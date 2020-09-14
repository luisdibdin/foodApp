import 'package:flutter/material.dart';
import 'package:food_app/locator.dart';
import 'package:food_app/services/auth.dart';
import 'package:food_app/services/database.dart';
import 'package:food_app/services/user_controller.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  String username = '';
  String email = '';
  String password = '';
  String passwordConfirmed = '';

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            _showForm(),
          ],
        ));
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showTitle(),
              showUsernameInput(),
              showEmailInput(),
              showPasswordInput(),
              showPasswordConfirmedInput(),
              showSignUpButton(),
              showSignInButton(),
            ],
          ),
        ));
  }

  Widget showTitle() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: Center(
            child: Text(
              'Register',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Open Sans',
                  fontSize: 40),
            )
        )
    );
  }

  Widget showUsernameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
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
            prefixIcon: new Icon(Icons.person),
            hintText: 'Username',
          ),
          validator: (value) => value.isEmpty ? 'Username can\'t be empty' : null,
          onChanged: (value) {
            setState(() => username = value.trim());
          }
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
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
            setState(() => email = value.trim());
          }
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
          key: _passKey,
          maxLines: 1,
          obscureText: !_showPassword,
          autofocus: false,
          decoration: new InputDecoration(
            fillColor: Colors.black12.withOpacity(0.07),
            filled: true,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: new Icon(Icons.lock),
            hintText: 'Password',
          ),
          validator: (value) => value.length < 6 ? 'Password must be 6+ characters long' : null,
          onChanged: (value) {
            setState(() => password = value.trim());
          }
      ),
    );
  }

  Widget showPasswordConfirmedInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
          maxLines: 1,
          obscureText: !_showPassword,
          autofocus: false,
          decoration: new InputDecoration(
            fillColor: Colors.black12.withOpacity(0.07),
            filled: true,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: new Icon(Icons.lock),
            hintText: 'Comfirm Password',
          ),
          validator: (value) => value != _passKey.currentState.value ? 'Passwords do not match' : null,
          onChanged: (value) {
            setState(() => password = value.trim());
          }
      ),
    );
  }


  Widget showSignUpButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          color: Colors.green,
          child: new Text('Create Account',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () async {
            if (_formKey.currentState.validate() && _passKey.currentState.validate()){
              dynamic result = await locator.get<UserController>().registerWithEmailAndPassword(email, password, username);
              Navigator.pop(context);
              if (result == null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter a valid email address.'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Close'),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    }
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget showSignInButton() {
    return new FlatButton(
        child: new Text(
            'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: () {
          Navigator.pop(context);
        }
    );
  }
}


