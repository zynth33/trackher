import 'package:flutter/material.dart';

import '../constants.dart';
import '../extensions/color.dart';
import 'gradient_rich_text.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GradientRichText(textSpans: [
            TextSpan(text: "TrackHer", style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ))
          ], gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.pink
              ]
          ),),
        ),
        SizedBox(height: 10,),
        Center(
          child: Text("Your personal wellness companion", style: TextStyle(
              fontSize: 16,
              color: HexColor.fromHex(AppConstants.graySwatch1)
          ),),
        ),
      ]
    );
  }
}
