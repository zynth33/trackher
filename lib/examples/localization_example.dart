import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationExample extends StatelessWidget {
  const LocalizationExample({super.key});

  @override
  Widget build(BuildContext context) {
    // This is how you access the localized strings
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings), // Instead of "Settings"
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.customizeExperience, // Instead of "Customize your TrackHer experience"
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            
            // Example list of settings
            ListTile(
              leading: const Icon(Icons.contrast),
              title: Text(l10n.appearance), // Instead of "Appearance"
              subtitle: Text(l10n.theme),    // Instead of "Theme"
            ),
            
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(l10n.support), // Instead of "Support"
              subtitle: Text(l10n.help),  // Instead of "Help"
            ),
            
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(l10n.account), // Instead of "Account"
              subtitle: Text(l10n.profileSettings), // Instead of "Profile Settings"
            ),
            
            const SizedBox(height: 20),
            
            // Example buttons
            ElevatedButton(
              onPressed: () {},
              child: Text(l10n.save), // Instead of "Save"
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {},
              child: Text(l10n.cancel), // Instead of "Cancel"
            ),
            
            const SizedBox(height: 20),
            
            // Period tracking example
            Text(
              l10n.periodTracking, // Instead of "Period Tracking"
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('${l10n.cycleLength}: 28 ${l10n.day}s'), // Instead of "Cycle Length: 28 days"
            Text('${l10n.periodLength}: 5 ${l10n.day}s'), // Instead of "Period Length: 5 days"
            
            const SizedBox(height: 20),
            
            // Flow options
            Text(l10n.flow), // Instead of "Flow"
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(l10n.light)),   // Instead of "Light"
                Chip(label: Text(l10n.medium)),  // Instead of "Medium"
                Chip(label: Text(l10n.heavy)),   // Instead of "Heavy"
                Chip(label: Text(l10n.spotting)), // Instead of "Spotting"
              ],
            ),
          ],
        ),
      ),
    );
  }
}
