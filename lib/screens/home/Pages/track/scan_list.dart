import 'package:flutter/material.dart';
import 'package:food_app/screens/home/Pages/track/scan_tile.dart';
import 'package:provider/provider.dart';
import 'package:food_app/services/scan.dart';

class ScanList extends StatelessWidget {

  final DateTime datePicked;
  ScanList({this.datePicked});

  @override
  Widget build(BuildContext context) {

    final DateTime curDate = new DateTime(datePicked.year, datePicked.month, datePicked.day);

    final scans = Provider.of<List<Scan>>(context);

    List findCurScans(List scansFeed) {
      List curScans = [];
      scansFeed.forEach((scan) {
        DateTime scanDate = DateTime(scan.dateTime.toDate().year, scan.dateTime.toDate().month, scan.dateTime.toDate().day);
        if (scanDate.compareTo(curDate) == 0) {
          curScans.add(scan);
        }
      });
      return curScans;
    }

    List curScans = findCurScans(scans);

    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: curScans.length + 1,
      itemBuilder: (context, index) {
        if (index < curScans.length) {
          return ScanTile(scan: curScans[index]);
        } else {
          return SizedBox(height: 5);
        }
        },
    );
  }
}

