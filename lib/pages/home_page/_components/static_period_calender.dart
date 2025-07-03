import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

import '../../../sessions/period_session.dart';
import '../../../utils/components/day_circle.dart';

class StaticPeriodCalendar extends StatefulWidget {
  const StaticPeriodCalendar({super.key});

  @override
  State<StaticPeriodCalendar> createState() => _StaticPeriodCalendarState();
}

class _StaticPeriodCalendarState extends State<StaticPeriodCalendar> {
  final DateTime _focusedDay = DateTime.now();

  final Set<DateTime> _periodDays = PeriodSession().periodDays;
  final Set<DateTime> _lightFutureDays = PeriodSession().pmsDays;
  final Set<DateTime> _ovulationDays = PeriodSession().ovulationDays;
  final Set<DateTime> _fertileDays = PeriodSession().fertileDays;

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM').format(DateTime.now()),
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  DateFormat('y').format(DateTime.now()),
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay:  DateTime(2030),
            focusedDay: _focusedDay,
            headerVisible: false,
            calendarStyle: const CalendarStyle(
              todayDecoration:  BoxDecoration(),
              selectedDecoration: BoxDecoration(),
              outsideDaysVisible: false,
            ),
            selectedDayPredicate: (_) => false,
            onDaySelected: null,

            daysOfWeekHeight: 20,
            availableGestures: AvailableGestures.none,

            startingDayOfWeek: StartingDayOfWeek.monday,
            weekendDays: [DateTime.sunday],

            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                  color: HexColor.fromHex(AppConstants.weekDayIndicator),
                  fontWeight: FontWeight.w600
              ),
              weekendStyle: TextStyle(
                  color: HexColor.fromHex(AppConstants.weekEndIndicator),
                  fontWeight: FontWeight.w600
              ),
            ),

            calendarBuilders: CalendarBuilders(
              todayBuilder: (ctx, day, fd) => buildCircle(
                day: day,
                fill: HexColor.fromHex(AppConstants.calenderTodayIndicator),
                textColor: Colors.white,
              ),

              defaultBuilder: (ctx, day, fd) {
                if (_periodDays.any((d) => _isSameDay(d, day))) {
                  return buildCircle(
                    day: day,
                    fill: HexColor.fromHex(AppConstants.calenderPeriodIndicator),
                    textColor: Colors.black,
                    showDot: false,
                    isNormal: false
                  );
                }

                if (_lightFutureDays.any((d) => _isSameDay(d, day))) {
                  return buildCircle(
                    day: day,
                    fill: HexColor.fromHex(AppConstants.calenderPredictedIndicator),
                    textColor: Colors.black,
                    isNormal: false,
                    isFuture: true,
                    showBorder: false
                  );
                }

                if (_ovulationDays.any((d) => _isSameDay(d, day))) {
                  return buildCircle(
                      day: day,
                      fill: HexColor.fromHex(AppConstants.calenderOvulationIndicator),
                      textColor: Colors.black,
                      border: Colors.black,
                      isNormal: false,
                      isFuture: true,
                      showBorder: true
                  );
                }

                if (_fertileDays.any((d) => _isSameDay(d, day))) {
                  return buildCircle(
                      day: day,
                      fill: HexColor.fromHex(AppConstants.calenderFertileIndicator),
                      textColor: Colors.black,
                      isNormal: false,
                      isFuture: true,
                      showBorder: false
                  );
                }

                return buildCircle(
                  day: day,
                  textColor: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                  fill: Colors.transparent,
                );
              },
            ),

            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
          ),
        ],
      ),
    );
  }
}