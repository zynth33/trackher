import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../sessions/dates_session.dart';
import '../../database/database_helper.dart';
import '../../sessions/user_session.dart';

class SupabaseSyncService {
  static final SupabaseSyncService _instance = SupabaseSyncService._internal();
  factory SupabaseSyncService() => _instance;
  SupabaseSyncService._internal();

  final _supabase = Supabase.instance.client;

  Future<void> syncLocalDataToSupabase() async {
    final db = await DatabaseHelper.instance.database;
    final userId = UserSession().id;

    if (userId == null) {
      throw Exception('User not signed in');
    }

    // Helper to attach user_id and upsert
    Future<void> upsertWithUserId(String table, List<Map<String, dynamic>> rows) async {
      for (final row in rows) {
        final data = Map<String, dynamic>.from(row)..['user_id'] = userId;
        await _supabase.from(table).upsert(data);
      }
    }

    // period_logs
    final periodLogs = await db.query('period_logs');
    await upsertWithUserId('period_logs', periodLogs);

    // journals
    final journals = await db.query('journals');
    await upsertWithUserId('journals', journals);

    // chats
    final chats = await db.query('chats');
    await upsertWithUserId('chats', chats);

    //categories
    await syncSelectedCategories();
  }

  Future<void> syncSelectedCategories() async {
    final db = await DatabaseHelper.instance.database;
    final userId = UserSession().id;
    final categories = await db.query('categories');

    final allCategories = await _supabase.from('categories').select('id, name');

    final nameToId = {
      for (final cat in allCategories)
        cat['name'] as String: cat['id'] as int
    };

    for (final category in categories) {
      final categoryList = jsonDecode(category['categories'].toString());

      if (categoryList is List) {
        for (final c in categoryList) {
          final catId = nameToId[c];
          if (catId != null) {
            await _supabase.from('selected_categories').upsert({
              'user_id': userId,
              'category_id': catId,
              'date': DatesSession().selectedDate.toString()
            });
          }
        }
      }
    }
  }
}

