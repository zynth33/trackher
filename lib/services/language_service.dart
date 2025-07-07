import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  Locale _currentLocale = const Locale('en');
  
  Locale get currentLocale => _currentLocale;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('selected_language') ?? 'en';
    _currentLocale = Locale(languageCode);
    
    // If no language was previously saved, save English as default
    if (!prefs.containsKey('selected_language')) {
      await prefs.setString('selected_language', 'en');
    }
    
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> resetToDefault() async {
    await changeLanguage('en');
  }

  bool get isDefaultLanguage => _currentLocale.languageCode == 'en';

  List<Locale> get supportedLocales => const [
    Locale('en'), // English - Default language (first in list)
    Locale('es'), // Spanish
    Locale('fr'), // French
  ];
}
