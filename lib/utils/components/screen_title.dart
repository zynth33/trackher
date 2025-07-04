import 'package:flutter/material.dart';

import '../constants.dart';
import '../extensions/color.dart';

class ScreenTitle extends StatelessWidget {
  final String title;
  final double size;
  const ScreenTitle({
    super.key, required this.title, this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40,),
        Text(title, style: TextStyle(
            color: HexColor.fromHex(AppConstants.primaryColorLight),
            fontWeight: FontWeight.bold,
            fontSize: size,
            shadows: [
              BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 10,
                offset: const Offset(1, 3),
              ),
            ]
        ),),
        SizedBox(height: 20,),
      ],
    );
  }
}