import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;

  UserSession._internal();

  late Color selectedColor;
  late String selectedAvatar;

  final ValueNotifier<int> notifier = ValueNotifier(0);

  Future<void> init() async {
    final box = Hive.box('avatarBox');
    final avatarPath = box.get('selectedAvatar');
    final colorValue = box.get('selectedColor');

    selectedAvatar = avatarPath is String ? avatarPath : 'assets/avatars/avatar_1.svg';
    selectedColor = colorValue is int ? Color(colorValue) : Colors.red.shade50;

    notifier.value++;
  }

  void setAvatar(String avatar) {
    selectedAvatar = avatar;
    Hive.box('avatarBox').put('selectedAvatar', avatar);
    notifier.value++;
  }

  void setColor(Color color) {
    selectedColor = color;
    Hive.box('avatarBox').put('selectedColor', color.value);
    notifier.value++;
  }
}

