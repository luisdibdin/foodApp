import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_app/locator.dart';
import 'package:food_app/screens/home/Pages/profile/profile.dart';
import 'package:food_app/services/question_controller.dart';
import 'package:food_app/services/user_controller.dart';

class QuestionAlert extends StatefulWidget {

  final List value;
  QuestionAlert({this.value});

  @override
  _QuestionAlertState createState() => _QuestionAlertState();
}

class _QuestionAlertState extends State<QuestionAlert> {

  List<Color> colours = [
    Color(0xffFA5457),
    Color(0xffFA8925),
    Color(0xff01B4BC),
    Color(0xffF6D51F)
    ];

  bool pressable;

  QuestionController _question;
  List<int> choices;

  void initState() {
    super.initState();
    pressable = true;
    _question = QuestionController(correctValue: widget.value[0]);
    choices = _question.getChoices(widget.value[0]);
  }

  void disableButton() {
    setState(() {
      pressable = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text('How ' + widget.value[1] + ' in this?'),
      content: choiceBox(_question, choices),
    );
  }

  Widget choiceBox(QuestionController question, List<int> choices) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 70,
              width: 100,
              child: FlatButton(
                child: Text(choices[0].toString() + widget.value[2]),
                color: colours[0],
                onPressed: () {
                  pressable ? checker(choices[0], choices, question) : null;
                },
              ),
            ),
            SizedBox(
              height: 70,
              width: 100,
              child: FlatButton(
                child: Text(choices[1].toString() + widget.value[2]),
                color: colours[1],
                onPressed: () {
                  pressable ? checker(choices[1], choices, question) : null;
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 70,
              width: 100,
              child: FlatButton(
                child: Text(choices[2].toString() + widget.value[2]),
                color:  colours[2],
                onPressed: () {
                  pressable ? checker(choices[2], choices, question) : null;
                },
              ),
            ),
            SizedBox(
              height: 70,
              width: 100,
              child: FlatButton(
                child: Text(choices[3].toString() + widget.value[2]),
                color: colours[3],
                onPressed: () {
                  pressable ? checker(choices[3], choices, question) : null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> checker(int pressed, List<int> choices, QuestionController question) async {
    int correctPos = await question.checkAnswer(pressed, choices);
    setState(() {
      colours[correctPos] = Color(0xff5FA55A);
    });
    for (int i = 0; i < 4; i++) {
      if (i != correctPos) {
        setState(() {
          colours[i] = Colors.grey;
        });
      }
    }
    disableButton();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
