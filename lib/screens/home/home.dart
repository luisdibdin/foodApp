import 'package:flutter/material.dart';
import 'package:food_app/screens/home/Pages/profile.dart';
import 'package:food_app/screens/home/Pages/scan.dart';
import 'package:food_app/screens/home/Pages/track.dart';
import 'package:food_app/services/bottom_app_bar.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  final Scan _scan = Scan();

  PageController _myPage = PageController(initialPage: 0);
  String textResult = 'Hi there';

  int _lastSelected = 0;

  void _selectedTab(int index) {
    setState(() {
      _myPage.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Diet Tracker'),
        ),
        body: PageView(
          physics: new NeverScrollableScrollPhysics(),
          controller: _myPage,
          onPageChanged: (newPage){
            _selectedTab(newPage);
          },
          children: <Widget>[
            Center(
              child: Container(
                child: Text(textResult),
              ),
            ),
            Center(
              child: Container(
                child: Text('Empty Body 1'),
              ),
            ),
            Center(
              child: Container(
                child: Text('Empty Body 2'),
              ),
            ),
            Profile(),
          ],
        ),
        bottomNavigationBar: FABBottomAppBar(
          color: Colors.grey,
          selectedColor: Colors.red,
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: _selectedTab,
          items: [
            FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
            FABBottomAppBarItem(iconData: Icons.book, text: 'Track'),
            FABBottomAppBarItem(iconData: Icons.insert_chart, text: 'Ranking'),
            FABBottomAppBarItem(iconData: Icons.account_box, text: 'Profile'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: new FloatingActionButton(
          onPressed: () async {
            dynamic result = await _scan.barcodeScan();
            setState(() {
              textResult = result;
            });
          },
          tooltip: 'Add',
          child: Icon(Icons.add),
          elevation: 2.0,
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

