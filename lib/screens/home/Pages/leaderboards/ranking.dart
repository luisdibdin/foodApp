import 'package:flutter/material.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/screens/home/Pages/leaderboards/friend_leaderboard.dart';
import 'package:food_app/services/database.dart';
import 'package:provider/provider.dart';

class Ranking extends StatefulWidget {
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Leader Boards')),
          bottom: TabBar(
            tabs: <Widget>[
              Text('Weekly'),
              Text('All-Time')
            ],
          ),
        ),
        body: StreamProvider<List<UserModel>>.value(
          initialData: List(),
          value: DatabaseService(uid: user.uid).friends,
          child: TabBarView(
            children: <Widget>[
              FriendLeaderBoard(tileType: 0),
              FriendLeaderBoard(tileType: 1)
            ],
          ),
        ),
      ),
    );
  }
}
