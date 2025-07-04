import 'package:flutter/material.dart';

import '../../../pages/settings_page/settings_page.dart';
import '../../../sessions/user_session.dart';
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
              Text("${UserSession().name ?? "User"} 👋", style: TextStyle(
                color: HexColor.fromHex(AppConstants.graySwatch1),
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),)
            ],
          ),
          Spacer(),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.settings_outlined, color: Theme.of(context).brightness == Brightness.light ? HexColor.fromHex(AppConstants.graySwatch1) : Colors.white, weight: 300, size: 20,),
            ),
          )
        ],
      ),
    );
  }
}
