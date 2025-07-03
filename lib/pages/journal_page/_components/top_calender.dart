import 'package:flutter/material.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

import '../../../utils/components/gradient_rich_text.dart';
import '../../../utils/components/infinite_date_scroll.dart';

class TopCalender extends StatelessWidget {
  const TopCalender({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Text("How do you feed today?", style: TextStyle(
            color: HexColor.fromHex(AppConstants.tertiaryPurple),
            fontWeight: FontWeight.w600,
            fontSize: 18
          ),),
          SizedBox(
            width: 100,
            child: Divider(
              thickness: 3,
              color: HexColor.fromHex(AppConstants.primaryPurple),
            ),
          ),
          InfiniteDateScroll(),
        ],
      ),
    );
  }
}