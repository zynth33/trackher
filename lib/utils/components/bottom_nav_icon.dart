import 'package:flutter/material.dart';

class BottomNavIcon extends StatelessWidget {
  final Color backgroundColor;
  final Widget icon;
  final VoidCallback onTap;
  final bool selected;
  final bool doubleTapped;
  final String name;
  const BottomNavIcon({
    super.key, required this.backgroundColor, required this.icon, required this.onTap, required this.selected, required this.doubleTapped, required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: selected ? 15.0 : 13.0, horizontal: selected ? doubleTapped ? 25.0 : 15.0 : 13.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(1, 1),
                ),
              ]
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: doubleTapped ? Text(name, style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14
              ),) : icon,
            )
          ),
          (selected && !doubleTapped) ? Positioned(
            right: 0,
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.5))
              ),
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}