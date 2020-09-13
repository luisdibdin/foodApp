import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_app/services/scan.dart';
import 'package:fl_chart/fl_chart.dart';


class CalorieStats extends StatelessWidget {

  DateTime datePicked;
  DateTime today = DateTime.now();
  CalorieStats({this.datePicked});

  double totalCalories = 0;
  double totalCarbs = 0;
  double totalFat = 0;
  double totalProtein = 0;
  double displayCalories = 0;

  bool dateCheck() {
    DateTime formatPicked = DateTime(datePicked.year, datePicked.month, datePicked.day);
    DateTime formatToday = DateTime(today.year, today.month, today.day);
    if (formatPicked.compareTo(formatToday) == 0) {
      return true;
    } else {
      return false;
    }
  }

  static List<double> macroData = [];

  @override
  Widget build(BuildContext context) {
    final DateTime curDate = new DateTime(
        datePicked.year, datePicked.month, datePicked.day);

    final scans = Provider.of<List<Scan>>(context);

    List findCurScans(List scansFeed) {
      List curScans = [];
      scansFeed.forEach((scan) {
        DateTime scanDate = DateTime(scan.dateTime
            .toDate()
            .year, scan.dateTime
            .toDate()
            .month, scan.dateTime
            .toDate()
            .day);
        if (scanDate.compareTo(curDate) == 0) {
          curScans.add(scan);
        }
      });
      return curScans;
    }


    List curScans = findCurScans(scans);

    void findNutriments(List curScans) {
      curScans.forEach((scan) {
        totalCarbs += scan.productCarbs;
        totalFat += scan.productFat;
        totalProtein += scan.productProtein;
        displayCalories += scan.productCalories;
      });
      totalCalories = 9 * totalFat + 4 * totalCarbs + 4 * totalProtein;
    }

    findNutriments(curScans);

    List<PieChartSectionData> _sections = List<PieChartSectionData>();

    PieChartSectionData _fat = PieChartSectionData(
      color: Color(0xff01B4BC),
      value: (9 * (totalFat) / totalCalories) * 100,
      title:  '', // ((9 * totalFat / totalCalories) * 100).toStringAsFixed(0) + '%',
      radius: 50,
      // titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );

    PieChartSectionData _carbohydrates = PieChartSectionData(
      color: Color(0xffFA5457),
      value: (4 * (totalCarbs) / totalCalories) * 100,
      title: '', // ((4 * totalCarbs / totalCalories) * 100).toStringAsFixed(0) + '%',
      radius: 50,
      // titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );

    PieChartSectionData _protein = PieChartSectionData(
      color: Color(0xffFA8925),
      value: (4 * (totalProtein) / totalCalories) * 100,
      title: '', // ((4 * totalProtein / totalCalories) * 100).toStringAsFixed(0) + '%',
      radius: 50,
      // titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );

    _sections = [_fat, _protein, _carbohydrates];

    macroData = [displayCalories, totalProtein, totalCarbs, totalFat];

    totalCarbs = 0;
    totalFat = 0;
    totalProtein = 0;
    displayCalories = 0;

    Widget _chartLabels() {
      return Padding(
        padding: EdgeInsets.only(top: 78.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Carbs ',
                    style: TextStyle(
                      color: Color(0xffFA5457),
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,)),
                Text(macroData[2].toStringAsFixed(1) + 'g',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,)),
              ],
            ),
            SizedBox(height: 3.0),
            Row(
              children: <Widget>[
                Text('Protein ',
                    style: TextStyle(
                      color: Color(0xffFA8925),
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,)),
                Text(macroData[1].toStringAsFixed(1) + 'g',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,)),
              ],
            ),
            SizedBox(height: 3.0),
            Row(
              children: <Widget>[
                Text('Fat ',
                    style: TextStyle(
                      color: Color(0xff01B4BC),
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,)),
                Text(macroData[3].toStringAsFixed(1) + 'g',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,)),
              ],
            ),
          ],
        ),
      );
    }

    Widget _calorieDisplay() {
      return Container(
        height: 74,
        width: 74,
        decoration: BoxDecoration(
          color: Color(0xff5FA55A),
          shape: BoxShape.circle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(macroData[0].toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w500,
                )
            ),
            Text('kcal',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w500,
                )
            ),
          ],
        ),
      );
    }

    print(totalFat);

    if (curScans.length == 0) {
      if (dateCheck()) {
        return Flexible(
          fit: FlexFit.loose,
          child: Text('Add food to see calorie breakdown.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w500,
              )
          ),
        );
      } else {
        return Flexible(
          fit: FlexFit.loose,
          child: Text('No food added on this day.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w500,
              )
          ),
        );
      }
    } else {
      return Container(
        child: Row(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sections: _sections,
                      borderData: FlBorderData(show: false),
                      centerSpaceRadius: 40,
                      sectionsSpace: 3,
                    ),
                  ),
                ),
                _calorieDisplay(),
              ]
            ),
            _chartLabels(),
          ],
        ),
      );
    }
  }
}


