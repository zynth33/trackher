import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/journal_entry.dart';

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
      CREATE TABLE journals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        flow TEXT,
        mood TEXT,
        emoji TEXT,
        symptoms TEXT,
        content TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE chat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        question TEXT,
        answer TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        categories TEXT,
        metadata TEXT
      );
    ''');
  }

  Future<int> insertJournal(JournalEntry entry) async {
    final db = await instance.database;
    return await db.insert('journals', {
      'date': entry.date,
      'flow': entry.flow,
      'mood': entry.mood,
      'emoji': entry.emoji,
      'symptoms': jsonEncode(entry.symptoms),
      'content': entry.entry
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteJournalEntry(int id) async {
    final db = await database;
    return await db.delete('journals', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, Object?>>> getRecentJournalEntries() async {
    final db = await instance.database;
    return await db.query(
      'journals',
      orderBy: 'date DESC',
      limit: 3,
    );
  }
}
