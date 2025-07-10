import 'package:flutter/material.dart';
import '../../../repositories/period_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';
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

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: Symptom.values.map((symptom) {
              final isSelected = _selectedSymptoms.contains(symptom);

              String emoji;
              switch (symptom) {
                case Symptom.bleeding:
                  emoji = "🩸";
                  break;
                case Symptom.cramps:
                  emoji = "🔄";
                  break;
                case Symptom.headache:
                  emoji = "🤕";
                  break;
                case Symptom.fatigue:
                  emoji = "😴";
                  break;
                case Symptom.bloating:
                  emoji = "🎈";
                  break;
                case Symptom.backPain:
                  emoji = "💢";
                  break;
              }

              String label = symptom.name
                  .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
                  .replaceFirstMapped(RegExp(r'^.'), (m) => m.group(0)!.toUpperCase());

              return IntrinsicWidth(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedSymptoms.remove(symptom);
                        updateSymptoms();
                      } else {
                        _selectedSymptoms.add(symptom);
                        DatesSession().setEntryForDateKey(selectedDate, "symptoms", _selectedSymptoms.map((e) => e.name).toList());
                        updateSymptoms();
                      }
                    });

                    SymptomsSession().setSymptoms("symptoms", _selectedSymptoms.map((e) => e.name).toList());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    decoration: isSelected ? BoxDecoration(
                      color: isSelected ? HexColor.fromHex(AppConstants.primaryPurple).withValues(alpha: 0.54) : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 2,
                      ),
                    ) : BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.1),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }
    );
  }

  void updateSymptoms() async {
    final date = DatesSession().selectedDate;

    if (_selectedSymptoms.isEmpty) {
      PeriodRepository().setSymptoms(date, null);
      return;
    }

    final symptomValues = _selectedSymptoms.map((e) => e.name).toList();
    PeriodRepository().setSymptoms(date, symptomValues);
    PeriodRepository().setType();
  }
}
