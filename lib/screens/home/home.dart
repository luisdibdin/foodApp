import 'package:flutter/material.dart';
import 'package:food_app/screens/home/Pages/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  int _currentIndex = 0;
  PageController _c;

  @override
  void initState() {
    _c = new PageController(
      initialPage: _currentIndex,
        viewportFraction: 0.8
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Tracker'),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (currentIndex) {
            this._c.animateToPage(currentIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.book),
            title: new Text('Track'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.assessment),
            title: new Text('Targets',)
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
          ),
        ]
      ),
      body: new PageView(
        controller: _c,
        onPageChanged: (newPage){
          setState(() {
            this._currentIndex = newPage;
          });
        },
        children: <Widget>[
          new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(Icons.home),
                new Text("Home")
              ],
            ),
          ),
          new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(Icons.supervised_user_circle),
                new Text("Users")
              ],
            ),
          ),
          new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(Icons.notifications),
                new Text("Alerts")
              ],
            ),
          ),
          Profile(),
        ],
      ),
    );
  }
}
