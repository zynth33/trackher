import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/assets.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';

import 'flow_selector.dart';

class MenstrualFlow extends StatelessWidget {
  const MenstrualFlow({
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
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1)
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset(AppAssets.iconFlow,)
              ),
              SizedBox(width: 10,),
              Text("Menstrual Flow", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.light ? HexColor.fromHex(AppConstants.graySwatch1) : Colors.white
              ),)
            ],
          ),
          SizedBox(height: 15,),
          FlowSelector()
        ],
      ),
    );
  }
}