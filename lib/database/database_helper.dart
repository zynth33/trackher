import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trackher/services/supabase/supabase_period_service.dart';
import 'package:trackher/sessions/dates_session.dart';
import 'package:trackher/sessions/period_session.dart';
import 'package:trackher/utils/extensions/string.dart';
import '../models/journal_entry.dart';
import '../models/period_log.dart';
import '../utils/helper_functions.dart';

class DatabaseHelper {
  static const _databaseName = "PeriodsDatabase.db";
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, _databaseName);
    return await openDatabase(
        dbPath,
        version: _databaseVersion,
        onConfigure: (Database db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
    /// Tables
    await db.execute('''
      CREATE TABLE period_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        flow TEXT,
        mood TEXT,
        symptoms TEXT,
        type TEXT CHECK(type IN ('period', 'pms', 'ovulation', 'fertile', 'normal')),
        cycle_day_number TEXT,
        cycle_number TEXT,
        created_at TEXT DEFAULT (datetime('now')),
        updated_at TEXT DEFAULT (datetime('now'))
      );
    ''');

    await db.execute('''
      CREATE TABLE journals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        content TEXT,
        period_log_id INTEGER,
        created_at TEXT DEFAULT (datetime('now')),
        updated_at TEXT DEFAULT (datetime('now')),
        FOREIGN KEY (period_log_id) REFERENCES period_logs(id) ON DELETE SET NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE chats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        question TEXT,
        answer TEXT,
        period_log_id INTEGER,
        created_at TEXT DEFAULT (datetime('now')),
        updated_at TEXT DEFAULT (datetime('now')),
        FOREIGN KEY (period_log_id) REFERENCES period_logs(id) ON DELETE SET NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        categories TEXT,
        metadata TEXT,
        period_log_id INTEGER,
        created_at TEXT DEFAULT (datetime('now')),
        updated_at TEXT DEFAULT (datetime('now')),
        FOREIGN KEY (period_log_id) REFERENCES period_logs(id) ON DELETE SET NULL
      );
    ''');
  }

  /// CRUD Operation for Table: period_logs
  Future<int> insertPeriodLog(PeriodLog periodLog) async {
    final db = await database;

    int periodLogId = await db.insert('period_logs', periodLog.toMap());

    List<String> relatedTables = ['journals', 'chats', 'categories'];

    for (String table in relatedTables) {
      await db.update(
        table,
        {'period_log_id': periodLogId},
        where: 'date = ? AND period_log_id IS NULL',
        whereArgs: [periodLog.date],
      );
    }

    return periodLogId;
  }
  Future<int> ensurePeriodLogExists(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'period_logs',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return results.first['id'] as int;
    }


    final mapEntry = getValueForDateInMap(DateTime.now(), PeriodSession().cycleNumbers);
    final currentDay = mapEntry is Map<String, int> ? mapEntry['cycleDay'] ?? 0 : 0;
    final cycleNumber = mapEntry is Map<String, int> ? mapEntry['cycleNumber'] ?? 0 : 0;

    final periodLog = PeriodLog(date: date, cycleDayNumber: currentDay.toString(), cycleNumber: cycleNumber.toString());
    return await insertPeriodLog(periodLog);
  }
  Future<void> updateFlow(int id, String? flow) async {
    final db = await database;

    await db.update(
      'period_logs',
      {'flow': flow},
      where: 'id = ?',
      whereArgs: [id],
    );

    // Get date for this period log
    final result = await db.query(
      'period_logs',
      columns: ['date'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      final date = result.first['date'] as String;
      await _updateForeignKeyReferences(id, date);
    }
  }
  Future<void> updateMood(int id, String? mood) async {
    final db = await database;

    await db.update(
      'period_logs',
      {'mood': mood},
      where: 'id = ?',
      whereArgs: [id],
    );

    final result = await db.query(
      'period_logs',
      columns: ['date'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      final date = result.first['date'] as String;
      await _updateForeignKeyReferences(id, date);
    }

    bulkInfo();
  }
  Future<void> updateSymptoms(int id, List<String>? symptoms) async {
    final db = await database;

    await db.update(
      'period_logs',
      {'symptoms': symptoms != null ? json.encode(symptoms) : null},
      where: 'id = ?',
      whereArgs: [id],
    );

    final result = await db.query(
      'period_logs',
      columns: ['date'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      final date = result.first['date'] as String;
      await _updateForeignKeyReferences(id, date);
    }
  }
  Future<void> updateType(String date, String? type) async {
    final db = await database;

    print("Type: $type");

    if(type == "period") {
      await db.update(
        'period_logs',
        {'type': type},
        where: 'date = ?',
        whereArgs: [date],
      );
    } else {
      await db.update(
        'period_logs',
        {'type': type},
        where: 'date = ? AND flow IS NULL',
        whereArgs: [date],
      );
    }
  }


  /// CRUD Operation for Table: journals
  Future<int> insertJournal(JournalEntry entry) async {
    final db = await instance.database;

    // Try to find a matching period_log by date
    final result = await db.query(
      'period_logs',
      columns: ['id'],
      where: 'date = ?',
      whereArgs: [entry.date],
      limit: 1,
    );

    int? periodLogId;
    if (result.isNotEmpty) {
      periodLogId = result.first['id'] as int;
    }

    return await db.insert(
      'journals',
      {
        'date': entry.date,
        'content': entry.entry,
        'period_log_id': periodLogId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<int> deleteJournalEntry(int id) async {
    final db = await database;
    return await db.delete('journals', where: 'id = ?', whereArgs: [id]);
  }
  Future<List<Map<String, Object?>>> getRecentJournalEntries() async {
    final db = await instance.database;
    return await db.query(
      'journals',
      orderBy: 'created_at DESC',
      limit: 10,
    );
  }


  /// CRUD Operation for Table: categories
  Future<int> insertCategories(List<String> categories) async {
    final db = await instance.database;
    final date = DatesSession().selectedDate.toString();

    final existing = await db.query(
      'categories',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (existing.isNotEmpty) {
      return await db.update(
        'categories',
        {'categories': json.encode(categories)},
        where: 'date = ?',
        whereArgs: [date],
      );
    } else {
      return await db.insert('categories', {
        'date': date,
        'categories': json.encode(categories),
      });
    }
  }


  /// BULK Info
  void bulkInfo() async {
    final totalLoggedCycles = await _getTotalLoggedCycles();
    final mostCommonSymptom = await _getMostFrequentSymptom();
    final mostCommonMood = await _getMostFrequentMood();
    final moodDistribution = await _getMoodDistribution();
    final top3Symptoms = await _getTop3Symptoms();
    final symptomLogs = await _getSymptomLogs();
    final moodLogs = await _getMoodLogs();
    print(totalLoggedCycles);
    print(mostCommonSymptom);
    print(mostCommonMood);
    print(moodDistribution);
    print(top3Symptoms);
    print(symptomLogs);
    print(moodLogs);
  }


  /// helpers
  Future<void> _updateForeignKeyReferences(int periodLogId, String date) async {
    final db = await database;
    final tables = ['journals', 'chats', 'categories'];

    for (String table in tables) {
      await db.update(
        table,
        {'period_log_id': periodLogId},
        where: 'date = ? AND period_log_id IS NULL',
        whereArgs: [date],
      );
    }
  }
  Future<String> _getTotalLoggedCycles() async {
    final db = await database;

    final result = await db.rawQuery('SELECT COUNT(DISTINCT cycle_number) as count FROM period_logs');
    return Sqflite.firstIntValue(result).toString();
  }
  Future<String?> _getMostFrequentSymptom() async {
    final db = await database;
    final result = await db.rawQuery('SELECT symptoms FROM period_logs');

    final Map<String, int> symptomCounts = {};

    for (final row in result) {
      final raw = row['symptoms'] as String?;
      if (raw == null || raw.isEmpty) continue;

      try {
        final List<dynamic> symptoms = json.decode(raw);
        for (final symptom in symptoms) {
          if (symptom is String) {
            symptomCounts[symptom] = (symptomCounts[symptom] ?? 0) + 1;
          }
        }
      } catch (_) {
        // Skip if json.decode fails
        continue;
      }
    }

    if (symptomCounts.isEmpty) return null;

    // Get the most frequent symptom
    final sorted = symptomCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }
  Future<String?> _getMostFrequentMood() async {
    final db = await database;
    final result = await db.rawQuery('SELECT mood FROM period_logs');

    final Map<String, int> moodCounts = {};

    for (final row in result) {
      final mood = row['mood'] as String?;
      if (mood == null || mood.isEmpty) continue;

      moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
    }

    if (moodCounts.isEmpty) return null;

    final sorted = moodCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }
  Future<Map<String, num>> _getMoodDistribution() async {
    final db = await database;
    final result = await db.rawQuery('SELECT mood FROM period_logs');

    final Map<String, int> moodCounts = {};
    int total = 0;

    for (final row in result) {
      final mood = row['mood'] as String?;
      if (mood == null || mood.isEmpty) continue;

      moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
      total++;
    }

    if (total == 0) return {};

    final Map<String, num> distribution = {};

    moodCounts.forEach((mood, count) {
      final percent = (count / total) * 100;
      distribution[mood] = percent % 1 == 0
          ? percent.toInt()
          : double.parse(percent.toStringAsFixed(1));
    });

    return distribution;
  }
  Future<List<Map<String, dynamic>>> _getTop3Symptoms() async {
    final db = await database;
    final result = await db.rawQuery('SELECT symptoms FROM period_logs');

    final Map<String, int> symptomCounts = {};

    for (final row in result) {
      final raw = row['symptoms'] as String?;
      if (raw == null || raw.isEmpty) continue;

      try {
        final List<dynamic> symptoms = json.decode(raw);
        for (final symptom in symptoms) {
          if (symptom is String) {
            symptomCounts[symptom] = (symptomCounts[symptom] ?? 0) + 1;
          }
        }
      } catch (_) {
        // skip malformed entries
        continue;
      }
    }

    // Sort and get top 3
    final top3 = symptomCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return top3.take(3).map((entry) {
      return {
        'symptom': entry.key,
        'count': entry.value,
        'label': '${entry.value} times',
      };
    }).toList();
  }
  Future<List<Map<String, String>>> _getSymptomLogs() async {
    final categoryEmojis = await SupabasePeriodService().fetchCategoryEmojis();

    final db = await database;
    final result = await db.rawQuery('SELECT date, symptoms FROM period_logs');
    final DateFormat formatter = DateFormat('MMM d, yyyy');

    final List<Map<String, String>> logs = [];

    for (final row in result) {
      final rawDate = row['date'];
      final rawSymptoms = row['symptoms'] as String?;

      if (rawDate == null || rawSymptoms == null || rawSymptoms.isEmpty) continue;

      try {
        final DateTime date = DateTime.parse(rawDate.toString());
        final List<dynamic> symptomsList = json.decode(rawSymptoms);

        final formattedSymptoms = symptomsList
            .whereType<String>()
            .map((s) => '${categoryEmojis[s.toSentenceCase()] ?? ''} ${s.toSentenceCase()}')
            .join(', ');

        logs.add({
          'date': formatter.format(date),
          'symptoms': formattedSymptoms,
        });
      } catch (_) {
        continue;
      }
    }

    return logs;
  }
  Future<List<Map<String, String>>> _getMoodLogs() async {
    final categoryEmojis = await SupabasePeriodService().fetchCategoryEmojis();

    final db = await database;
    final result = await db.rawQuery('SELECT date, mood FROM period_logs');
    final DateFormat formatter = DateFormat('MMM d, yyyy');

    final List<Map<String, String>> logs = [];

    for (final row in result) {
      final rawDate = row['date'];
      final rawMood = row['mood'] as String?;

      if (rawDate == null || rawMood == null || rawMood.isEmpty) continue;

      try {
        final DateTime date = DateTime.parse(rawDate.toString());
        final mood = rawMood.toSentenceCase();
        final emoji = categoryEmojis[mood] ?? '';

        logs.add({
          'date': formatter.format(date),
          'mood': '$emoji ${mood.toSentenceCase()}',
        });
      } catch (_) {
        continue;
      }
    }

    return logs;
  }

}
