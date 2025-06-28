import 'dart:math';

import 'package:flutter/material.dart';
import '../../../sessions/period_session.dart';

class RoundedCircularProgress extends StatelessWidget {
  final double day;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final double size;

  const RoundedCircularProgress({
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
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RoundedProgressPainter(
              progress: day / cycleLength,
              strokeWidth: strokeWidth,
              backgroundColor: backgroundColor,
              progressColor: progressColor,
            ),
          ),
        );
      },
    );
  }
}

class _RoundedProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _RoundedProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );

    // Draw indicator (a small dot outside the arc)
    final indicatorRadius = radius + strokeWidth / 2 - 18; // a bit outside
    final angle = startAngle + sweepAngle;

    final indicatorOffset = Offset(
      center.dx + indicatorRadius * cos(angle),
      center.dy + indicatorRadius * sin(angle),
    );

    final indicatorPaint = Paint()..color = Colors.pinkAccent.withValues(alpha: 0.5);

    canvas.drawCircle(indicatorOffset, 7, indicatorPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}