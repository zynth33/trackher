import 'package:flutter/material.dart';

class BottomSheetButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const BottomSheetButton({super.key, required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            leading: Icon(icon, color: Colors.pinkAccent),
            title: Text(
              label,
              style: TextStyle(
                color: Colors.pinkAccent,
                fontFamily: 'Mali',
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onTap: onPressed,
          ),
        ),
      ),
    );
  }
}
