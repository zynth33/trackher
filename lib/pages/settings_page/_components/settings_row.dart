import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(20, 0, 0, 0),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: widget.setting.icon,
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.setting.title, style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
              ),),
              Text(widget.setting.subtitle, style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500
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
          ) : Icon(Icons.chevron_right, color: Colors.grey, size: 25,)
        ],
      ),
    );
  }
}