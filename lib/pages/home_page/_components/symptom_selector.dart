import 'package:flutter/material.dart';
import '../../../sessions/dates_session.dart';
import '../../../sessions/symptoms_session.dart';

import '../../../utils/enums.dart';

class SymptomSelector extends StatefulWidget {
  const SymptomSelector({super.key});

  @override
  State<SymptomSelector> createState() => _SymptomSelectorState();
}

class _SymptomSelectorState extends State<SymptomSelector> {
  Set<Symptom> _selectedSymptoms = {};

  List<Symptom>? getSymptomsForDate(DateTime date) {
    final data = DatesSession().getDataForDate(date);
    final value = data["symptoms"];

    if (value is List) {
      return value
          .whereType<String>()
          .map((name) => Symptom.values.firstWhere(
            (e) => e.name == name,
      ))
          .whereType<Symptom>()
          .toList();
    }

    return null;
  }


  @override
  void initState() {
    super.initState();
    _selectedSymptoms = getSymptomsForDate(DatesSession().selectedDate)?.toSet() ?? {};
  }

  DateTime? _lastDate;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: DatesSession().selectedDateNotifier,
      builder: (context, selectedDate, _) {
        final symptomNames = DatesSession().getValueForKey(selectedDate, "symptoms");

        print(symptomNames);

        if (_lastDate != selectedDate) {
          _lastDate = selectedDate;

          if (symptomNames is List) {
            _selectedSymptoms = symptomNames
                .whereType<String>()
                .map((name) => Symptom.values.firstWhere(
                  (e) => e.name == name,
            ))
                .whereType<Symptom>()
                .toSet();
          } else {
            _selectedSymptoms = {};
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 12,
            children: Symptom.values.map((symptom) {
              final isSelected = _selectedSymptoms.contains(symptom);

              String emoji;
              Color color;
              Color textColor;
              switch (symptom) {
                case Symptom.bleeding:
                  emoji = "🩸";
                  color = Colors.redAccent;
                  textColor = Colors.redAccent;
                  break;
                case Symptom.cramps:
                  emoji = "🔄";
                  color = Colors.purple;
                  textColor = Colors.purple;
                  break;
                case Symptom.headache:
                  emoji = "🤕";
                  color = Colors.blue;
                  textColor = Colors.blue;
                  break;
                case Symptom.fatigue:
                  emoji = "😴";
                  color = Colors.blueGrey;
                  textColor = Colors.blueGrey;
                  break;
                case Symptom.bloating:
                  emoji = "🎈";
                  color = Colors.yellow;
                  textColor = Colors.orange;
                  break;
                case Symptom.backPain:
                  emoji = "🔴️";
                  color = Colors.orange;
                  textColor = Colors.red;
                  break;
              }

              String label = symptom.name
                  .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
                  .replaceFirstMapped(RegExp(r'^.'), (m) => m.group(0)!.toUpperCase());

              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSymptoms.remove(symptom);
                    } else {
                      _selectedSymptoms.add(symptom);
                      DatesSession().setEntryForDateKey(selectedDate, "symptoms", _selectedSymptoms.map((e) => e.name).toList());
                    }
                  });

                  SymptomsSession().setSymptoms("symptoms", _selectedSymptoms.map((e) => e.name).toList());
                },
                child: Container(
                  width: 95,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? Border.all(
                      color: color.withValues(alpha: 0.6),
                      width: 2,
                    ) : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? textColor : Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }
    );
  }
}