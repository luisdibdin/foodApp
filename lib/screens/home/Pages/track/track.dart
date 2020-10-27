import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/screens/home/Pages/track/calorie_stats.dart';
import 'package:food_app/screens/home/Pages/track/question_alert.dart';
import 'package:food_app/screens/home/Pages/track/scan_list.dart';
import 'package:food_app/services/database.dart';
import 'package:openfoodfacts/model/Product.dart';
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

  final Scan _scan = Scan();
  String productName = 'Loading...';
  Product newResult;
  double servingSize;
  String dropdownValue = 'grams';

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _showDatePicker(),
                _addFoodButton(),
              ],
            ),
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
    return Container(
      width: 250,
      child: Row(
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
      ),
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
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sep";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
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

  Widget _addFoodButton() {
    return IconButton(
      icon: Icon(Icons.add_box),
      iconSize: 25,
      color: Colors.white,
      onPressed: () async {
        dynamic result = await _scan.barcodeScan();
        setState(() {
          newResult = result;
          productName = newResult.productName;
        });
        _showFoodToAdd(context);
      },
    );
  }

  _showFoodToAdd(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(productName),
        content: _showAmountHad(),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context), // passing false
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () async {
              Navigator.pop(context);
              await showDialog(context: context, builder: (context){
                List<List> questionArray = [
                  [newResult.nutriments.energyKcal100g * servingSize/100, 'many calories are', ''],
                  [newResult.nutriments.fat * servingSize/100, 'much fat is', 'g'],
                  [newResult.nutriments.proteins * servingSize/100, 'much protein is', 'g'],
                  [newResult.nutriments.carbohydrates * servingSize/100, 'much carbohydrate is', 'g']
                ];
                questionArray.shuffle();
                return QuestionAlert(value: questionArray[0]);
              });
              _scan.storeProduct(newResult, servingSize, dropdownValue);
            },
            child: Text('Ok'),
          ),
        ],
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
