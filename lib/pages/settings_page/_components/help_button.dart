import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const HelpButton({super.key, required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 80,
      // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold
            ),),
          ],
        ),
      ),
    );
  }
}