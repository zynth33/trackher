import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';

import '../../../utils/extensions/color.dart';
import '../../../utils/constants.dart';


class PeriodLegend extends StatelessWidget {
  const PeriodLegend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: AppConstants.options.map((option){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.15)
              )
            ),
            child: Row(
              spacing: 3,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DashedCircle(
                  dashes: option == "Ovulation" ? 8 : 0,
                  gapSize: 10,
                  color: Colors.black,
                  child: Container(
                    height: 12,
                    width: 12,
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
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
                ),),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}