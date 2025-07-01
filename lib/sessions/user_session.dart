import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;

  UserSession._internal();

  late Color selectedColor;
  late String selectedAvatar;

  Map<String, dynamic> userDetails = {};

  final ValueNotifier<int> anonNotifier = ValueNotifier(0);
  final ValueNotifier<int> userNotifier = ValueNotifier(0);

  late Box _box;

  Future<void> init() async {
    _box = Hive.box('avatarBox');

    // Anonymous avatar state
    final avatarPath = _box.get('selectedAvatar');
    final colorValue = _box.get('selectedColor');
    selectedAvatar = avatarPath is String ? avatarPath : 'assets/avatars/avatar_1.svg';
    selectedColor = (colorValue is int) ? Color(colorValue) : const Color(0xFFFFEBEE);
    anonNotifier.value++;

    // Logged-in user details
    final storedDetails = _box.get('userDetails');
    if (storedDetails is Map) {
      userDetails = Map<String, dynamic>.from(storedDetails);
      userNotifier.value++;
    }
  }

  // Anonymous setters
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

  // User profile setters
  Future<void> setUserDetail(String key, dynamic value) async {
    userDetails[key] = value;
    await _box.put('userDetails', userDetails);
    userNotifier.value++;
  }

  Future<void> setMultipleUserDetails(Map<String, dynamic> details) async {
    userDetails.addAll(details);
    await _box.put('userDetails', userDetails);
    userNotifier.value++;
  }

  // Clear session (logout)
  Future<void> clearSession() async {
    selectedAvatar = 'assets/avatars/avatar_1.svg';
    selectedColor = const Color(0xFFFFEBEE);
    userDetails.clear();
    await _box.delete('selectedAvatar');
    await _box.delete('selectedColor');
    await _box.delete('userDetails');
    anonNotifier.value++;
    userNotifier.value++;
  }

  // Getter helpers
  bool get isLoggedIn => userDetails.isNotEmpty;
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
