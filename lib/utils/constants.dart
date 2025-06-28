import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../pages/settings_page/_pages/theme_page.dart';
import '../pages/settings_page/_pages/faqs_page.dart';
import '../models/category_item.dart';
import '../models/faq_item.dart';
import '../models/settings_item.dart';
import '../models/chat.dart';
import '../models/quick_question.dart';
import '../models/recent_chat.dart';
import '../services/navigation_service.dart';

import 'enums.dart';

class AppConstants {
  AppConstants._();

  static final _random = Random();

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
          () => navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const ThemePage())),
    ),
    // SettingsItem(
    //     Icon(Symbols.language, color: Colors.black, size: 18,),
    //     "Language",
    //     "Choose your language",
    //         (){}
    // ),
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
            () => navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const FaqsPage())),
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

  static const List<FAQItem> faqs = [
    FAQItem("How do I track my period?", "Go to the Calendar and tap the + button to add period data."),
    FAQItem("How accurate are the predictions?", "Predictions improve over time based on the data you enter."),
    FAQItem("Can I edit past cycle data?", "Yes, go to History > Edit to update past entries."),
    FAQItem("Is my data private and secure?", "Absolutely. We use end-to-end encryption to keep your data safe."),
    FAQItem("How do I set up reminders?", "Go to Settings > Cycle Preferences to customize reminders."),
  ];

  static List<Color> get avatarColors {
    final colors = [
      Colors.blue,
      Colors.pink,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.teal,
      Colors.brown,
    ];
    colors.shuffle(_random);
    return colors;
  }

  static List<String> get avatars {
    final avatarList = [
      'assets/avatars/avatar_1.svg',
      'assets/avatars/avatar_2.svg',
      'assets/avatars/avatar_3.svg',
      'assets/avatars/avatar_4.svg',
      'assets/avatars/avatar_5.svg',
      'assets/avatars/avatar_6.svg',
      'assets/avatars/avatar_7.svg',
      'assets/avatars/avatar_8.svg',
      'assets/avatars/avatar_9.svg',
      'assets/avatars/avatar_10.svg',
      'assets/avatars/avatar_11.svg',
    ];
    avatarList.shuffle(_random);
    return avatarList;
  }
}