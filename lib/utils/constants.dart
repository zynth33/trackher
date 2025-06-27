import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../models/category_item.dart';
import '../models/settings_item.dart';
import '../models/chat.dart';
import '../models/quick_question.dart';
import '../models/recent_chat.dart';
import 'enums.dart';

class AppConstants {
  AppConstants._();

  static const String graySwatch1 = "#595555";

  static const kCircleSize = 45.0;
  static const kDotSize = 8.0;

  static const List<String> options = [
    "Period",
    "Predicted",
    "Ovulation"
  ];

  static const List<RecentChat> recentChats = [
    RecentChat("Pregnancy Symptoms", "Thank you for the helpful information!"),
    RecentChat("Cycle Tracking", "How often should I check my temperature?"),
    RecentChat("Fertility Signs", "What's the best tracking app? ?")
  ];

  static const List<Chat> chats = [
    Chat("hi", ChatType.user),
    Chat("I'd be happy to help you with \"hi\". This is general guidance and should not replace professional medical advice. Here's what I can tell you about this topic...", ChatType.ai),
    Chat("hi hello", ChatType.user),
    Chat("I'd be happy to help you with \"hi\". This is general guidance and should not replace professional medical advice. Here's what I can tell you about this topic...", ChatType.ai),
    Chat("yes", ChatType.user),
    Chat("I'd be happy to help you with \"hi\". This is general guidance and should not replace professional medical advice. Here's what I can tell you about this topic...", ChatType.ai)
  ];

  static const List<QuickQuestion> quickQuestions = [
    QuickQuestion("💝", "What are early pregnancy symptoms?"),
    QuickQuestion("🌸", "How to track fertility\nsigns?"),
    QuickQuestion("🩸", "Period cycle irregularities?"),
    QuickQuestion("💊", "PMS symptoms\nrelief?")
  ];

  static List<SettingsItem> accountSettings = [
    SettingsItem(
        Icon(Symbols.person, color: Colors.black, size: 18,),
        "Profile Settings",
        "Update your personal information",
            (){}
    ),
    SettingsItem(
        Icon(Symbols.calendar_today, color: Colors.black, size: 18,),
        "Cycle Preferences",
        "Customize your tracking settings",
            (){}
    ),
    SettingsItem(
        Icon(Symbols.border_color_rounded, color: Colors.black, size: 18,),
        "Data Export",
        "Download your health data",
            (){}
    ),
  ];

  static List<SettingsItem> appearanceSettings = [
    SettingsItem(
        Icon(Symbols.palette_rounded, color: Colors.black, size: 18,),
        "Theme",
        "Light or dark mode",
            (){}
    ),
    SettingsItem(
        Icon(Symbols.language, color: Colors.black, size: 18,),
        "Language",
        "Choose your language",
            (){}
    ),
  ];

  static List<SettingsItem> notificationsSettings = [
    SettingsItem(
        Icon(Symbols.notifications_rounded, color: Colors.black, size: 18,),
        "Push Notifications",
        "Receive period reminders",
        isSwitch: true,
            (){}
    ),
    SettingsItem(
        Icon(Symbols.dark_mode_rounded, color: Colors.black, size: 18,),
        "Do Not Disturb",
        "Quiet hours 10 PM - 8 AM",
        isSwitch: true,
            (){}
    ),
    SettingsItem(
        Icon(Symbols.volume_up_rounded, color: Colors.black, size: 18,),
        "Sound Effects",
        "App interaction sounds",
        isSwitch: true,
            (){}
    ),
  ];

  static List<SettingsItem> privacyAndSecuritySettings = [
    SettingsItem(
        Icon(Symbols.shield_rounded, color: Colors.black, size: 18,),
        "Data Privacy",
        "Control your data sharing",
            (){}
    ),
    SettingsItem(
        Icon(Symbols.database_rounded, color: Colors.black, size: 18,),
        "Backup & Sync",
        "Cloud data backup",
        isSwitch: true,
            (){}
    ),
  ];

  static List<SettingsItem> supportSettings = [
    SettingsItem(
        Icon(Symbols.help, color: Colors.black, size: 18,),
        "Help Center",
        "FAQs and support articles",
            (){}
    ),
  ];

  static const List<CategoryItem> categoryMood = [
    CategoryItem("😌", "Calm"),
    CategoryItem("😟", "Depressed"),
    CategoryItem("😰", "Anxious"),
    CategoryItem("🫩", "Low Energy"),
    CategoryItem("😥", "Mood Swings"),
  ];

  static const List<CategoryItem> categoryDigestion = [
    CategoryItem("🤢", "Nausea"),
    CategoryItem("🎈", "Bloating"),
    CategoryItem("💩", "Constipation"),
    CategoryItem("🧻", "Diarrhea"),
  ];

  static const List<CategoryItem> categorySymptoms = [
    CategoryItem("😖", "Cramps"),
    CategoryItem("🤕", "Headache"),
    CategoryItem("😩", "Fatigue"),
    CategoryItem("🤢", "Abdominal Pain"),
    CategoryItem("🍔", "Cravings"),
  ];

  static const List<CategoryItem> categoryOther = [
    CategoryItem("✈️", "Travel"),
    CategoryItem("📓", "Journaling"),
    CategoryItem("🍑", "Kegel Exercises"),
    CategoryItem("🤒", "Disease or injury"),
    CategoryItem("🧘", "Meditation"),
  ];
}