import 'package:flutter/material.dart';
import '../utils/enums.dart';

class SettingsSession {
  static final SettingsSession _instance = SettingsSession._internal();
  factory SettingsSession() => _instance;

  SettingsSession._internal();

  // ValueNotifiers for reactive state
  final ValueNotifier<ThemeModeOption> themeModeNotifier = ValueNotifier(ThemeModeOption.light);

  // Setters
  void setTheme(ThemeModeOption theme) {
    themeModeNotifier.value = theme;
  }

  // Getters
  ThemeModeOption get theme => themeModeNotifier.value;
}
