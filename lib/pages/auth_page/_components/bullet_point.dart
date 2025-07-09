import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  final String text;
  final Widget icon;

  const BulletPoint({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 11.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 8,
            height: 8,
            child: icon,
          ),
          SizedBox(width: 35,),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
