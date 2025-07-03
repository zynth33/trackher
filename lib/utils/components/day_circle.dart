import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

Widget buildCircle({
  required DateTime day,
  required Color fill,
  Color? border,
  Color? textColor,
  Color? dotColor = Colors.pink,
  bool showDot = false,
  bool isNormal = true,
  bool isFuture = false,
  bool showBorder = true
}) {
  return Container(
    margin: EdgeInsets.all(1.0),
    child: Stack(
      alignment: Alignment.center,
      children: [
        DashedCircle(
          dashes: isFuture ? 18 : 0,
          gapSize: 4,
          color: showBorder ? border ?? Colors.black : Colors.transparent,
          child: Container(
            width: AppConstants.kCircleSize,
            height: AppConstants.kCircleSize,
            // padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fill,
              border: border != null && !isFuture
                  ? Border.all(color: border, width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                  color: textColor ?? Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14
              ),
            ),
          ),
        ),
        if (showDot)
          Positioned(
            bottom: 3,
            right: 6,
            child: Container(
              width: AppConstants.kDotSize,
              height: AppConstants.kDotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
          ),
      ],
    ),
  );
}


