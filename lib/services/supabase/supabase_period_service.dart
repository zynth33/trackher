import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../sessions/dates_session.dart';
import '../../database/database_helper.dart';
import '../../sessions/user_session.dart';

class SupabasePeriodService {
  static final SupabasePeriodService _instance = SupabasePeriodService._internal();
  factory SupabasePeriodService() => _instance;
  SupabasePeriodService._internal();

  final _supabase = Supabase.instance.client;

  Future<Map<String, String>> fetchCategoryEmojis() async {
    final response = await _supabase
        .from('categories')
        .select('name, emoji');

    return {
      for (final item in response)
        if (item['name'] != null && item['emoji'] != null)
          item['name'] as String: item['emoji'] as String
    };
  }
}

