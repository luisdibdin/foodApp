import 'package:flutter/material.dart';
import 'package:food_app/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/screens/authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);
    print(user);
    // return either Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}
