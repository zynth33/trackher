import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../sessions/period_session.dart';
import '../../../utils/helper_functions.dart';

class PeriodDataCards extends StatelessWidget {
  const PeriodDataCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentDay = getValueForDateInMap(DateTime.now(), PeriodSession().cycleNumbers) ?? 0;
    final daysUntilNext = PeriodSession().cycleLength - currentDay;
    final cycleLength = PeriodSession().cycleLength;
    final nextDate = DateTime.now().add(Duration(days: daysUntilNext + 1));
    final formattedNextDate = DateFormat('MMM d').format(nextDate);
    final cycleStartDate = getCycleStartDateFromCycleMap(
      DateTime.now(),
      PeriodSession().cycleNumbers,
    );
    final formattedCycleStartDate = DateFormat('MMM d').format(cycleStartDate!);
    final formattedToday = DateFormat('d MMM').format(DateTime.now());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.2,
              padding: EdgeInsets.all(13.0),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(20, 0, 0, 0),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(13.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(Icons.calendar_today_outlined, color: Colors.green,),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cycle", style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                      ),),
                      Text(formattedCycleStartDate, style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                      ),)
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2.2,
              padding: EdgeInsets.all(13.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(20, 0, 0, 0),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(13.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(Icons.add, color: Colors.deepPurple,),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Save Day", style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                      ),),
                      Text(formattedToday, style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                      ),)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.2,
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
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Next Period", style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),),
                  SizedBox(height: 5,),
                  Text(formattedNextDate, style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),),
                  Text("in $daysUntilNext days", style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),)
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2.2,
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
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Cycle Length", style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),),
                  SizedBox(height: 5,),
                  Text("$cycleLength Days", style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),),
                  Text("average", style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

DateTime? getCycleStartDateFromCycleMap(DateTime today, Map<DateTime, int> cycleNumbers) {
  final todayDate = DateTime(today.year, today.month, today.day);

  // Step 1: Get the cycle number for today
  final currentCycleNumber = cycleNumbers[todayDate];
  if (currentCycleNumber == null) return null;

  // Step 2: Find the earliest date that has this cycle number
  final matchingEntries = cycleNumbers.entries
      .where((entry) => entry.value == currentCycleNumber)
      .toList();

  if (matchingEntries.isEmpty) return null;

  matchingEntries.sort((a, b) => a.key.compareTo(b.key));
  return matchingEntries.first.key;
}

