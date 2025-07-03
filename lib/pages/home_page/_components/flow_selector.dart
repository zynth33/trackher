import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

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
            spacing: 10,
            children: FlowLevel.values.where((level) => level != FlowLevel.spotting).map((level) {
              final isSelected = _selected == level;

              String label = level.name[0].toUpperCase() + level.name.substring(1);

              return InkWell(
                onTap: () {
                  setState(() {
                    if (_selected == level) {
                      _selected = null;
                      SymptomsSession().setSymptoms("flow", []);
                      DatesSession().setEntryForDateKey(selectDate, "flow", null);
                    } else {
                      _selected = level;
                      SymptomsSession().setSymptoms("flow", ["$label Flow"]);
                      DatesSession().setEntryForDateKey(selectDate, "flow", _selected!.name);
                    }
                  });
                  _resetInactivityTimer();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  width: 80,
                  decoration: isSelected ? BoxDecoration(
                    color: HexColor.fromHex(AppConstants.primaryPurple).withValues(alpha: 0.54),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.transparent, width: 2),
                  ) : BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.1), width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.black.withValues(alpha: 0.4),
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