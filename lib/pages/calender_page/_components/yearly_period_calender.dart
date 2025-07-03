import 'package:flutter/material.dart';
import '../../../sessions/period_session.dart';

import '../../../models/calender_data.dart';
import 'month_calender.dart';

class YearlyPeriodPage extends StatefulWidget {
  final int year;
  const YearlyPeriodPage({super.key, required this.year});

  @override
  State<YearlyPeriodPage> createState() => _YearlyPeriodPageState();
}

class _YearlyPeriodPageState extends State<YearlyPeriodPage> {
  late Future<CalendarData> _calendarDataFuture;

  @override
  void initState() {
    super.initState();
    _calendarDataFuture = _loadCalendarData();
  }

  Future<CalendarData> _loadCalendarData() async {
    final Set<DateTime> periodDays = PeriodSession().periodDays;
    final Set<DateTime> pastPeriodDays = {};
    final Set<DateTime> pmsDays = PeriodSession().pmsDays;
    final Set<DateTime> fertileDays = PeriodSession().fertileDays;
    final Set<DateTime> ovulationDays = PeriodSession().ovulationDays;


    return CalendarData(
      periodDays: periodDays,
      pastPeriodDays: pastPeriodDays,
      pmsDays: pmsDays,
      fertileDays: fertileDays,
      ovulationDays: ovulationDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CalendarData>(
      future: _calendarDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final data = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            crossAxisSpacing: 15,
            children: List.generate(12, (index) {
              return MonthCalendarWidget(
                year: widget.year,
                month: index + 1,
                periodDays: data.periodDays,
                pastPeriodDays: data.pastPeriodDays,
                pmsDays: data.pmsDays,
                fertileDays: data.fertileDays,
                ovulationDays: data.ovulationDays,
              );
            }),
          ),
        );
      },
    );
  }
}
