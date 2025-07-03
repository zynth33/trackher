import 'dart:math';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:trackher/utils/constants.dart';
import '../../../sessions/period_session.dart';
import '../../../utils/extensions/color.dart';

class RoundedCircularProgressWithIcon extends StatelessWidget {
  final double day;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final double size;

  const RoundedCircularProgressWithIcon({
    super.key,
    required this.day,
    this.strokeWidth = 6,
    this.backgroundColor = const Color(0x11000000),
    this.progressColor = Colors.purple,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: PeriodSession().cycleLengthNotifier,
      builder: (context, cycleLength, _) {
        final progress = day / cycleLength;
        final center = Offset(size / 2, size / 2);
        final angle = -pi / 2 + (2 * pi * progress);

        final indicatorRadius = size / 2; // Always on the edge of the widget
        final iconSize = 30.0;

        final iconOffset = Offset(
          center.dx + indicatorRadius * cos(angle) - iconSize / 2,
          center.dy + indicatorRadius * sin(angle) - iconSize / 2,
        );

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              DashedCircle(
                dashes: cycleLength,
                gapSize: 3,
                color: Colors.black,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size / 2),
                    color: HexColor.fromHex("#FFF5FA"),
                  ),
                ),
              ),
              Positioned(
                left: iconOffset.dx,
                top: iconOffset.dy,
                child: Container(
                  // padding: EdgeInsets.all(6.0),
                  height: iconSize,
                  width: iconSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: HexColor.fromHex(AppConstants.primaryPink)
                  ),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: iconSize - 10,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
