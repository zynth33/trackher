import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trackher/sessions/settings_session.dart';

import '../../../utils/enums.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  ThemeModeOption _selected = SettingsSession().theme;

  void _onSelect(ThemeModeOption option) {
    setState(() {
      _selected = option;
      SettingsSession().setTheme(option);
    });

    var box = Hive.box('settingsBox');
    box.put('theme', option);
  }

  Widget _buildModeOption({
    required ThemeModeOption mode,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selected == mode;

    return GestureDetector(
      onTap: () => _onSelect(mode),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black : const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.pink : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.pink.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : [],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? Colors.black : Colors.white,
              child: Icon(icon, color: isSelected ? Colors.white : Colors.black),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.deepPurple : Colors.black
                  )),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13, )),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.pink : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Appearance', style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.black
        )),
      ),
      body: Padding (
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Appearance",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.black
              )),
              const SizedBox(height: 16),
          
              // Options
              _buildModeOption(
                mode: ThemeModeOption.light,
                icon: Icons.light_mode,
                title: "Light Mode",
                subtitle: "Clean and bright interface",
              ),
              _buildModeOption(
                mode: ThemeModeOption.dark,
                icon: Icons.dark_mode,
                title: "Dark Mode",
                subtitle: "Easy on the eyes for low light",
              ),
              _buildModeOption(
                mode: ThemeModeOption.system,
                icon: Icons.brightness_auto,
                title: "Auto (System)",
                subtitle: "Matches your device settings",
              ),
          
              // const SizedBox(height: 32),
              // Center(
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //       // backgroundColor: LinearGradient(
              //       //   colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
              //       // ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              //       // foregroundColor: Colors.white,
              //     ).copyWith(
              //       backgroundColor: MaterialStateProperty.resolveWith((states) {
              //         return null; // to override the solid background
              //       }),
              //     ),
              //     onPressed: () {
              //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //         content: Text("Applied ${_selected.name} theme!"),
              //       ));
              //     },
              //     child: const Text("Apply Theme"),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
