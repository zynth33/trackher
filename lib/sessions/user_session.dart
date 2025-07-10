import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../services/firebase/firebase_sync_service.dart';
import '../services/supabase/supabase_user_service.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  late Color selectedColor;
  late String selectedAvatar;
  final ValueNotifier<int> anonNotifier = ValueNotifier(0);

  Map<String, dynamic> userDetails = {};
  final ValueNotifier<int> userNotifier = ValueNotifier(0);
  final ValueNotifier<String> userIdNotifier = ValueNotifier("");

  late Box _box;
  final _userService = SupabaseUserService();
  final _firebaseSyncService = FirebaseSyncService();

  Future<void> init() async {
    _box = Hive.box('avatarBox');

    final avatarPath = _box.get('selectedAvatar');
    final colorValue = _box.get('selectedColor');
    selectedAvatar = (avatarPath is String)
        ? avatarPath
        : 'assets/avatars/avatar_1.svg';
    selectedColor = (colorValue is int)
        ? Color(colorValue)
        : const Color(0xFFFFEBEE);
    anonNotifier.value++;

    final firebaseUid = _box.get('firebaseUid');
    if (firebaseUid is String && firebaseUid.isNotEmpty) {
      userIdNotifier.value = firebaseUid;

      final storedDetails = _box.get('userDetails');
      if (storedDetails is Map<String, dynamic>) {
        userDetails = Map<String, dynamic>.from(storedDetails);
        userNotifier.value++;
      } else {
        try {
          final profile = await _userService.getUserProfile(firebaseUid);
          if (profile != null) {
            userDetails = profile;
            await _box.put('userDetails', userDetails);
            userNotifier.value++;
          }
        } catch (e) {
          debugPrint("Supabase fetch failed: $e");
        }
      }
    }
  }

  Future<void> registerFirebaseUid(String uid) async {
    userIdNotifier.value = uid;
    await _box.put('firebaseUid', uid);
    userNotifier.value++;
  }

  Future<void> syncPeriodData() async {
    final uid = userIdNotifier.value;
    await _firebaseSyncService.syncUserPeriodData();
  }

  Future<void> setAvatar(String avatar) async {
    selectedAvatar = avatar;
    await _box.put('selectedAvatar', avatar);
    anonNotifier.value++;
  }

  Future<void> setColor(Color color) async {
    selectedColor = color;
    await _box.put('selectedColor', color.toARGB32());
    anonNotifier.value++;
  }

  Future<void> setUserId(String id) async {
    userIdNotifier.value = id;
    userNotifier.value++;
  }

  Future<void> setUserDetail(String key, dynamic value) async {
    final uid = userIdNotifier.value;
    if (uid.isEmpty) throw Exception('User not initialized');

    userDetails[key] = value;
    await _box.put('userDetails', userDetails);
    userNotifier.value++;

    try {
      await _userService.updateSingleField(uid, key, value);
    } catch (e) {
      debugPrint('Supabase update error: $e');
    }
  }

  Future<void> setMultipleUserDetails(Map<String, dynamic> details) async {
    final uid = userIdNotifier.value;
    if (uid.isEmpty) throw Exception('User not initialized');

    userDetails.addAll(details);
    await _box.put('userDetails', userDetails);
    userNotifier.value++;
  }

  Future<void> clearSession() async {
    selectedAvatar = 'assets/avatars/avatar_1.svg';
    selectedColor = const Color(0xFFFFEBEE);
    userDetails.clear();
    userIdNotifier.value = "";

    await _box.delete('selectedAvatar');
    await _box.delete('selectedColor');
    await _box.delete('userDetails');
    await _box.delete('firebaseUid');

    anonNotifier.value++;
    userNotifier.value++;
  }

  bool get isLoggedIn => userDetails.isNotEmpty;
  String? get id => userIdNotifier.value.toString();
  String? get name => userDetails['name']?.toString();
  String? get email => userDetails['email']?.toString();
  String? get profileImageUrl => userDetails['profileImageUrl']?.toString();
  DateTime? get dateOfBirth {
    final dob = userDetails['dateOfBirth'];
    if (dob is DateTime) return dob;
    if (dob is String) return DateTime.tryParse(dob);
    return null;
  }
}
