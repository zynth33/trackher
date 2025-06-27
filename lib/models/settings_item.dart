import 'package:flutter/material.dart';

class SettingsItem {
  final Icon icon;
  final String title;
  final String subtitle;
  final bool isSwitch;
  final VoidCallback onTap;

  const SettingsItem(this.icon, this.title, this.subtitle, this.onTap,
      {this.isSwitch = false});
}