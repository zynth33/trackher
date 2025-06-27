extension PeriodDateSet on Set<DateTime> {
  bool hasAllDates(Iterable<DateTime> other) {
    return other.every((o) => any((s) =>
    s.year == o.year && s.month == o.month && s.day == o.day));
  }

  void removeDates(Iterable<DateTime> other) {
    removeWhere((s) =>
        other.any((o) =>
        s.year == o.year && s.month == o.month && s.day == o.day));
  }
}
