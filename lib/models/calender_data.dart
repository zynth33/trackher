class CalendarData {
  final Set<DateTime> periodDays;
  final Set<DateTime> pastPeriodDays;
  final Set<DateTime> pmsDays;
  final Set<DateTime> fertileDays;
  final Set<DateTime> ovulationDays;

  CalendarData({
    required this.periodDays,
    required this.pastPeriodDays,
    required this.pmsDays,
    required this.fertileDays,
    required this.ovulationDays,
  });
}