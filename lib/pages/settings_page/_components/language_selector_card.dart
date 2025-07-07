import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../services/language_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';

class LanguageSelectorCard extends StatelessWidget {
  const LanguageSelectorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: HexColor.fromHex(AppConstants.secondaryBackgroundLight),
                ),
                child: Icon(
                  Icons.language,
                  color: HexColor.fromHex(AppConstants.primaryText),
                  size: 18,
                  weight: 800,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Language",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ListenableBuilder(
            listenable: LanguageService(),
            builder: (context, _) {
              final currentLang = LanguageService().currentLocale.languageCode;
              return Column(
                children: [
                  _buildLanguageOption(
                    context,
                    '🇺🇸',
                    'English',
                    'en',
                    currentLang == 'en',
                  ),
                  const SizedBox(height: 8),
                  _buildLanguageOption(
                    context,
                    '🇪🇸',
                    'Español',
                    'es',
                    currentLang == 'es',
                  ),
                  const SizedBox(height: 8),
                  _buildLanguageOption(
                    context,
                    '🇫🇷',
                    'Français',
                    'fr',
                    currentLang == 'fr',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String flag,
    String language,
    String code,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () async {
        await LanguageService().changeLanguage(code);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Language changed to $language'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected 
            ? HexColor.fromHex(AppConstants.primaryText).withValues(alpha: 0.1)
            : Colors.transparent,
          border: isSelected 
            ? Border.all(color: HexColor.fromHex(AppConstants.primaryText), width: 1.5)
            : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Text(
              language,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: HexColor.fromHex(AppConstants.primaryText),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
