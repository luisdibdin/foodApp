import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/screens/home/Pages/profile.dart';
import 'package:food_app/services/scan.dart';
import 'package:food_app/screens/home/Pages/track.dart';
import 'package:food_app/services/bottom_app_bar.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  final Scan _scan = Scan();

  final _formKey = GlobalKey<FormState>();

  PageController _myPage = PageController(initialPage: 0);

  String productName = 'Loading...';
  Product newResult;
  double servingSize;
  String dropdownValue = 'grams';

  void _selectedTab(int index) {
    setState(() {
      _myPage.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffededed),
        body: PageView(
          physics: new NeverScrollableScrollPhysics(),
          controller: _myPage,
          onPageChanged: (newPage){
            _selectedTab(newPage);
          },
          children: <Widget>[
            Center(
              child: Container(
                child: Text('Hi'),
              ),
            ),
            Track(),
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
          selectedColor: Color(0xff01B4BC),
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
          backgroundColor: Color(0xff5FA55A),
          onPressed: () async {
              dynamic result = await _scan.barcodeScan();
              newResult = result;
              setState(() {
                productName = newResult.productName;
              });
              _showFoodToAdd(context);
          },
          tooltip: 'Add',
          child: Icon(Icons.add),
          elevation: 2.0,
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _showFoodToAdd(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
          title: Text(productName),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context), // passing false
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: () {
                _scan.storeProduct(newResult, servingSize, dropdownValue);
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
          content: _showAmountHad(),
      );
    });
  }

  Widget _showAmountHad() {
    return new Row(
      children: <Widget>[
        _showUserAmount(),
        _showServingOrGrams(),
      ],
    );
  }

  Widget _showUserAmount() {
      return new Expanded(
        child: new TextField(
          maxLines: 1,
          autofocus: true,
          decoration: new InputDecoration(
            labelText: 'Serving', hintText: 'eg. 100',
              contentPadding: EdgeInsets.all(0.0)
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
          onChanged: (value) {
            setState(() {
              servingSize = double.tryParse(value);
            });
          },
        ),
      );
  }

  Widget _showServingOrGrams() {
    return Expanded(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: DropdownButtonFormField(
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0.0)
            ),
            style: TextStyle(color: Colors.black),
            onChanged: (newValue) => setState(() {
                dropdownValue = newValue;
              }),
            items: <String>['grams', 'servings']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      );
  }
}


