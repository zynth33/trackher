import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

extension AnimatedDialogExtension on BuildContext {
  Future<T?> showAnimatedDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) {
    return showModal(
      context: this,
      configuration: FadeScaleTransitionConfiguration(
        barrierDismissible: barrierDismissible,
        transitionDuration: transitionDuration,
      ),
      builder: builder,
    );
  }
}
