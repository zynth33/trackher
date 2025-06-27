import 'package:flutter/material.dart';

import '../../../utils/enums.dart';

class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  MoodLevel? _selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: MoodLevel.values.map((level) {
            final isSelected = _selected == level;

            String emoji;
            Color color;
            Color textColor;
            switch (level) {
              case MoodLevel.happy:
                emoji = "😊";
                color = Colors.green;
                textColor = Colors.green;
                break;
              case MoodLevel.calm:
                emoji = "😌";
                color = Colors.blue;
                textColor = Colors.blue;
                break;
              case MoodLevel.anxious:
                emoji = "😟";
                color = Colors.yellow;
                textColor = Colors.orange;
                break;
              case MoodLevel.tired:
                emoji = "😴";
                color = Colors.grey;
                textColor = Colors.grey;
                break;
              case MoodLevel.sad:
                emoji = "😔";
                color = Colors.purple;
                textColor = Colors.purple;
                break;
              case MoodLevel.angry:
                emoji = "😡";
                color = Colors.red;
                textColor = Colors.red;
                break;
            }

            String label = level.name[0].toUpperCase() + level.name.substring(1);

            return InkWell(
              onTap: () {
                setState(() {
                  _selected = level;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: 58,
                decoration: isSelected ? BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
                ) : null,
                child: Column(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? textColor : Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}