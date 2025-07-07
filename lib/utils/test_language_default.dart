import 'package:shared_preferences/shared_preferences.dart';
import '../services/language_service.dart';

/// Test utility to verify and ensure English is the default language
class LanguageDefaultTester {
  
  /// Clear all language preferences (for testing)
  static Future<void> clearLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_language');
  }
  
  /// Test that the default language is English
  static Future<bool> testDefaultLanguage() async {
    // Clear any existing preferences
    await clearLanguagePreferences();
    
    // Initialize the language service
    await LanguageService().loadLanguage();
    
    // Check if it defaults to English
    return LanguageService().currentLocale.languageCode == 'en';
  }
  
  /// Print current language status
  static void printLanguageStatus() {
    print('Current Language: ${LanguageService().currentLocale.languageCode}');
    print('Is Default (English): ${LanguageService().isDefaultLanguage}');
    print('Supported Languages: ${LanguageService().supportedLocales.map((l) => l.languageCode).join(', ')}');
  }
}
