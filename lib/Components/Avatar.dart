import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key key, this.photoURL, @required this.radius}) : super(key: key);
  final String photoURL;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black54,
          width: 1.5,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black12,
        backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
        child: photoURL == null ? Icon(Icons.camera_alt, size: radius) : null,
      ),
    );
  }
}