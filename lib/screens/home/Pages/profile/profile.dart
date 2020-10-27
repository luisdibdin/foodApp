import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food_app/locator.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/screens/home/Pages/profile/avatar.dart';
import 'package:food_app/screens/home/Pages/profile/friends_view.dart';
import 'package:food_app/services/auth.dart';
import 'package:food_app/services/user_controller.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  UserModel _currentUser = locator.get<UserController>().currentUser;
  List<double> lastSixWeeks = [0, 0, 0, 0, 0, 0];

  Future<void> refresh() async {
    await locator.get<UserController>().setLatestWeek();
    setState(() {
      weeklyScores();
      usernameColumn();
    });
  }

  Future<void> getLastSixWeeksData() async {
    lastSixWeeks = await locator.get<UserController>().getLastSixUserScores();
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    getLastSixWeeksData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          userHeader(),
          weeklyScores(),
          scoreBarChart(),
          friendsListButton(),
          signOutButton(),
        ],
      ),
    );
  }

  Widget weeklyScores() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 1.5,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('This', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
                    Text('Week', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_currentUser.weekScore.toString(),
                        style: TextStyle(
                            fontSize: 26.0, fontWeight: FontWeight.w500)),
                    Text('Correct'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_currentUser.weekTotal.toString(),
                        style: TextStyle(
                            fontSize: 26.0, fontWeight: FontWeight.w500)),
                    Text('Answered'),
                  ],
                ),
                Text(
                    ((_currentUser.weekScore / _currentUser.weekTotal) * 100)
                            .toStringAsFixed(0) +
                        '%',
                    style:
                        TextStyle(fontSize: 34.0, fontWeight: FontWeight.w500)),
              ],
            ),
        ),
      );
  }

  Widget scoreBarChart() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1.5,
            ),
          ),
        ),
        child: AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Container(
              child: BarChart(BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                axisTitleData: FlAxisTitleData(
                  bottomTitle: AxisTitle(
                    showTitle: true,
                      titleText: 'Weeks Ago',
                  textStyle: TextStyle(color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,)),
                ),
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: const EdgeInsets.all(0),
                    tooltipBottomMargin: 8,
                    getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                    ) {
                      return BarTooltipItem(
                        rod.y.toStringAsFixed(0) + '%',
                        TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    textStyle: TextStyle(
                        color: const Color(0xff7589a2),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    margin: 20,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'Six';
                        case 1:
                          return 'Five';
                        case 2:
                          return 'Four';
                        case 3:
                          return 'Three';
                        case 4:
                          return 'Two';
                        case 5:
                          return 'One';
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(showTitles: false),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: [
                  BarChartGroupData(
                      x: 0,
                      barRods: [BarChartRodData(y: lastSixWeeks[5], color: Color(0xff5FA55A))],
                      showingTooltipIndicators: [0]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(y: lastSixWeeks[4], color: Color(0xff5FA55A),)
                  ], showingTooltipIndicators: [
                    0
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(y: lastSixWeeks[3], color: Color(0xff5FA55A),)
                  ], showingTooltipIndicators: [
                    0
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(y: lastSixWeeks[2], color: Color(0xff5FA55A),)
                  ], showingTooltipIndicators: [
                    0
                  ]),
                  BarChartGroupData(x: 4, barRods: [
                    BarChartRodData(y: lastSixWeeks[1], color: Color(0xff5FA55A),)
                  ], showingTooltipIndicators: [
                    0
                  ]),
                  BarChartGroupData(x: 5, barRods: [
                    BarChartRodData(y: lastSixWeeks[0], color: Color(0xff5FA55A),)
                  ], showingTooltipIndicators: [
                    0
                  ]),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget signOutButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0.0),
      child: FlatButton(
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 10),
                  Text('sign out')
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 15.0),
            ],
          ),
        ),
        onPressed: () {
          _auth.signOut();
        },
      ),
    );
  }

  Widget userHeader() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
          color: Color(0xff01B4BC),
          border: Border(
              bottom: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 1.5,
          ))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 40.0, 15.0, 0.0),
                child: editButton()),
          ),
          profilePicture(),
          usernameColumn(),
        ],
      ),
    );
  }

  Widget editButton() {
    return IconButton(
      icon: Icon(Icons.edit),
      color: Colors.white,
      onPressed: () async {
        File image = await ImagePicker.pickImage(source: ImageSource.gallery);

        await locator.get<UserController>().uploadProfilePicture(image);

        setState(() {
          profilePicture();
        });
      },
    );
  }

  Widget profilePicture() {
    return Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          color: Color(0xff5FA55A),
          shape: BoxShape.circle,
        ),
        child: Avatar(avatarUrl: _currentUser?.avatarUrl, radius: 60));
  }

  Widget friendsListButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0.0),
      child: FlatButton(
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.people),
                  SizedBox(width: 10),
                  Text('friends')
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 15.0),
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendView()),
          );
        },
      ),
    );
  }

  Widget usernameColumn() {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Text(_currentUser?.username ?? 'User',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            )),
        Text(
          _currentUser.calculateExpertiseTitle(),
          style: TextStyle(
            color: Color(0xffF6D51F),
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
