import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/assets.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';
import 'mood_selector.dart';

class Mood extends StatelessWidget {
  const Mood({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(13.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1)
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset(AppAssets.iconHeart,)
              ),
              SizedBox(width: 10,),
              Text("Mood", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.light ? HexColor.fromHex(AppConstants.graySwatch1) : Colors.white
              ),)
            ],
          ),
          SizedBox(height: 15,),
          MoodSelector()
        ],
      ),
    );
  }
}