import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded(
              child: Divider()
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(text, style: TextStyle(
              color: Colors.grey
            ),),
          ),

          Expanded(
              child: Divider()
          ),
        ]
    );
  }
}
