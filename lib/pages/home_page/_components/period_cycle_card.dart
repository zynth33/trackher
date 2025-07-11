import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../sessions/dates_session.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';
import '../../period_date_selection_page/period_date_selection_page.dart';
import '../../../sessions/period_session.dart';
import '../../../utils/helper_functions.dart';
import 'rounded_circular_progress.dart';

class PeriodCycleCard extends StatefulWidget {
  const PeriodCycleCard({super.key});

  @override
  State<PeriodCycleCard> createState() => _PeriodCycleCardState();
}

class _PeriodCycleCardState extends State<PeriodCycleCard> {
  double _previousDay = 0.0;
  double _animatedDay = 0.0;

  @override
  void initState() {
    super.initState();
    DatesSession().selectedDateNotifier.addListener(_onDateChanged);
    // _updateDay();
  }

  @override
  void dispose() {
    DatesSession().selectedDateNotifier.removeListener(_onDateChanged);
    super.dispose();
  }

  void _onDateChanged() {
    setState(() {
      // _updateDay();
    });
  }

  // void _updateDay() {
  //   final day = getValueForDateInMap(
  //     DatesSession().selectedDate,
  //     PeriodSession().cycleNumbersNotifier.value,
  //   )?.toDouble() ??
  //       0.0;
  //   _previousDay = _animatedDay;
  //   _animatedDay = day;
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<DateTime, Map<String, int>>>(
      valueListenable: PeriodSession().cycleNumbersNotifier,
      builder: (context, cycleNumbers, _) {
        return ValueListenableBuilder<int>(
          valueListenable: PeriodSession().cycleLengthNotifier,
          builder: (context, cycleLength, _) {
            final mapEntry = getValueForDateInMap(DateTime.now(), PeriodSession().cycleNumbers);
            final currentDay = mapEntry is Map<String, int> ? mapEntry['cycleDay'] ?? 0 : 0;

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

            return AnimatedContainer(
              padding: const EdgeInsets.all(20),
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Period Cycle',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Day $currentDay',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: HexColor.fromHex("#EC4F7C"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    nextPeriodText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.44),
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    ),
                  ),

                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PeriodDateSelectionPage(allowFutureMonths: true),
                        ),
                      );
                    },
                    child: IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: HexColor.fromHex(AppConstants.primaryPurple).withAlpha((0.54 * 255).toInt()),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.penToSquare,
                              size: 16,
                              color: HexColor.fromHex("#333333"),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Edit Period",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: HexColor.fromHex("#333333"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
