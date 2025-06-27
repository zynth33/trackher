import 'dart:collection';
import 'package:flutter/material.dart';

class SymptomsSession {
  static final SymptomsSession _instance = SymptomsSession._internal();
  factory SymptomsSession() => _instance;

  SymptomsSession._internal();

  // ValueNotifiers for reactive state
  final ValueNotifier<Map<String, List<String>>> _symptomsNotifier = ValueNotifier({});
  final ValueNotifier<DateTime> _dateNotifier = ValueNotifier(DateTime.now());
 
  // Setters
  void setSymptoms(String key, List<String> values) {
    final current = Map<String, List<String>>.from(_symptomsNotifier.value);
    current[key] = values;
    _symptomsNotifier.value = current;
  }

  void setDate(DateTime date) {
    _dateNotifier.value = _normalizeDate(date);
  }

  // Getters
  Map<String, List<String>> get symptoms => UnmodifiableMapView(_symptomsNotifier.value);
  DateTime get date => _normalizeDate(_dateNotifier.value);

  DateTime _normalizeDate(DateTime input) {
    return DateTime(input.year, input.month, input.day);
  }
}
