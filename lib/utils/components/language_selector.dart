import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelector extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  
  const LanguageSelector({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selected_language') ?? 'en';
    });
  }

  Future<void> _saveSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String languageCode) async {
        setState(() {
          selectedLanguage = languageCode;
        });
        await _saveSelectedLanguage(languageCode);
        widget.onLanguageChanged(Locale(languageCode));
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'en',
            child: Row(
              children: [
                const Text('🇺🇸'),
                const SizedBox(width: 8),
                const Text('English'),
                if (selectedLanguage == 'en') 
                  const Icon(Icons.check, color: Colors.green),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'es',
            child: Row(
              children: [
                const Text('🇪🇸'),
                const SizedBox(width: 8),
                const Text('Español'),
                if (selectedLanguage == 'es') 
                  const Icon(Icons.check, color: Colors.green),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'fr',
            child: Row(
              children: [
                const Text('🇫🇷'),
                const SizedBox(width: 8),
                const Text('Français'),
                if (selectedLanguage == 'fr') 
                  const Icon(Icons.check, color: Colors.green),
              ],
            ),
          ),
        ];
      },
    );
  }
}
