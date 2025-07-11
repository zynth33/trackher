import 'dart:collection';
import 'package:flutter/material.dart';

class PeriodSession {
  static final PeriodSession _instance = PeriodSession._internal();
  factory PeriodSession() => _instance;

  PeriodSession._internal();

  // ValueNotifiers for reactive state
  final ValueNotifier<int> _oldestYearNotifier = ValueNotifier(2020);
  final ValueNotifier<int> _limitYearNotifier = ValueNotifier(2030);
  final ValueNotifier<int> cycleLengthNotifier = ValueNotifier(28);
  final ValueNotifier<int> _periodLengthNotifier = ValueNotifier(5);

  final ValueNotifier<Set<DateTime>> _fertileDaysNotifier = ValueNotifier({});
  final ValueNotifier<Set<DateTime>> _ovulationDaysNotifier = ValueNotifier({});
  final ValueNotifier<Set<DateTime>> _periodDaysNotifier = ValueNotifier({});
  final ValueNotifier<Set<DateTime>> _pmsDaysNotifier = ValueNotifier({});

  final ValueNotifier<Map<String, List<Map<String, dynamic>>>> _predictionsNotifier = ValueNotifier({});
  final ValueNotifier<Map<DateTime, Map<String, int>>> cycleNumbersNotifier = ValueNotifier({});

  // Setters
  void setOldestYear(int year) {
    _oldestYearNotifier.value = year;
  }

  void setLimitYear(int year) {
    _limitYearNotifier.value = year;
  }

  void setCycleLength(int cycleLength) {
    cycleLengthNotifier.value = cycleLength;
  }

  void setPeriodLength(int periodLength) {
    _periodLengthNotifier.value = periodLength;
  }

  void setPredictions(Map<String, List<Map<String, dynamic>>> predictions) {
    _predictionsNotifier.value = predictions;
  }

  void setFertileDays(Set<DateTime> dates) {
    _fertileDaysNotifier.value = _normalizeDateSet(dates);
  }

  void setOvulationDays(Set<DateTime> dates) {
    _ovulationDaysNotifier.value = _normalizeDateSet(dates);
  }

  void setPeriodDays(Set<DateTime> dates) {
    _periodDaysNotifier.value = _normalizeDateSet(dates);
  }

  void setPmsDays(Set<DateTime> dates) {
    _pmsDaysNotifier.value = _normalizeDateSet(dates);
  }

  void setCycleNumbers(Map<DateTime, Map<String, int>> cycles) {
    cycleNumbersNotifier.value = _normalizeDateMap(cycles);
  }

  void reset() {
    _oldestYearNotifier.value = 2020;
    _limitYearNotifier.value = 2030;
    _fertileDaysNotifier.value = {};
    _ovulationDaysNotifier.value = {};
    _predictionsNotifier.value = {};
    cycleNumbersNotifier.value = {};
    _periodDaysNotifier.value = {};
    _pmsDaysNotifier.value = {};
  }

  // Getters
  int get oldestYear => _oldestYearNotifier.value;
  int get limitYear => _limitYearNotifier.value;

  int get cycleLength => cycleLengthNotifier.value;
  int get periodLength => _periodLengthNotifier.value;

  Map<String, List<Map<String, dynamic>>> get predictions =>
      UnmodifiableMapView(_predictionsNotifier.value);

  Set<DateTime> get fertileDays =>
      UnmodifiableSetView(_fertileDaysNotifier.value);

  Set<DateTime> get ovulationDays =>
      UnmodifiableSetView(_ovulationDaysNotifier.value);

  Set<DateTime> get periodDays =>
      UnmodifiableSetView(_periodDaysNotifier.value);

  Set<DateTime> get pmsDays => UnmodifiableSetView(_pmsDaysNotifier.value);

  Map<DateTime, Map<String, int>> get cycleNumbers =>
      UnmodifiableMapView(cycleNumbersNotifier.value);

  // Internals: Normalization Helpers
  Set<DateTime> _normalizeDateSet(Set<DateTime> input) {
    return input.map((d) => DateTime(d.year, d.month, d.day)).toSet();
  }

  Map<DateTime, Map<String, int>> _normalizeDateMap(Map<DateTime, Map<String, int>> input) {
    return {
      for (var entry in input.entries)
        DateTime(entry.key.year, entry.key.month, entry.key.day): entry.value
    };
  }
}
