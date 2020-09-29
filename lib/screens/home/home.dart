import 'package:flutter/material.dart';
import 'package:food_app/locator.dart';
import 'package:food_app/screens/home/Pages/leaderboards/ranking.dart';
import 'package:food_app/screens/home/Pages/profile/profile.dart';
import 'package:food_app/screens/home/Pages/track/track.dart';
import 'package:food_app/services/user_controller.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  int _currentIndex = 0;

  Future<void> setCurrentUser() async {
    await locator.get<UserController>().setUserData();
  }

  void initState() {
    super.initState();
    setCurrentUser();
  }

  final tabs = [
    Track(),
    Ranking(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffededed),
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xff01B4BC),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.book), title: Text('Track')),
            BottomNavigationBarItem(icon: Icon(Icons.insert_chart), title: Text('Ranking')),
            BottomNavigationBarItem(icon: Icon(Icons.account_box), title: Text('Profile')),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
    );
  }
}


