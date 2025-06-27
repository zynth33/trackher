import 'package:flutter/material.dart';

import '../../../utils/enums.dart';

class MoodSelector extends StatefulWidget {
  final void Function(String name, String emoji) onMoodSelect;
  const MoodSelector({super.key, required this.onMoodSelect});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  MoodLevel? _selected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: MoodLevel.values.map((level) {
        final isSelected = _selected == level;

        String emoji;
        Color color = Colors.purple;
        Color textColor = Colors.purple;
        switch (level) {
          case MoodLevel.happy:
            emoji = "😊";
            break;
          case MoodLevel.calm:
            emoji = "😌";
            break;
          case MoodLevel.anxious:
            emoji = "😟";
            break;
          case MoodLevel.tired:
            emoji = "😴";
            break;
          case MoodLevel.sad:
            emoji = "😔";
            break;
          case MoodLevel.angry:
            emoji = "😡";
            break;
        }

        String label = level.name[0].toUpperCase() + level.name.substring(1);

        return InkWell(
          onTap: () {
            setState(() {
              _selected = level;
            });
            widget.onMoodSelect(level.name, emoji);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.only(right: 10, top: 10),
            width: 100,
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              border: isSelected ? Border.all(color: color.withValues(alpha: 0.4), width: 2) : Border.all(color: Colors.grey.withValues(alpha: 0.4), width: 2),
            ),
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
    );
  }
}