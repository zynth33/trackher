import 'package:flutter/material.dart';
import '../../pages/language_test_page.dart';
import '../../services/language_service.dart';

class GlobalLanguageSwitcher extends StatelessWidget {
  const GlobalLanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        final currentLang = LanguageService().currentLocale.languageCode;
        String flag = '🇺🇸';
        
        switch (currentLang) {
          case 'es':
            flag = '🇪🇸';
            break;
          case 'fr':
            flag = '🇫🇷';
            break;
          default:
            flag = '🇺🇸';
        }
        
        return FloatingActionButton.small(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LanguageTestPage()),
            );
          },
          backgroundColor: Colors.deepPurple,
          child: Text(
            flag,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}
