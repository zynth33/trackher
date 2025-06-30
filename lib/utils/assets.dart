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
  static const postForgotPassword = 'assets/posts/post_forgot_password.png';
  static const postEmailVerification = 'assets/posts/post_email_verification.png';

  /// assets/icons
  static const iconFlowLight = 'assets/icons/flow_light.svg';
  static const iconFlowMedium = 'assets/icons/flow_light.svg';
  static const iconFlowHeavy = 'assets/icons/flow_light.svg';
  static const iconShare = 'assets/icons/share.svg';
}