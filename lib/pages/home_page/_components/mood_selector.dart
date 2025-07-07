import 'package:flutter/material.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ValueListenableBuilder<DateTime>(
          valueListenable: DatesSession().selectedDateNotifier,
          builder: (context, selectedDate, _) {
            if (_lastDate != selectedDate) {
              _lastDate = selectedDate;

              final moodName = DatesSession().getValueForKey(selectedDate, "mood");
              _selected = MoodLevel.values.any((e) => e.name == moodName)
                  ? MoodLevel.values.firstWhere((e) => e.name == moodName)
                  : null;
            }

            return Wrap(
              spacing: 5,
              runSpacing: 5,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.start,
              alignment: WrapAlignment.start,
              children: MoodLevel.values.map((level) {
                final isSelected = _selected == level;

                String emoji;
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

                return IntrinsicWidth(
                  child: InkWell(
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
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                      decoration: isSelected ? BoxDecoration(
                        color: HexColor.fromHex(AppConstants.primaryPurple).withValues(alpha: 0.54),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.transparent, width: 2),
                      ) : BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.1), width: 2),
                      ),
                      child: Row(
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 6),
                          Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}