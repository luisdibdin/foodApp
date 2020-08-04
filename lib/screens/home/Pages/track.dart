import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';

class Track extends StatefulWidget {
  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(1, 0.95),
      child: RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: Colors.grey,
        child: Icon(
          Icons.camera_alt,
          size: 35.0,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );
  }
}
