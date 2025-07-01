import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            final daysUntilNext = cycleLength - currentDay;

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
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.shade100,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Period Cycle',
                        style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: RoundedCircularProgress(
                          day: currentDay.toDouble(),
                          strokeWidth: 6,
                          backgroundColor: Colors.grey.withValues(alpha: 0.1),
                          progressColor: Colors.purple,
                          size: 120,
                        ),
                      ),
                      Container(
                        height: 155,
                        width: 155,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.red.withValues(alpha: 0.1),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.red.withValues(alpha: 1.0),
                          //     blurRadius: 50,
                          //     offset: Offset(1, 1),
                          //   ),
                          // ],
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
                        style: const TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      Text(
                        ' \u2022 ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' Next period in $daysUntilNext days',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PeriodDateSelectionPage(allowFutureMonths: true,)));
                      },
                      icon: const Icon(FontAwesomeIcons.penToSquare, size: 16),
                      label: const Text("Edit Period", style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent.shade100,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}