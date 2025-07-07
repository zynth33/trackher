# TrackHer Internationalization (i18n) Guide

This guide explains how to add and use multiple languages in your TrackHer app.

## Overview

Your app now supports internationalization with these languages:
- 🇺🇸 English (en) - Default
- 🇪🇸 Spanish (es)
- 🇫🇷 French (fr)

You can easily add more languages by following the steps below.

## How to Use Translations in Your Code

### 1. Import the localization package
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

### 2. Access translations in your widgets
```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return Text(l10n.settings); // Instead of Text("Settings")
}
```

### 3. Replace hardcoded strings
Instead of:
```dart
Text("Settings")
Text("Customize your TrackHer experience")
Text("Login")
```

Use:
```dart
Text(l10n.settings)
Text(l10n.customizeExperience) 
Text(l10n.login)
```

## Available Translation Keys

Here are the translation keys available in your app:

### General
- `appTitle` - "TrackHer"
- `settings` - "Settings"
- `user` - "User"
- `login` - "Login"
- `logout` - "Logout"
- `cancel` - "Cancel"
- `confirm` - "Confirm"
- `save` - "Save"
- `edit` - "Edit"
- `delete` - "Delete"
- `yes` - "Yes"
- `no` - "No"
- `ok` - "OK"
- `error` - "Error"
- `success` - "Success"
- `loading` - "Loading..."

### Settings
- `customizeExperience` - "Customize your TrackHer experience"
- `appearance` - "Appearance"
- `support` - "Support"
- `account` - "Account"
- `notifications` - "Notifications"
- `privacyAndSecurity` - "Privacy And Security"
- `theme` - "Theme"
- `lightTheme` - "Light"
- `darkTheme` - "Dark"
- `systemTheme` - "System"

### Period Tracking
- `periodTracking` - "Period Tracking"
- `cycleLength` - "Cycle Length"
- `periodLength` - "Period Length"
- `nextPeriod` - "Next Period"
- `ovulation` - "Ovulation"
- `fertile` - "Fertile"
- `pms` - "PMS"
- `period` - "Period"
- `flow` - "Flow"
- `symptoms` - "Symptoms"
- `mood` - "Mood"
- `notes` - "Notes"
- `light` - "Light"
- `medium` - "Medium"
- `heavy` - "Heavy"
- `spotting` - "Spotting"

### Journal
- `journal` - "Journal"
- `addEntry` - "Add Entry"
- `recentEntries` - "Recent Entries"
- `enterYourThoughts` - "Enter your thoughts..."
- `howAreYouFeeling` - "How are you feeling?"
- `selectMood` - "Select Mood"
- `selectSymptoms` - "Select Symptoms"
- `selectFlow` - "Select Flow"

### Authentication
- `signIn` - "Sign In"
- `signUp` - "Sign Up"
- `email` - "Email"
- `password` - "Password"
- `confirmPassword` - "Confirm Password"
- `forgotPassword` - "Forgot Password?"
- `createAccount` - "Create Account"
- `alreadyHaveAccount` - "Already have an account?"
- `dontHaveAccount` - "Don't have an account?"
- `signOut` - "Sign Out"
- `emailVerification` - "Email Verification"
- `verifyEmail` - "Verify Email"
- `resendVerification` - "Resend Verification"

### AI Chat
- `aiChat` - "AI Chat"
- `askQuestion` - "Ask a question..."
- `recentChats` - "Recent Chats"
- `quickQuestions` - "Quick Questions"
- `chatWithAI` - "Chat with AI"

### Calendar
- `calendar` - "Calendar"
- `today` - "Today"
- `month` - "Month"
- `week` - "Week"
- `day` - "Day"

### Profile
- `profileSettings` - "Profile Settings"
- `name` - "Name"
- `dateOfBirth` - "Date of Birth"
- `avatar` - "Avatar"
- `personalInfo` - "Personal Information"

### Help
- `help` - "Help"
- `faqs` - "FAQs"
- `contactSupport` - "Contact Support"
- `reportIssue` - "Report Issue"

### Days of the Week
- `monday` - "Monday"
- `tuesday` - "Tuesday"
- `wednesday` - "Wednesday"
- `thursday` - "Thursday"
- `friday` - "Friday"
- `saturday` - "Saturday"
- `sunday` - "Sunday"

### Months
- `january` - "January"
- `february` - "February"
- `march` - "March"
- `april` - "April"
- `may` - "May"
- `june` - "June"
- `july` - "July"
- `august` - "August"
- `september` - "September"
- `october` - "October"
- `november` - "November"
- `december` - "December"

## How to Add More Languages

### 1. Create a new ARB file
Create a new file in `lib/l10n/` named `app_[language_code].arb`

For example, for German: `lib/l10n/app_de.arb`

### 2. Copy the structure from English
Copy the content from `lib/l10n/app_en.arb` and translate the values:

```json
{
  "@@locale": "de",
  "appTitle": "TrackHer",
  "settings": "Einstellungen",
  "user": "Benutzer",
  "login": "Anmelden",
  ...
}
```

### 3. Add the locale to main.dart
Update the `supportedLocales` in your `main.dart`:

```dart
supportedLocales: const [
  Locale('en'), // English
  Locale('es'), // Spanish
  Locale('fr'), // French
  Locale('de'), // German (new)
],
```

### 4. Run code generation
```bash
flutter gen-l10n
```

### 5. Update your language selector
Add the new language to your language selector widget.

## Step-by-Step Migration Process

Here's how to migrate your existing app to use translations:

### 1. Start with one page at a time
Pick a page (like Settings) and replace all hardcoded strings:

**Before:**
```dart
Text("Settings")
Text("Customize your TrackHer experience")
```

**After:**
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.settings)
Text(l10n.customizeExperience)
```

### 2. Add missing translations
If you need a translation that doesn't exist:

1. Add it to `lib/l10n/app_en.arb`:
```json
"myNewString": "My New String"
```

2. Add translations to other language files
3. Run `flutter gen-l10n`
4. Use it: `l10n.myNewString`

### 3. Test with different languages
Use the language selector to test your app in different languages.

### 4. Handle plurals and parameters
For strings with variables:

```json
"welcomeMessage": "Welcome back, {name}!",
"@welcomeMessage": {
  "placeholders": {
    "name": {
      "type": "String"
    }
  }
}
```

Use it:
```dart
Text(l10n.welcomeMessage(userName))
```

## Best Practices

1. **Always use translation keys** - Never hardcode text in your widgets
2. **Keep keys descriptive** - Use clear names like `customizeExperience` instead of `text1`
3. **Group related keys** - Use consistent prefixes for related functionality
4. **Test all languages** - Make sure your UI looks good in all supported languages
5. **Consider text length** - Some languages are longer than others
6. **Use professional translation** - For production apps, consider professional translation services

## Common Issues and Solutions

### Issue: "AppLocalizations.of(context) returned null"
**Solution:** Make sure you've added the localization delegates to your MaterialApp.

### Issue: Generated files not found
**Solution:** Run `flutter gen-l10n` after adding new translations.

### Issue: Text overflows in other languages
**Solution:** Use flexible widgets and test with longer languages like German.

### Issue: Language not changing
**Solution:** Make sure you're passing the locale to MaterialApp and restarting the app.

## File Structure

After setup, your project should have:

```
lib/
├── l10n/
│   ├── app_en.arb     # English translations
│   ├── app_es.arb     # Spanish translations
│   └── app_fr.arb     # French translations
├── examples/
│   └── localization_example.dart  # Example usage
├── utils/
│   └── components/
│       └── language_selector.dart # Language switcher
└── main.dart          # App setup with localization

l10n.yaml              # Configuration file
INTERNATIONALIZATION_GUIDE.md  # This guide
```

## Next Steps

1. **Start migrating your pages** - Begin with the most important screens
2. **Add more languages** - Based on your target audience
3. **Test thoroughly** - Ensure all text displays correctly
4. **Consider RTL languages** - If you plan to support Arabic, Hebrew, etc.
5. **Add date/number formatting** - Use `intl` package for locale-specific formatting

Remember: Internationalization is an ongoing process. Start with the main screens and gradually migrate the entire app. Your users will appreciate the effort to support their language!
