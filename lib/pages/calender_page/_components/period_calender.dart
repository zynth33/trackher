import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../models/past_period.dart';
import '../../../models/period_prediction.dart';
import '../../../sessions/period_session.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../utils/components/day_circle.dart';
import '../../../utils/components/day_detail_bottom_sheet.dart';

class PeriodCalendar extends StatefulWidget {
  final int month;
  final int year;
  const PeriodCalendar({super.key, required this.month, required this.year});

  @override
  State<PeriodCalendar> createState() => _PeriodCalendarState();
}

class _PeriodCalendarState extends State<PeriodCalendar> {
  Set<DateTime> _periodDays = {};
  Set<DateTime> _predictedDays = {};
  Set<DateTime> _fertileDays = {};
  Set<DateTime> _ovulationDays = {};

  int oldestYear = 2020;
  int limitYear = 2030;

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  void initState() {
    super.initState();

    if (PeriodSession().cycleNumbers.isNotEmpty) {
      final Set<DateTime> allPeriodDays = PeriodSession().periodDays;
      final allFertileDays = PeriodSession().fertileDays;
      final allOvulationDays = PeriodSession().ovulationDays;
      final Set<DateTime> allPmsDays = PeriodSession().pmsDays;

      setState(() {
        _periodDays = allPeriodDays;
        _predictedDays = allPmsDays;
        _fertileDays = allFertileDays;
        _ovulationDays = allOvulationDays;
      });

      return;
    } else {
      final Box<PeriodPrediction> periodPredictionBox = Hive.box<PeriodPrediction>('predictions');
      final Box<PastPeriod> pastPeriodBox = Hive.box<PastPeriod>('pastPeriods');
      var periodMetaDataBox = Hive.box('periodMetaData');

      if (periodPredictionBox.isNotEmpty) {
        final allPredictions = periodPredictionBox.values.toList();
        final Set<DateTime> allPeriodDays = {};
        final Set<DateTime> allFertileDays = {};
        final Set<DateTime> allPmsDays = {};
        final Set<DateTime> allOvulationDays = {};

        for (final prediction in allPredictions) {
          allPeriodDays.addAll(prediction.periodWindow.map((d) => DateTime.parse(d)));
          allPmsDays.addAll(prediction.pmsWindow.map((d) => DateTime.parse(d)));
          allFertileDays.addAll(prediction.fertileWindow.map((d) => DateTime.parse(d)));
          allOvulationDays.add(DateTime.parse(prediction.ovulation));
        }

        setState(() {
          _periodDays = allPeriodDays;
          _predictedDays = allPmsDays;
          _fertileDays = allFertileDays;
          _ovulationDays = allOvulationDays;
        });
      }

      if (pastPeriodBox.isNotEmpty) {
        final List<String> listOfPastPeriods = pastPeriodBox.values.toList()[0].pastPeriods;
        final Set<DateTime> pastPeriods = {};

        for (final period in listOfPastPeriods) {
          pastPeriods.add(DateTime.parse(period));
        }

        setState(() {
          _periodDays.addAll(pastPeriods);
        });

        PeriodSession().setPeriodDays(_periodDays);
        PeriodSession().setPmsDays(_predictedDays);
        PeriodSession().setFertileDays(_fertileDays);
        PeriodSession().setOvulationDays(_ovulationDays);

        PeriodSession().setCycleLength(periodMetaDataBox.get('cycleLength'));
        PeriodSession().setPeriodLength(periodMetaDataBox.get('periodLength'));
      }

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxMonths = 3;

    if (widget.year == PeriodSession().limitYear) {
      final remainingMonths = 12 - widget.month + 1;
      maxMonths = remainingMonths.clamp(0, 3);
    } else if (widget.year > PeriodSession().limitYear) {
      maxMonths = 0;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: List.generate(maxMonths, (index) {
          final month = DateTime(widget.year, widget.month + index, 1);
          return _buildMonthCalendar(month);
        }),
      ),
    );
  }

  Widget _buildMonthCalendar(DateTime focusDay) {
    final oldestDate = DateTime(oldestYear, 1, 1);
    final lastDate = DateTime(limitYear, 12, 31);
    final clampedFocusDay = focusDay.isAfter(lastDate)
      ? lastDate
      : focusDay.isBefore(oldestDate)
      ? oldestDate
      : focusDay;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _monthName(focusDay),
                style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
        TableCalendar(
          firstDay: DateTime(oldestYear),
          lastDay: DateTime(limitYear + 1),
          focusedDay: clampedFocusDay,

          headerVisible: false,
          availableGestures: AvailableGestures.none,
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(),
            selectedDecoration: BoxDecoration(),
            outsideDaysVisible: true,
          ),
          weekNumbersVisible: false,
          onDaySelected: (selectedDay, focusedDay) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => DayDetailBottomSheet(date: selectedDay),
            );
          },
          selectedDayPredicate: (_) => false,
          daysOfWeekHeight: 20,
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
                  isNormal: false,
                );
              }

              if (_predictedDays.any((d) => _isSameDay(d, day))) {
                return buildCircle(
                  day: day,
                  fill: Colors.yellow.withValues(alpha: 0.1),
                  textColor: Colors.orange,
                  border: Colors.yellow,
                  showDot: !_isSameDay(day, DateTime.now()),
                  dotColor: Colors.orangeAccent,
                  isNormal: false,
                  isFuture: true,
                );
              }

              if (_ovulationDays.any((d) => _isSameDay(d, day))) {
                return buildCircle(
                    day: day,
                    fill: Colors.white,
                    textColor: Colors.black,
                    border: Colors.blueGrey,
                    isNormal: false,
                    isFuture: true,
                    showBorder: true
                );
              }

              if (_fertileDays.any((d) => _isSameDay(d, day))) {
                return buildCircle(
                  day: day,
                  fill: Colors.blueGrey.withValues(alpha: 0.4),
                  textColor: Colors.white,
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
          daysOfWeekVisible: false,

          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.grey),
            weekendStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  String _monthName(DateTime date) {
    return [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ][date.month - 1];
  }
}