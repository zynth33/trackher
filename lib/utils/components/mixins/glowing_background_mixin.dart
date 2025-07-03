import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../extensions/color.dart';

mixin GlowingBackgroundMixin {
  /// Wraps any widget in a Stack with a glowing circular background
  Widget withGlowingBackground(
      Widget child, {
        double size = 400,
        double offset = -100,
        Color? glowColor,
      }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: offset,
          right: offset,
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: glowColor ?? HexColor.fromHex(AppConstants.backgroundLight).withValues(alpha: 0.6),
                  blurRadius: 60,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
