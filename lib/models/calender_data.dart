class CalendarData {
  final Set<DateTime> periodDays;
  final Set<DateTime> pastPeriodDays;
  final Set<DateTime> pmsDays;
  final Set<DateTime> fertileDays;

  CalendarData({
    required this.periodDays,
    required this.pastPeriodDays,
    required this.pmsDays,
    required this.fertileDays,
  });
}