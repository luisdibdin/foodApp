import 'package:flutter/material.dart';
import 'package:food_app/screens/home/Pages/track/calorie_stats.dart';
import 'package:food_app/screens/home/Pages/track/edit_item.dart';
import 'package:food_app/services/scan.dart';

class ScanTile extends StatelessWidget {

  final Scan scan;
  ScanTile({this.scan});

  List macros = CalorieStats.macroData;

  @override
  Widget build(BuildContext context) {
        return ExpansionTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Color(0xff5FA55A),
            child: _itemCalories(),
          ),
          title: Text(scan.productName, style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w500,
          )),
          subtitle: _macroData(),
          children: <Widget>[
            _expandedView(context),
          ],
        );
  }

  Widget _itemCalories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(scan.productCalories.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w500,
            )
        ),
        Text('kcal',
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w500,
            )
        ),
      ],
    );
  }

  Widget _macroData() {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Color(0xffFA5457),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(' ' + scan.productCarbs.toStringAsFixed(1) + 'g    ',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )
                  ),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Color(0xffFA8925),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(' ' + scan.productProtein.toStringAsFixed(1) + 'g    ',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )
                  ),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Color(0xff01B4BC),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(' ' + scan.productFat.toStringAsFixed(1) + 'g',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )
                  ),
                ],
              ),
              Text(scan.grams.toString() + 'g',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w300,
                  )
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _expandedView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 15.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          expandedHeader(context),
          _expandedCalories(),
          _expandedCarbs(),
          _expandedProtein(),
          _expandedFat(),
        ],
      ),
    );
  }

  Widget expandedHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('% of total',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            )
        ),
        IconButton(
          icon: Icon(Icons.edit),
          iconSize: 16,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditItem(scan: scan)),
            );
          }
        )
      ],
    );
  }

  Widget _expandedCalories() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: (scan.productCalories / macros[0]),
              backgroundColor: Color(0xffEDEDED),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff5FA55A)),
            ),
          ),
          Text('      ' +
              ((scan.productCalories / macros[0]) * 100).toStringAsFixed(0) +
              '%'),
        ],
      ),
    );
  }

  Widget _expandedCarbs() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: (scan.productCarbs/macros[2]),
              backgroundColor: Color(0xffEDEDED),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFA5457)),
            ),
          ),
          Text('      ' + ((scan.productCarbs/macros[2])*100).toStringAsFixed(0) + '%'),
        ],
      ),
    );
  }

  Widget _expandedProtein() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: (scan.productProtein/macros[1]),
              backgroundColor: Color(0xffEDEDED),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFA8925)),
            ),
          ),
          Text('      ' + ((scan.productProtein/macros[1])*100).toStringAsFixed(0) + '%'),
        ],
      ),
    );
  }

  Widget _expandedFat() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: (scan.productFat/macros[3]),
              backgroundColor: Color(0xffEDEDED),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff01B4BC)),
            ),
          ),
          Text('      ' + ((scan.productFat/macros[3])*100).toStringAsFixed(0) + '%'),
        ],
      ),
    );
  }
}
