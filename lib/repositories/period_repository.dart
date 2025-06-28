import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/journal_entry.dart';
import '../database/database_helper.dart';

class PeriodRepository {
  static final PeriodRepository _instance = PeriodRepository._internal();
  factory PeriodRepository() => _instance;
  PeriodRepository._internal();

  final dbHelper = DatabaseHelper.instance;

  final ValueNotifier<List<JournalEntry>> recentEntriesNotifier = ValueNotifier([]);

  /// Call once during app startup
  Future<void> loadRecentJournalEntries() async {
    final result = await dbHelper.getRecentJournalEntries();

    final entries = result.map((row) => JournalEntry(
      row['emoji']?.toString() ?? '',
      row['date']?.toString() ?? '',
      row['mood']?.toString() ?? '',
      row['content']?.toString() ?? '',
      List<String>.from(jsonDecode(row['symptoms'] as String)),
      row['id'].toString(),
    )).toList();

    recentEntriesNotifier.value = entries;
  }

  Future<int> addJournalEntry(JournalEntry entry) async {
    final insertedId = await dbHelper.insertJournal(entry);

    await loadRecentJournalEntries();

    return insertedId;
  }

  Future<List<JournalEntry>> getRecentJournalEntries() async {
    final result = await dbHelper.getRecentJournalEntries();

    return result.map((row) => JournalEntry(
      row['emoji']?.toString() ?? '',
      row['date']?.toString() ?? '',
      row['mood']?.toString() ?? '',
      row['content']?.toString() ?? '',
      List<String>.from(jsonDecode(row['symptoms'] as String)),
      row['id'].toString(),
    )).toList();
  }
}
