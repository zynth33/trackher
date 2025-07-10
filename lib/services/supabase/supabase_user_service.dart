import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../database/database_helper.dart';

class SupabaseUserService {
  static final SupabaseUserService _instance = SupabaseUserService._internal();
  factory SupabaseUserService() => _instance;
  SupabaseUserService._internal();

  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('id', uid)
        .maybeSingle();

    return response != null
        ? Map<String, dynamic>.from(response)
        : null;
  }

  Future<void> createUserProfile(Map<String, dynamic> data) async {
    await _supabase.from('users').insert(data);
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _supabase.from('users').update(data).eq('id', uid);
  }

  Future<void> updateSingleField(String uid, String key, dynamic value) async {
    await _supabase.from('users').update({key: value}).eq('id', uid);
  }

  Future<String> uploadProfilePicture(String uid, File imageFile) async {
    final filePath = '$uid/$uid.png';

    await _supabase.storage.from('profile-pics').upload(
      filePath,
      imageFile,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
    );

    final signedUrlResponse = await _supabase.storage
        .from('profile-pics')
        .createSignedUrl(filePath, 604800);

    await updateSingleField(uid, "profile_pic_url", signedUrlResponse);

    return signedUrlResponse;
  }
}

