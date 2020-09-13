import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {

  final String avatarUrl;
  final double radius;
  const Avatar({this.avatarUrl, this.radius});

  @override
  Widget build(BuildContext context) {
    if (avatarUrl == null) {
      return CircleAvatar(
        radius: radius,
        child: Icon(Icons.person),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }
  }
}
