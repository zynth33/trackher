import 'package:flutter/material.dart';

import '../constants.dart';
import '../extensions/color.dart';

class ScreenTitle extends StatelessWidget {
  final String title;
  const ScreenTitle({
    super.key, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40,),
        Text(title, style: TextStyle(
            color: HexColor.fromHex(AppConstants.primaryColorLight),
            fontWeight: FontWeight.bold,
            fontSize: 24,
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