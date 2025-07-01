import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../utils/helper_functions.dart';

class DatesSession {
  static final DatesSession _instance = DatesSession._internal();
  factory DatesSession() => _instance;

  DatesSession._internal() {
    _loadFromHive();

    // Sync to Hive whenever dataMapNotifier changes
    _dataMapNotifier.addListener(() {
      _saveToHive();
    });
  }

  final ValueNotifier<DateTime> selectedDateNotifier = ValueNotifier(
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );

  final ValueNotifier<Map<DateTime, Map<String, dynamic>>> _dataMapNotifier = ValueNotifier({});

  // Load from Hive at startup
  Future<void> _loadFromHive() async {
    final box = Hive.box<Map>('datesData');
    final storedMap = <DateTime, Map<String, dynamic>>{};

    for (final key in box.keys) {
      final date = DateTime.tryParse(key);
      final value = box.get(key);
      if (date != null && value is Map) {
        storedMap[date] = Map<String, dynamic>.from(value);
      }
    }

    _dataMapNotifier.value = storedMap;
  }

  // Save to Hive on change
  Future<void> _saveToHive() async {
    final box = Hive.box<Map>('datesData');
    await box.clear();

    for (final entry in _dataMapNotifier.value.entries) {
      final dateKey = entry.key.toIso8601String();
      await box.put(dateKey, entry.value);
    }
  }

  // --- All your methods below remain unchanged ---

  void setDate(DateTime date) {
    selectedDateNotifier.value = normalizeDate(date);
  }

  void setDataForDate(DateTime date, Map<String, dynamic> data) {
    final normalized = normalizeDate(date);
    final current = Map<DateTime, Map<String, dynamic>>.from(_dataMapNotifier.value);
    current[normalized] = data;
    _dataMapNotifier.value = current;
  }

  void setEntryForDateKey(DateTime date, String key, dynamic value) {
    final normalized = normalizeDate(date);
    final current = Map<DateTime, Map<String, dynamic>>.from(_dataMapNotifier.value);
    final dataForDate = Map<String, dynamic>.from(current[normalized] ?? {});
    dataForDate[key] = value;
    current[normalized] = dataForDate;
    _dataMapNotifier.value = current;

    _saveToHive();
  }

  void removeEntryForDateKey(DateTime date, String key) {
    final normalized = normalizeDate(date);
    final current = Map<DateTime, Map<String, dynamic>>.from(_dataMapNotifier.value);
    final dataForDate = Map<String, dynamic>.from(current[normalized] ?? {});
    dataForDate.remove(key);
    current[normalized] = dataForDate;
    _dataMapNotifier.value = current;

    _saveToHive();
  }

  void clearDataForDate(DateTime date) {
    final normalized = normalizeDate(date);
    final current = Map<DateTime, Map<String, dynamic>>.from(_dataMapNotifier.value);
    current.remove(normalized);
    _dataMapNotifier.value = current;
  }

  dynamic getValueForKey(DateTime date, String key) {
    final normalized = normalizeDate(date);
    return _dataMapNotifier.value[normalized]?[key];
  }

  DateTime get selectedDate => selectedDateNotifier.value;

  Map<DateTime, Map<String, dynamic>> get dataMap => _dataMapNotifier.value;

  Map<String, dynamic> getDataForDate(DateTime date) {
    final normalized = normalizeDate(date);
    return _dataMapNotifier.value[normalized] ?? {};
  }

  ValueNotifier<Map<DateTime, Map<String, dynamic>>> get dataMapNotifier =>
      _dataMapNotifier;
}
