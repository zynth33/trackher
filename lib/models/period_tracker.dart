import 'package:intl/intl.dart';

class PeriodTracker {
  final List<DateTime> periodStartDates;
  final int averageCycleLength;
  final int periodLength;

  PeriodTracker({
    required this.periodStartDates,
    this.averageCycleLength = 28,
    this.periodLength = 5,
  });

  /// Predicts the next n periods as ranges (start -> end)
  List<Map<String, DateTime>> predictNextPeriods({int count = 1}) {
    if (periodStartDates.isEmpty) {
      throw Exception("No period data available");
    }

    final List<Map<String, DateTime>> periods = [];
    DateTime lastPeriodStart = periodStartDates.last;

    for (int i = 0; i < count; i++) {
      DateTime start = lastPeriodStart.add(Duration(days: averageCycleLength));
      DateTime end = start.add(Duration(days: periodLength - 1));
      periods.add({'start': start, 'end': end});
      lastPeriodStart = start;
    }

    return periods;
  }

  /// Predict ovulation date for a given period start
  DateTime predictOvulation(DateTime periodStart) {
    return periodStart.subtract(Duration(days: 14));
  }

  /// Predict fertile window for given ovulation day
  List<DateTime> getFertileWindow(DateTime ovulationDate) {
    return List.generate(
        7, (i) => ovulationDate.subtract(Duration(days: 5 - i)));
  }

  /// Returns the PMS window (typically 5 days before period starts)
  List<DateTime> getPmsWindow(DateTime periodStart) {
    return List.generate(
      3, (i) => periodStart.subtract(Duration(days: 3 - i)),
    );
  }

  Map<String, List<Map<String, dynamic>>> getPredictions({int months = 1}) {
    final DateFormat format = DateFormat('yyyy-MM-dd');

    // Group past periods
    final List<Map<String, dynamic>> pastPeriods = periodStartDates.map((start) {
      final end = start.add(Duration(days: periodLength - 1));
      final periodWindow = List<DateTime>.generate(
        end.difference(start).inDays + 1,
            (i) => start.add(Duration(days: i)),
      );
      return {
        'start': format.format(start),
        'end': format.format(end),
        'periodWindow': periodWindow.map(format.format).toList(),
      };
    }).toList();

    final DateTime today = DateTime.now();

    final List<Map<String, DateTime>> predictedPeriods = [];
    DateTime lastPeriodStart = periodStartDates.last;

    while (predictedPeriods.length < months) {
      final nextStart = lastPeriodStart.add(Duration(days: averageCycleLength));
      final nextEnd = nextStart.add(Duration(days: periodLength - 1));

      if (nextStart.isAfter(today.subtract(const Duration(days: 1)))) {
        predictedPeriods.add({'start': nextStart, 'end': nextEnd});
      }

      lastPeriodStart = nextStart;
    }

    final List<Map<String, dynamic>> futurePredictions = [];

    for (int i = 0; i < predictedPeriods.length; i++) {
      final start = predictedPeriods[i]['start']!;
      final end = predictedPeriods[i]['end']!;
      final ovulation = predictOvulation(start);
      final fertileWindow = getFertileWindow(ovulation);
      final pmsWindow = getPmsWindow(start);

      final periodWindow = List<DateTime>.generate(
        end.difference(start).inDays + 1,
            (i) => start.add(Duration(days: i)),
      );

      futurePredictions.add({
        'cycleNumber': ((start.difference(periodStartDates.first).inDays) ~/ averageCycleLength),
        'month': 'Month ${i + 1}',
        'periodWindow': periodWindow.map(format.format).toList(),
        'ovulation': format.format(ovulation),
        'fertileWindow': fertileWindow.map(format.format).toList(),
        'pmsWindow': pmsWindow.map(format.format).toList(),
      });
    }

    print(futurePredictions);

    return {
      'pastPeriods': pastPeriods,
      'predictions': futurePredictions,
    };
  }

  /// Accepts a flat list of past period dates and returns average cycle and period length
  static ({int averageCycleLength, int periodLength}) calculateCycleStats(List<DateTime> allPeriodDates) {
    if (allPeriodDates.isEmpty) {
      throw Exception("Period date list cannot be empty.");
    }

    allPeriodDates.sort();

    final List<List<DateTime>> periodGroups = [];
    List<DateTime> currentGroup = [allPeriodDates.first];

    for (int i = 1; i < allPeriodDates.length; i++) {
      final prev = allPeriodDates[i - 1];
      final curr = allPeriodDates[i];
      if (curr.difference(prev).inDays == 1) {
        currentGroup.add(curr);
      } else {
        periodGroups.add(currentGroup);
        currentGroup = [curr];
      }
    }
    periodGroups.add(currentGroup);

    if (periodGroups.length < 2) {
      throw Exception("At least two period cycles are needed to calculate cycle length.");
    }

    final averagePeriodLength = (periodGroups
        .map((group) => group.length)
        .reduce((a, b) => a + b) /
        periodGroups.length)
        .round();

    final cycleGaps = <int>[];
    for (int i = 1; i < periodGroups.length; i++) {
      final previousStart = periodGroups[i - 1].first;
      final currentStart = periodGroups[i].first;
      cycleGaps.add(currentStart
          .difference(previousStart)
          .inDays);
    }
    final averageCycleLength = (cycleGaps.reduce((a, b) => a + b) /
        cycleGaps.length).round();

    return (averageCycleLength: averageCycleLength, periodLength: averagePeriodLength);
  }

  static int getOldestYear(List<DateTime> allPeriodDates) {
    if (allPeriodDates.isEmpty) {
      throw Exception("Period date list cannot be empty.");
    }

    final oldestDate = allPeriodDates.reduce(
          (a, b) => a.isBefore(b) ? a : b,
    );

    return oldestDate.year;
  }

  /// Returns the cycle number (1-based) for the given date.
  /// Returns -1 if the date is before the first recorded period.
  /// Returns a map with cycleNumber and cycleDay for the given date.
  /// Returns null if the date is before the first recorded period.
  Map<String, int>? getCycleInfo(DateTime date) {
    if (periodStartDates.isEmpty || date.isBefore(periodStartDates.first)) {
      return null;
    }

    final normalizedDate = DateTime(date.year, date.month, date.day);

    for (int i = 0; i < periodStartDates.length; i++) {
      final start = DateTime(
        periodStartDates[i].year,
        periodStartDates[i].month,
        periodStartDates[i].day,
      );

      final nextStart = (i + 1 < periodStartDates.length)
          ? DateTime(
        periodStartDates[i + 1].year,
        periodStartDates[i + 1].month,
        periodStartDates[i + 1].day,
      )
          : null;

      final cycleEnd = nextStart != null
          ? nextStart.subtract(const Duration(days: 1))
          : start.add(Duration(days: averageCycleLength - 1));

      if (!normalizedDate.isBefore(start) && !normalizedDate.isAfter(cycleEnd)) {
        return {
          'cycleNumber': ((start.difference(periodStartDates.first).inDays) ~/ averageCycleLength) + 1,
          'cycleDay': normalizedDate.difference(start).inDays + 1,
        };
      }
    }

    // Predicted future cycles
    DateTime lastStart = DateTime(
      periodStartDates.last.year,
      periodStartDates.last.month,
      periodStartDates.last.day,
    );

    while (normalizedDate.isAfter(lastStart.add(Duration(days: averageCycleLength - 1)))) {
      lastStart = lastStart.add(Duration(days: averageCycleLength));
    }

    final cycleNumber = ((lastStart.difference(periodStartDates.first).inDays) ~/ averageCycleLength) + 1;
    final cycleDay = normalizedDate.difference(lastStart).inDays + 1;

    return {
      'cycleNumber': cycleNumber,
      'cycleDay': cycleDay,
    };
  }


  /// For printing/debug
  void printPredictions({int months = 1}) {
    final format = DateFormat('yyyy-MM-dd');
    final predictedPeriods = predictNextPeriods(count: months);

    for (int i = 0; i < predictedPeriods.length; i++) {
      final start = predictedPeriods[i]['start']!;
      final end = predictedPeriods[i]['end']!;
      final ovulation = predictOvulation(start);
      final fertileWindow = getFertileWindow(ovulation);
      final pmsWindow = getPmsWindow(start);

      final periodWindow = List<DateTime>.generate(end
        .difference(start)
        .inDays + 1,
        (i) => start.add(Duration(days: i)),
      );

      print('\nMonth ${i + 1}');

      print('Period Window:');
      for (var day in periodWindow) {
        print('- ${format.format(day)}');
      }

      print('Ovulation: ${format.format(ovulation)}');

      print('Fertile Window:');
      for (var day in fertileWindow) {
        print('- ${format.format(day)}');
      }

      print('PMS Window:');
      for (var day in pmsWindow) {
        print('- ${format.format(day)}');
      }
    }
  }
}
