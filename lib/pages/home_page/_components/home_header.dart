import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onSettingsTap;
  const HomeHeader({
    super.key, required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi, Good Morning", style: TextStyle(
                color: HexColor.fromHex(AppConstants.graySwatch1).withValues(alpha: 0.4),
                fontSize: 14
              ),),
              Text("Victoria 👋", style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),)
            ],
          ),
          Spacer(),
          InkWell(
            onTap: onSettingsTap,
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.settings_outlined, color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white, weight: 300, size: 20,),
            ),
          )
        ],
      ),
    );
  }
}