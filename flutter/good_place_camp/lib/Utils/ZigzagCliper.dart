import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';

class ZigzagClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    const circleRadius = 10.0;
    final pointCount = size.width / 40;
    path.lineTo(0, size.height - circleRadius);
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / pointCount;

    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 40 : size.height;
      
      if (curYPos == size.height) {
        path.lineTo(curXPos  - circleRadius, curYPos - circleRadius);
        path.arcToPoint(Offset(curXPos, curYPos - circleRadius),
            radius: Radius.circular(circleRadius), clockwise: false);
      } else {
        path.lineTo(curXPos - circleRadius, curYPos);
        path.arcToPoint(Offset(curXPos, curYPos),
            radius: Radius.circular(circleRadius));
      }

      
    }

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
