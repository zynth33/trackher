import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

class HelpButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color bgColor;
  final Color textColor;
  final Color strokeColor;

  const HelpButton({super.key, required this.icon, required this.label, required this.bgColor, required this.textColor, required this.strokeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: strokeColor
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 6),
              Text(label, style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold
              ),),
            ],
          ),
        ),
      ),
    );
  }
}