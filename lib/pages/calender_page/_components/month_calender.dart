import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

class MonthCalendarWidget extends StatelessWidget {
  final int year;
  final int month;
  final Set<DateTime> periodDays;
  final Set<DateTime> pastPeriodDays;
  final Set<DateTime> pmsDays;
  final Set<DateTime> fertileDays;
  final Set<DateTime> ovulationDays;

  const MonthCalendarWidget({
    super.key,
    required this.year,
    required this.month,
    required this.periodDays,
    required this.pastPeriodDays,
    required this.pmsDays,
    required this.fertileDays,
    required this.ovulationDays,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime firstDay = DateTime(year, month, 1);
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int startWeekday = firstDay.weekday % 7;
    final int totalCells = daysInMonth + startWeekday;

    return Column(
      children: [
        Text(
          DateFormat.MMMM().format(firstDay),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
            .map((d) => Expanded(
            child: Center(
              child: Text(d,
                  style: const TextStyle(fontSize: 10, color: Colors.black)))))
            .toList(),
        ),
        const SizedBox(height: 4),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 2,
            crossAxisSpacing: 4,
          ),
          itemCount: totalCells,
          itemBuilder: (context, index) {
            if (index < startWeekday) return const SizedBox();

            final day = index - startWeekday + 1;
            final date = DateTime(year, month, day);

            Color bgColor = Colors.transparent;
            if (periodDays.contains(date) || pastPeriodDays.contains(date)) {
              bgColor = HexColor.fromHex(AppConstants.calenderPeriodIndicator);
            } else if (pmsDays.contains(date)) {
              bgColor = HexColor.fromHex(AppConstants.calenderPredictedIndicator);
            } else if (fertileDays.contains(date)) {
              if (ovulationDays.contains(date)) {
                bgColor = HexColor.fromHex(AppConstants.calenderOvulationIndicator);
              } else {
                bgColor = HexColor.fromHex(AppConstants.calenderFertileIndicator);
              }
            }

            return Center(
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: const TextStyle(
                      fontSize: 7,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}