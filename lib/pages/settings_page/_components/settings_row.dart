import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

import '../../../models/settings_item.dart';

class SettingsRow extends StatefulWidget {
  final SettingsItem setting;
  const SettingsRow({
    super.key, required this.setting,
  });

  @override
  State<SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<SettingsRow> {
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.setting.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(7.0),
            child: widget.setting.icon,
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.setting.title, style: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 12,
              ),),
              Text(widget.setting.subtitle, style: TextStyle(
                color: HexColor.fromHex("#333333").withValues(alpha: 0.4),
                fontSize: 10,
              ),)
            ],
          ),
          Spacer(),
          widget.setting.isSwitch ? FlutterSwitch(
            value: switchValue,
            width: 50,
            height: 30,
            toggleSize: 20,
            activeColor: Colors.green,
            onToggle: (bool value) {
              setState(() {
                switchValue = value;
              });
            },
          ) : Icon(Icons.chevron_right, color: Colors.black, size: 30,)
        ],
      ),
    );
  }
}