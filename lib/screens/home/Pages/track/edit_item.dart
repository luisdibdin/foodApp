import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/services/database.dart';
import 'package:food_app/services/scan.dart';

class EditItem extends StatefulWidget {

  final Scan scan;
  EditItem({this.scan});

  @override
  _EditItemState createState() => _EditItemState(scan);
}

class _EditItemState extends State<EditItem> {

  final Scan scan;
  _EditItemState(this.scan);

  String productName;
  double productCalories;
  double productCarbs;
  double productProtein;
  double productFat;
  double productGrams;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    productCalories = scan.productCalories;
    productCarbs = scan.productCarbs;
    productProtein = scan.productProtein;
    productFat = scan.productFat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0.0),
        child: Column(
          children: <Widget>[
            _headerRow(),
            _editForm(),
          ],
        ),
      ),
    );
  }

  Widget _headerRow() {
    return Container(
      height: 40.0,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 20.0,
                onPressed: () {
                  Navigator.pop(context);
                }
                ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text('Edit Item',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w500,
                )
            ),
          ),
        ]
      ),
    );
  }

  Widget _editForm() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Form(
        child: Column(
          children: <Widget>[
            Text(scan.productName, style:
              TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
              )
            ),
            SizedBox(height: 20),
            _calorieDisplay(),
            _macroEditColumn(),
            _submitButton(),
            _deleteButton(),
          ],
        ),
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
          Text(productCalories.toStringAsFixed(0),
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

  Widget _macroEditColumn() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          _carbsEdit(),
          _proteinEdit(),
          _fatEdit(),
        ],
      ),
    );
  }

  Widget _carbsEdit() {
    return Container(
      width: 300,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Carbohydrates',
              style: TextStyle(
                  color: Color(0xffFA5457),
                  fontFamily: 'Open Sans',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600
              )
          ),
          Container(
            width: 100,
            height: 40,
            child: TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              initialValue: productCarbs.toStringAsFixed(1),
              onChanged: (value) {
                if (value == null) {
                  setState(() => productCarbs = 0.0);
                  setState(() => productCalories = 9*productFat + 4*productCarbs + 4*productProtein);
                } else {
                  setState(() => productCarbs = double.parse(value));
                  setState(() => productCalories = 9*productFat + 4*productCarbs + 4*productProtein);
                }
              },
            ),
          ),
        ],
      )
    );
  }

  Widget _proteinEdit() {
    return Container(
      width: 300,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Protein',
                style: TextStyle(
                    color: Color(0xffFA8925),
                    fontFamily: 'Open Sans',
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600
                )
            ),
            Container(
              width: 100,
              height: 40,
              child: TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.number,
                initialValue: productProtein.toStringAsFixed(1),
                onChanged: (value) {
                  if (value == null) {
                    setState(() => productProtein = 0.0);
                    setState(() => productCalories = 9*productFat + 4*productCarbs + 4*productProtein);
                  } else {
                    setState(() => productProtein = double.parse(value));
                    setState(() => productCalories = 9*productFat + 4*productCarbs + 4*productProtein);
                  }
                },
              ),
            ),
          ],
        )
    );
  }

  Widget _fatEdit() {
    return Container(
      width: 300,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Fat',
                style: TextStyle(
                  color: Color(0xff01B4BC),
                  fontFamily: 'Open Sans',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600
                )
            ),
            Container(
              width: 100,
              height: 40,
              child: TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.number,
                initialValue: productFat.toStringAsFixed(1),
                onChanged: (value) {
                  if (value == null) {
                    setState(() => productFat = 0.0);
                    setState(() => productCalories = 9*productFat + 4*productCarbs + 4*productProtein);
                  } else {
                    setState(() => productFat = double.parse(value));
                    setState(() => productCalories = 9*productFat + 4*productCarbs + 4*productProtein);
                  }
                },
              ),
            ),
          ],
        )
    );
  }

  Widget _submitButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 0.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          color: Color(0xff5FA55A),
          child: new Text('Submit Changes',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () async {
            final FirebaseUser user = await _auth.currentUser();
            await DatabaseService(uid: user.uid).updateScanData(scan.productID, productCalories, productCarbs, productFat, productProtein);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _deleteButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 0.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          color: Color(0xffFA5457),
          child: new Text('Delete Item',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () async {
            final FirebaseUser user = await _auth.currentUser();
            await DatabaseService(uid: user.uid).deleteScan(scan.productID);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
