import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trackher/sessions/dates_session.dart';
import 'package:trackher/sessions/period_session.dart';

import '../models/period_log.dart';
import '../database/database_helper.dart';

class PeriodRepository {
  static final PeriodRepository _instance = PeriodRepository._internal();
  factory PeriodRepository() => _instance;
  PeriodRepository._internal();

  final dbHelper = DatabaseHelper.instance;

  final ValueNotifier<List<PeriodLog>> periodLogsNotifier = ValueNotifier([]);

  /// Set Flow in period log
  Future<void> setFlow(DateTime date, String? newFlow) async {
    final id = await dbHelper.ensurePeriodLogExists(normalizeDate(date).toString());
    await dbHelper.updateFlow(id, newFlow);
  }

  /// Set Mood in period log
  Future<void> setMood(DateTime date, String? mood) async {
    final id = await dbHelper.ensurePeriodLogExists(normalizeDate(date).toString());
    await dbHelper.updateMood(id, mood);
  }

  /// Set Symptoms in period log
  Future<void> setSymptoms(DateTime date, List<String>? symptoms) async {
    final id = await dbHelper.ensurePeriodLogExists(normalizeDate(date).toString());
    await dbHelper.updateSymptoms(id, symptoms);
  }

  /// Set Day Type in period log
  Future<void> setType({String? type}) async {
    final date = normalizeDate(DatesSession().selectedDate);

    // Use provided type, or determine from session
    final resolvedType = type ??
      () {
        final session = PeriodSession();
        final dayTypeMap = {
          'period': session.periodDays,
          'fertile': session.fertileDays,
          'ovulation': session.ovulationDays,
          'pms': session.pmsDays,
        };

        return dayTypeMap.entries
            .firstWhere(
              (entry) => entry.value.contains(date),
          orElse: () => const MapEntry('normal', {}),
        ).key;
      }();

    await dbHelper.updateType(date.toString(), resolvedType);
  }

  /// Set Symptoms in period log
  Future<void> setCategories(List<String> categories) async {
    await dbHelper.insertCategories(categories);
  }
}
