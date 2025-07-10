import 'package:flutter/foundation.dart';

import '../models/journal_entry.dart';
import '../database/database_helper.dart';

class JournalRepository {
  static final JournalRepository _instance = JournalRepository._internal();
  factory JournalRepository() => _instance;
  JournalRepository._internal();

  final dbHelper = DatabaseHelper.instance;

  final ValueNotifier<List<JournalEntry>> recentEntriesNotifier = ValueNotifier([]);

  /// Call once during app startup
  Future<void> loadRecentJournalEntries() async {
    final result = await dbHelper.getRecentJournalEntries();

    final entries = result.map((row) => JournalEntry(
      row['date']?.toString() ?? '',
      row['content']?.toString() ?? '',
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
      row['date']?.toString() ?? '',
      row['content']?.toString() ?? '',
      row['id'].toString(),
    )).toList();
  }

  /// Delete a journal entry by ID
  Future<void> deleteJournalEntry(String id) async {
    await dbHelper.deleteJournalEntry(int.parse(id));
    await loadRecentJournalEntries();
  }
}
