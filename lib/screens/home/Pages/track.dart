import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/user.dart';
import 'package:food_app/screens/home/Pages/calorie_stats.dart';
import 'package:food_app/screens/home/scan_list.dart';
import 'package:food_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:food_app/services/scan.dart';

class Track extends StatefulWidget {
  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {

  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  Color _rightArrowColour = Color(0xffC1C1C1);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5.0),
            child: _showDatePicker(),
          )
        ),
        body: StreamProvider<List<Scan>>.value(
          initialData: List(),
          value: DatabaseService(uid: user.uid).scans,
          child: new Column(
            children: <Widget>[
              _calorieCounter(),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ScanList(datePicked: _value),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _value,
        firstDate: new DateTime(2019),
        lastDate: new DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: const Color(0xff5FA55A),//Head background
              accentColor: const Color(0xFF5FA55A)//selection color
            //dialogBackgroundColor: Colors.white,//Background color
          ),
          child: child,
        );
      },
    );
    if(picked != null) setState(() => _value = picked);
    _stateSetter();
  }

  Widget _showDatePicker() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_left, size: 25.0),
          color: Colors.white,
          onPressed: () {
            setState(() {
              _value = _value.subtract(Duration(days: 1));
              _rightArrowColour = Colors.white;
            });
          },
        ),
        FlatButton(
          textColor: Colors.white,
          onPressed: () => _selectDate(),
          child: Text(_dateFormatter(_value),
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          )),
        ),
        IconButton(
          icon: Icon(Icons.arrow_right, size: 25.0),
          color: _rightArrowColour,
          onPressed: () {
            print(today.difference(_value).compareTo(Duration(days: 1)));
            if (today.difference(_value).compareTo(Duration(days: 1)) == -1)  {
              setState(() {
                _rightArrowColour = Color(0xffC1C1C1);
              });
            } else {
              setState(() {
                _value = _value.add(Duration(days: 1));
              });
              if (today.difference(_value).compareTo(Duration(days: 1)) == -1) {
                setState(() {
                  _rightArrowColour = Color(0xffC1C1C1);
                });
              }
            }
          }
        ),
      ],
    );
  }

  void _stateSetter() {
    if (today.difference(_value).compareTo(Duration(days: 1)) == -1) {
      setState(() => _rightArrowColour = Color(0xffEDEDED));
    } else
      setState(() => _rightArrowColour = Colors.white);
  }

  String _dateFormatter(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    String month;
    switch (tm.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Yesterday";
    } else {
      return '${tm.day} $month ${tm.year}';
    }
  }

  Widget _calorieCounter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1.5,
            )
          )
        ),
        height: 220,
        child: Row(
          children: <Widget>[
            CalorieStats(datePicked: _value),
          ],
        ),
      ),
    );
  }
}
