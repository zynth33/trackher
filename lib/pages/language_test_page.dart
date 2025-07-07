import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/language_service.dart';

class LanguageTestPage extends StatefulWidget {
  const LanguageTestPage({super.key});

  @override
  State<LanguageTestPage> createState() => _LanguageTestPageState();
}

class _LanguageTestPageState extends State<LanguageTestPage> {
  Future<void> _changeLanguage(String languageCode) async {
    await LanguageService().changeLanguage(languageCode);
    
    // Show a success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language changed to $languageCode instantly!'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.customizeExperience,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            ListenableBuilder(
              listenable: LanguageService(),
              builder: (context, _) {
                return Text(
                  'Current Language: ${LanguageService().currentLocale.languageCode}',
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Choose Language:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            
            // Language buttons
            ListenableBuilder(
              listenable: LanguageService(),
              builder: (context, _) {
                final currentLang = LanguageService().currentLocale.languageCode;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _changeLanguage('en'),
                      icon: const Text('🇺🇸'),
                      label: const Text('English'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentLang == 'en' ? Colors.green : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _changeLanguage('es'),
                      icon: const Text('🇪🇸'),
                      label: const Text('Español'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentLang == 'es' ? Colors.green : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _changeLanguage('fr'),
                      icon: const Text('🇫🇷'),
                      label: const Text('Français'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentLang == 'fr' ? Colors.green : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            // Sample translated content
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.periodTracking,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('${l10n.cycleLength}: 28 ${l10n.day}s'),
                    Text('${l10n.periodLength}: 5 ${l10n.day}s'),
                    Text('${l10n.nextPeriod}: In 14 ${l10n.day}s'),
                    const SizedBox(height: 15),
                    
                    Text(
                      l10n.flow,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(label: Text(l10n.light)),
                        Chip(label: Text(l10n.medium)),
                        Chip(label: Text(l10n.heavy)),
                        Chip(label: Text(l10n.spotting)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(l10n.save),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {},
                          child: Text(l10n.cancel),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.journal,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(l10n.addEntry),
                    Text(l10n.recentEntries),
                    Text(l10n.howAreYouFeeling),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: l10n.enterYourThoughts,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
