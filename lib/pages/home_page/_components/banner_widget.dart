import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      color: Colors.pinkAccent,
      alignment: Alignment.center,
      child: Text(
        'Did you get your Period today?',
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}
