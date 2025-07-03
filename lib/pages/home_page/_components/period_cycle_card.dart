import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';
import '../../period_date_selection_page/period_date_selection_page.dart';
import '../../../sessions/period_session.dart';
import '../../../utils/helper_functions.dart';
import 'rounded_circular_progress.dart';

class PeriodCycleCard extends StatelessWidget {
  const PeriodCycleCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<DateTime, int>> (
      valueListenable: PeriodSession().cycleNumbersNotifier,
      builder: (context, cycleNumbers, _) {
        return ValueListenableBuilder<int> (
          valueListenable: PeriodSession().cycleLengthNotifier,
          builder: (context, cycleLength, _) {
            final currentDay = getValueForDateInMap(DateTime.now(), cycleNumbers) ?? 0;
            final periodLength = PeriodSession().periodLength;
            final daysUntilNext = cycleLength - currentDay;

            String nextPeriodText;
            if (currentDay >= 1 && currentDay <= periodLength) {
              nextPeriodText = 'Period is ongoing';
            } else if (daysUntilNext == 1 || daysUntilNext <= 0) {
              nextPeriodText = 'Next period tomorrow';
            } else {
              nextPeriodText = 'Next period in $daysUntilNext days';
            }

            return Container(
              padding: const EdgeInsets.all(20),
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
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Period Cycle',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          child: RoundedCircularProgressWithIcon(
                            day: currentDay.toDouble(),
                            strokeWidth: 6,
                            backgroundColor: Colors.grey.withValues(alpha: 0.1),
                            progressColor: Colors.purple,
                            size: 160,
                          ),
                        ),
                      ),
                      Container(
                        width: 65,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'DAY',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              '$currentDay',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            Text(
                              'of $cycleLength',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Day $currentDay of your cycle',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Transform.translate(
                          offset: Offset(0, -1),
                          child: Text(
                            '\u2022',
                            // textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Text(
                        nextPeriodText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PeriodDateSelectionPage(allowFutureMonths: true,)));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor.fromHex(AppConstants.primaryPurple).withValues(alpha: 0.54)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.penToSquare, size: 16, color: HexColor.fromHex(AppConstants.primaryColorLight),),
                          SizedBox(width: 10,),
                          Text("Edit Period", style: TextStyle(
                            fontSize: 14,
                            color: HexColor.fromHex(AppConstants.primaryColorLight),
                            fontWeight: FontWeight.w600
                          ),),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton.icon(
                  //     onPressed: () {
                  //       Navigator.push(context, MaterialPageRoute(builder: (context) => PeriodDateSelectionPage(allowFutureMonths: true,)));
                  //     },
                  //     icon: const Icon(FontAwesomeIcons.penToSquare, size: 16),
                  //     label: const Text("Edit Period", style: TextStyle(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.w500
                  //     ),),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: HexColor.fromHex(AppConstants.primaryPurple),
                  //       foregroundColor: Colors.white,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16),
                  //       ),
                  //       padding: const EdgeInsets.symmetric(vertical: 12),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}