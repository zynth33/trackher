import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';

import '../../../utils/extensions/color.dart';
import '../../../utils/constants.dart';


class PeriodLegacy extends StatelessWidget {
  const PeriodLegacy({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: HexColor.fromHex("#FEFAFB"),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: Offset(1, 1),
          ),
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: AppConstants.options.map((option){
          return Column(
            children: [
              DashedCircle(
                dashes: option == "Ovulation" ? 3 : 0,
                gapSize: 10,
                color: Colors.black,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: switch(option) {
                      "Period" => HexColor.fromHex(AppConstants.calenderPeriodIndicator),
                      "Predicted" => HexColor.fromHex(AppConstants.calenderPredictedIndicator),
                      "Ovulation" => HexColor.fromHex(AppConstants.calenderOvulationIndicator),
                      "Fertile" => HexColor.fromHex(AppConstants.calenderFertileIndicator),
                      String() => Colors.blueGrey,
                    },
                    borderRadius: BorderRadius.circular(100)
                  ),
                ),
              ),
              SizedBox(height: 2,),
              Text(option, style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
              ),),
            ],
          );
        }).toList(),
      ),
    );
  }
}