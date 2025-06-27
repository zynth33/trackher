import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
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
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
            child: Row(
              children: [
                Text("June", style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                  fontSize: 20
                ),),
                Spacer(),
                Text("2025", style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),)
              ],
            ),
          ),
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

            calendarBuilders: CalendarBuilders(
              todayBuilder: (ctx, day, fd) => buildCircle(
                day: day,
                fill: Colors.pink,
                textColor: Colors.white,
              ),

              defaultBuilder: (ctx, day, fd) {
                if (_periodDays.any((d) => _isSameDay(d, day))) {
                  return buildCircle(
                    day: day,
                    fill: Colors.pink.withValues(alpha: 0.35),
                    textColor: Colors.pink,
                    showDot: !_isSameDay(day, DateTime.now()),
                    isNormal: false
                  );
                }

                if (_lightFutureDays.any((d) => _isSameDay(d, day))) {
                  return buildCircle(
                    day: day,
                    fill: Colors.yellow.withValues(alpha: 0.1),
                    textColor: Colors.orange,
                    border: Colors.yellow,
                    isNormal: false,
                    isFuture: true
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
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.grey),
              weekendStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}