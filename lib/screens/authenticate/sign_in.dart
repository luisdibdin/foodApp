import 'package:flutter/material.dart';
import 'package:food_app/locator.dart';
import 'package:food_app/screens/authenticate/password_reset.dart';
import 'package:food_app/screens/authenticate/register.dart';
import 'package:food_app/services/auth.dart';
import 'package:food_app/services/user_controller.dart';

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _showPassword = false;

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
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
              showLogo(),
              showTitle(),
              showEmailInput(),
              showPasswordInput(),
              showForgotPassword(),
              showSignInButton(),
              showSignUpButton(),
            ],
          ),
        ));
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 65.0,
          child: Image.asset('images/ColourCarrotTransp.png'),
        ),
      ),
    );
  }

  Widget showTitle() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: Center(
          child: Text(
          'Diet Tracker',
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

  Widget showForgotPassword() {
    return Container(
      alignment: Alignment(1.0, 0.0),
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: FlatButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PasswordReset()));
        },
        child: Text('Forgot Password',
          style: TextStyle(
            color: Color.fromRGBO(50, 196, 180, 1),
          ),
        ),
      )
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: Container(
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
          validator: EmailFieldValidator.validate,
          onChanged: (value) {
            setState(() => email = value.trim());
          }
        ),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
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
            hintText: 'Password',
            prefixIcon: new Icon(Icons.lock),
            suffixIcon: GestureDetector(
              onTap: () {
                _toggleVisibility();
              },
              child: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,),
              )),
        validator: PasswordFieldValidator.validate,
        onChanged: (value) {
          setState(() => password = value);
        }
      ),
    );
  }

  Widget showSignInButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 0.0,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
            color: Color.fromRGBO(245, 140, 78, 1),
            child: new Text('sign in',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () async {
            if (_formKey.currentState.validate()){
              dynamic result = await locator.get<UserController>().signInWithEmailAndPassword(email, password);
              if (result == null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Email and password combination not recognised.'),
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

  Widget showSignUpButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: new FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
        },
        child: Text('Don\'t have an account? Sign Up',
        style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      ),
    );
  }
}
