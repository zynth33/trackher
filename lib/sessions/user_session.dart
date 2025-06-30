import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;

  UserSession._internal();

  // Anonymous avatar-related state
  late Color selectedColor;
  late String selectedAvatar;

  // User-specific profile data
  Map<String, dynamic> userDetails = {};

  // Notifiers
  final ValueNotifier<int> anonNotifier = ValueNotifier(0);
  final ValueNotifier<int> userNotifier = ValueNotifier(0);

  Future<void> init() async {
    final box = Hive.box('avatarBox');

    // Anonymous fallback
    final avatarPath = box.get('selectedAvatar');
    final colorValue = box.get('selectedColor');
    selectedAvatar = avatarPath is String ? avatarPath : 'assets/avatars/avatar_1.svg';
    selectedColor = colorValue is int ? Color(colorValue) : Colors.red.shade50;
    anonNotifier.value++;

    // Logged-in user details
    final storedDetails = box.get('userDetails');
    if (storedDetails is Map) {
      userDetails = Map<String, dynamic>.from(storedDetails);
      userNotifier.value++;
    }
  }

  // Anonymous setters
  void setAvatar(String avatar) {
    selectedAvatar = avatar;
    Hive.box('avatarBox').put('selectedAvatar', avatar);
    anonNotifier.value++;
  }

  void setColor(Color color) {
    selectedColor = color;
    Hive.box('avatarBox').put('selectedColor', color.value);
    anonNotifier.value++;
  }

  // User profile setters
  void setUserDetail(String key, dynamic value) {
    userDetails[key] = value;
    Hive.box('avatarBox').put('userDetails', userDetails);
    userNotifier.value++;
  }

  void setMultipleUserDetails(Map<String, dynamic> details) {
    userDetails.addAll(details);
    Hive.box('avatarBox').put('userDetails', userDetails);
    userNotifier.value++;
  }

  // Getter helpers (optional)
  bool get isLoggedIn => userDetails.isNotEmpty;
  String? get name => userDetails['name'] as String?;
  String? get email => userDetails['email'] as String?;
  String? get profileImageUrl => userDetails['profileImageUrl'] as String?;
  DateTime? get dateOfBirth => userDetails['dateOfBirth'] is String
      ? DateTime.tryParse(userDetails['dateOfBirth'])
      : userDetails['dateOfBirth'] as DateTime?;
}
