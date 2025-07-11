import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trackher/sessions/dates_session.dart';
import '../models/journal_entry.dart';
import '../models/period_log.dart';

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

    final periodLog = PeriodLog(date: date);
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

    await db.update(
      'period_logs',
      {'type': type},
      where: 'date = ? AND flow IS NULL',
      whereArgs: [date],
    );
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
}
