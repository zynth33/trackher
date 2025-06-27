import 'package:flutter/material.dart';
import 'settings_row.dart';

import '../../../models/settings_item.dart';

class SettingsCard extends StatelessWidget {
  final List<SettingsItem> settings;
  final String title;
  const SettingsCard({
    super.key, required this.settings, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 20.0),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
          ),),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Column(
              spacing: 25,
              children: settings.map((setting) {
                return SettingsRow(setting: setting,);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}