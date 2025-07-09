import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';
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
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12
          ),),
          SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
              height: 10,
              color: HexColor.fromHex(AppConstants.primaryPurple),
            ),
          ),
          InfiniteDateScroll(fromNotes: true,),
        ],
      ),
    );
  }
}