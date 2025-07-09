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

class AppAssets {
  AppAssets._();

  /// assets/posts
  static const postBirthday = 'assets/posts/post_birthday.png';
  static const postForgotPassword = 'assets/posts/post_key.png';
  static const postEmailVerification = 'assets/posts/post_mail_box.png';
  static const postNoJournalEntries = 'assets/posts/post_no_entries.png';
  static const postNoIrsaChats = 'assets/posts/post_no_chats.png';

  /// assets/icons
  static const iconFlow = 'assets/icons/flow.svg';
  static const iconFlowLight = 'assets/icons/flow_light.svg';
  static const iconFlowMedium = 'assets/icons/flow_light.svg';
  static const iconFlowHeavy = 'assets/icons/flow_light.svg';

  static const iconShare = 'assets/icons/share.svg';
  static const iconWand = 'assets/icons/wand.svg';
  static const iconBulb = 'assets/icons/bulb.svg';
  static const iconSymptom = 'assets/icons/symptom.svg';
  static const iconHeart = 'assets/icons/heart.svg';

  static const iconNavHome = 'assets/icons/nav_home.svg';
  static const iconNavCalender = 'assets/icons/nav_calender.svg';
  static const iconNavJournal = 'assets/icons/nav_journal.svg';
  static const iconNavAiChat = 'assets/icons/nav_ai_chat.svg';

  static const iconAnya = 'assets/avatars/anya.png';
}