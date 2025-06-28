import 'package:flutter/material.dart';

import '../../../sessions/dates_session.dart';
import '../../../sessions/symptoms_session.dart';
import '../../../utils/enums.dart';

class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  MoodLevel? _selected;

  MoodLevel? getMoodForDate(DateTime date) {
    final data = DatesSession().getDataForDate(date);
    final value = data["mood"];

    if (value is String) {
      return MoodLevel.values.firstWhere(
            (e) => e.name == value,
      );
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _selected = getMoodForDate(DatesSession().selectedDate);
  }

  DateTime? _lastDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ValueListenableBuilder<DateTime>(
        valueListenable: DatesSession().selectedDateNotifier,
        builder: (context, selectedDate, _) {
          final moodName = DatesSession().getValueForKey(selectedDate, "mood");

          if (_lastDate != selectedDate) {
            _lastDate = selectedDate;

            final moodName = DatesSession().getValueForKey(selectedDate, "mood");
            _selected = MoodLevel.values.any((e) => e.name == moodName)
                ? MoodLevel.values.firstWhere((e) => e.name == moodName)
                : null;
          }

          return SingleChildScrollView(
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
                      if (_selected == level) {
                        _selected = null;
                        SymptomsSession().setSymptoms("mood", []);
                      } else {
                        _selected = level;
                        SymptomsSession().setSymptoms("mood", [label]);
                        DatesSession().setEntryForDateKey(selectedDate, "mood", _selected!.name);
                      }
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
          );
        },
      ),
    );
  }
}