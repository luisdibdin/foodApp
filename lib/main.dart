import 'package:flutter/material.dart';
import 'package:food_app/models/user.dart';
import 'package:food_app/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:food_app/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xff5FA55A),
          accentColor: Color(0xff5FA55A),
        ),
        home: Wrapper(),
      ),
    );
  }
}
