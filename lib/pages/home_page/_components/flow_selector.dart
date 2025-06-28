import 'dart:async';

import 'package:flutter/material.dart';

import '../../../sessions/dates_session.dart';
import '../../../sessions/period_session.dart';
import '../../../sessions/symptoms_session.dart';
import '../../../utils/enums.dart';

class FlowSelector extends StatefulWidget {
  const FlowSelector({super.key});

  @override
  State<FlowSelector> createState() => _FlowSelectorState();
}

class _FlowSelectorState extends State<FlowSelector> {
  FlowLevel? _selected;
  Timer? _inactivityTimer;

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 3), () {
      updatePeriods();
    });
  }

  FlowLevel? getFlowForDate(DateTime date) {
    final data = DatesSession().getDataForDate(date);
    final value = data["flow"];

    if (value is String) {
      return FlowLevel.values.firstWhere(
          (e) => e.name == value,
      );
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _selected = getFlowForDate(DatesSession().selectedDate);
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  DateTime? _lastDate;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: DatesSession().selectedDateNotifier,
      builder: (context, selectDate, _) {
        final flowName = DatesSession().getValueForKey(selectDate, "flow");

        if (_lastDate != selectDate) {
          _lastDate = selectDate;

          final flowName = DatesSession().getValueForKey(selectDate, "flow");
          _selected = FlowLevel.values.any((e) => e.name == flowName)
            ? FlowLevel.values.firstWhere((e) => e.name == flowName)
            : null;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: FlowLevel.values.map((level) {
              final isSelected = _selected == level;

              Color dotColor;
              switch (level) {
                case FlowLevel.light:
                  dotColor = Colors.pink.withValues(alpha: 0.3);
                  break;
                case FlowLevel.medium:
                  dotColor = Colors.pink.withValues(alpha: 0.7);
                  break;
                case FlowLevel.heavy:
                  dotColor = Colors.pink;
                  break;
                case FlowLevel.spotting:
                  dotColor = Colors.orangeAccent;
                  break;
              }

              String label = level.name[0].toUpperCase() + level.name.substring(1);

              return InkWell(
                onTap: () {
                  setState(() {
                    if (_selected == level) {
                      _selected = null;
                      SymptomsSession().setSymptoms("flow", []);
                    } else {
                      _selected = level;
                      SymptomsSession().setSymptoms("flow", ["$label Flow"]);
                      DatesSession().setEntryForDateKey(selectDate, "flow", _selected!.name);
                    }
                  });
                  _resetInactivityTimer();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: 85,
                  decoration: isSelected ? BoxDecoration(
                    color: dotColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: dotColor.withValues(alpha: 0.4), width: 2),
                  ) : null,
                  child: Column(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: dotColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.red : Colors.grey,
                          fontWeight: FontWeight.normal,
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
    );
  }

  void updatePeriods() {
    if (_selected == null) return;

    final date = DatesSession().selectedDate;
    final session = PeriodSession();

    final periodDays = {...session.periodDays};
    final fertileDays = {...session.fertileDays};
    final ovulationDays = {...session.ovulationDays};
    final pmsDays = {...session.pmsDays};

    periodDays.add(date);

    fertileDays.remove(date);
    ovulationDays.remove(date);
    pmsDays.remove(date);

    session.setPeriodDays(periodDays);
    session.setFertileDays(fertileDays);
    session.setOvulationDays(ovulationDays);
    session.setPmsDays(pmsDays);

    DatesSession().setEntryForDateKey(date, "flow", _selected!.name);
  }
}