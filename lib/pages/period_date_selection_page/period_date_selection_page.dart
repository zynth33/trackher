import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/components/day_circle.dart';
import '../../pages/period_page/period_page.dart';
import '../../models/past_period.dart';
import '../../models/period_prediction.dart';
import '../../models/period_tracker.dart';
import '../../sessions/period_session.dart';

class PeriodDateSelectionPage extends StatefulWidget {
  final bool allowFutureMonths;

  const PeriodDateSelectionPage({super.key, this.allowFutureMonths = false});

  @override
  State<PeriodDateSelectionPage> createState() => _PeriodDateSelectionPageState();
}

class _PeriodDateSelectionPageState extends State<PeriodDateSelectionPage> {
  final Set<DateTime> _selectedDates = {};
  final ScrollController _scrollController = ScrollController();
  final today = DateTime.now();

  late List<DateTime> _monthList;

  @override
  void initState() {
    super.initState();
    _generateMonthList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToInitialPosition();
      
      if (widget.allowFutureMonths) {
        _selectedDates.addAll(PeriodSession().periodDays);
      }
    });
  }

  void _scrollToInitialPosition() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    final index = _monthList.indexWhere((date) =>
    date.year == currentMonth.year && date.month == currentMonth.month);

    if (index != -1) {
      const itemHeight = 330.0;
      final position = index * itemHeight;

      _scrollController.jumpTo(position);
    }
  }

  void _generateMonthList() {
    final now = DateTime.now();
    final start = DateTime(now.year - 2, now.month);

    final extraMonth = DateTime(now.year, now.month + 1);
    final end = widget.allowFutureMonths
      ? DateTime(now.year + 1, 12)
      : extraMonth;

    _monthList = [];
    DateTime current = start;
    while (current.isBefore(end.add(const Duration(days: 1)))) {
      _monthList.add(current);
      current = DateTime(current.year, current.month + 1);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  void _onDaySelected(DateTime selectedDay, DateTime _) {
    final today = DateTime.now();
    final now = DateTime(today.year, today.month, today.day);
    final clickedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    final isFuture = clickedDay.isAfter(now);

    setState(() {
      final isAlreadySelected = _selectedDates.any((d) => _isSameDay(d, clickedDay));

      if (isAlreadySelected) {
        if (isFuture && widget.allowFutureMonths) return;

        _selectedDates.removeWhere((d) => _isSameDay(d, clickedDay));
      } else {
        if (isFuture) return;

        _selectedDates.add(clickedDay);

        final isTooClose = _selectedDates
            .where((d) => !_isSameDay(d, clickedDay))
            .any((d) => (d.difference(clickedDay).inDays).abs() < 14);

        if (!isTooClose) {
          final additionalDays = List.generate(4, (i) {
            return DateTime(clickedDay.year, clickedDay.month, clickedDay.day + i + 1);
          });

          _selectedDates.addAll(additionalDays);
        }
      }
    });
  }

  bool _isSelected(DateTime day) {
    return _selectedDates.any((d) => _isSameDay(d, day));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.allowFutureMonths,
        title: const Text('Select Period Dates', style: TextStyle(
          fontSize: 20
        )),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: _selectedDates.isEmpty
                ? null
                : () {
                try {
                  if (widget.allowFutureMonths) {
                    final normalizedSelected = _selectedDates.map(normalize).toSet();
                    final normalizedSession = PeriodSession().periodDays.map(normalize).toSet();

                    final isSameLength = normalizedSelected.length == normalizedSession.length;
                    final isSameSet = normalizedSelected.containsAll(normalizedSession);

                    if (!isSameLength || !isSameSet) {
                      generatePeriods();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (mounted && context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    } else {
                      if (mounted && context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  } else {
                    generatePeriods();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => PeriodPage()),
                        );
                      }
                    });
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceAll("Exception:", "").trim(),
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: _selectedDates.isEmpty ? Colors.grey : Colors.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: _monthList.length,
        itemBuilder: (context, index) {
          final month = _monthList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Text(
                  '${_monthName(month.month)} ${month.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                TableCalendar(
                  firstDay: DateTime(month.year, month.month),
                  lastDay: DateTime(month.year, month.month + 1, 0),
                  focusedDay: month,
                  selectedDayPredicate: _isSelected,
                  onDaySelected: _onDaySelected,
                  availableGestures: AvailableGestures.none,
                  headerVisible: false,
                  calendarFormat: CalendarFormat.month,
                  daysOfWeekVisible: true,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: true,
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.grey),
                    weekendStyle: TextStyle(color: Colors.grey),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      if (widget.allowFutureMonths) {
                        if (PeriodSession().periodDays.any((d) => _isSameDay(d, day))) {
                          return buildCircle(
                            day: day,
                            fill: day.isAfter(today) ? Colors.pink.withValues(alpha: 0.35) : Colors.transparent,
                            textColor: day.isAfter(today) ? Colors.pink : Colors.black,
                            showDot: day.isAfter(today) ? !_isSameDay(day, DateTime.now()) : false,
                            isNormal: false,
                          );
                        }

                        if (PeriodSession().pmsDays.any((d) => _isSameDay(d, day))) {
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

                        if (PeriodSession().ovulationDays.any((d) => _isSameDay(d, day))) {
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

                        if (PeriodSession().fertileDays.any((d) => _isSameDay(d, day))) {
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
                      } else {
                        final now = DateTime.now();
                        final isFuture = day.isAfter(DateTime(now.year, now.month, now.day));
                        return buildCircle(day: day, fill: Colors.transparent, textColor: isFuture ? Colors.grey : null);
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void generatePeriods() {
    final todayDate = DateTime(today.year, today.month, today.day);

    final sortedDates = _selectedDates
        .where((d) => !widget.allowFutureMonths || d.isBefore(todayDate) || _isSameDay(d, todayDate))
        .toList()
      ..sort((a, b) => a.compareTo(b));

    List<DateTime> pastPeriods = sortedDates;
    int oldestYear = PeriodTracker.getOldestYear(pastPeriods);
    int limitYear = oldestYear + 2;

    PeriodSession().setOldestYear(oldestYear);
    PeriodSession().setLimitYear(limitYear);

    final stats = PeriodTracker.calculateCycleStats(pastPeriods);

    final tracker = PeriodTracker(
      periodStartDates: _extractPeriodStarts(pastPeriods),
      averageCycleLength: stats.averageCycleLength,
      periodLength: stats.periodLength,
    );

    PeriodSession().setCycleLength(stats.averageCycleLength);
    PeriodSession().setPeriodLength(stats.periodLength);

    final predictionMap = tracker.getPredictions(months: 120);
    // PeriodSession().setPredictions(predictionMap);

    final allPredictions = predictionMap['predictions']!;

    setPeriodsInLocalStorage(allPredictions);
    setPastPeriodsInLocalStorage(pastPeriods.toSet());


    final Set<DateTime> allPeriodDays = pastPeriods.toSet();
    final Set<DateTime> allPmsDays = {};
    final Set<DateTime> allFertileDays = {};
    final Set<DateTime> allOvulationDays = {};

    for (final monthData in allPredictions) {
      allPeriodDays.addAll(_parseDateList(monthData['periodWindow']));
      allPmsDays.addAll(_parseDateList(monthData['pmsWindow']));
      allFertileDays.addAll(_parseDateList(monthData['fertileWindow']));
      allOvulationDays.add(DateTime.parse(monthData['ovulation']));
    }

    // print(pastPeriods.toSet());
    // print(allPeriodDays);

    final now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 1, 1, 1);
    final DateTime lastDate = DateTime(PeriodSession().limitYear, 12, 31);

    final Map<DateTime, Map<String, int>> cycleMap = {};

    for (DateTime date = firstDate; !date.isAfter(lastDate); date = date.add(const Duration(days: 1))) {
      final info = tracker.getCycleInfo(date);

      if (info != null) {
        if (kDebugMode) {
          print("$date => Day: ${info['cycleDay']}, Cycle: ${info['cycleNumber']}");
        }

        cycleMap[date] = {
          'cycleDay': info['cycleDay']!,
          'cycleNumber': info['cycleNumber']!,
        };
      }
    }

    PeriodSession().setCycleNumbers(cycleMap);

    var box = Hive.box('periodCycleData');
    box.put('cycleMap', cycleMap);

    PeriodSession().setFertileDays(allFertileDays);
    PeriodSession().setOvulationDays(allOvulationDays);
    PeriodSession().setPeriodDays(allPeriodDays);
    PeriodSession().setPmsDays(allPmsDays);

    setPeriodMetaData(stats.periodLength, stats.averageCycleLength);
  }

  /// Converts string date list back to DateTime
  Set<DateTime> _parseDateList(List<dynamic> list) {
    return list.map((e) => DateTime.parse(e)).toSet();
  }

  /// Picks only first day of each period group (used for `periodStartDates`)
  List<DateTime> _extractPeriodStarts(List<DateTime> allDates) {
    allDates.sort();
    List<DateTime> starts = [];
    for (int i = 0; i < allDates.length; i++) {
      if (i == 0 || allDates[i]
          .difference(allDates[i - 1])
          .inDays > 1) {
        starts.add(allDates[i]);
      }
    }
    return starts;
  }

  void setPeriodsInLocalStorage(List<Map<String, dynamic>> allPredictions) async {
    final Box<PeriodPrediction> box = Hive.box<PeriodPrediction>('predictions');

    await box.clear();

    for (final monthData in allPredictions) {
      final prediction = PeriodPrediction(
        month: monthData['month'],
        periodWindow: List<String>.from(monthData['periodWindow']),
        ovulation: monthData['ovulation'],
        fertileWindow: List<String>.from(monthData['fertileWindow']),
        pmsWindow: List<String>.from(monthData['pmsWindow']),
      );

      await box.add(prediction);
    }
  }

  void setPastPeriodsInLocalStorage(Set<DateTime> pastPeriods) async {
    final Box<PastPeriod> box = Hive.box<PastPeriod>('pastPeriods');

    await box.clear();

    List<String> allPastPeriods = [];

    for (final period in pastPeriods) {
      allPastPeriods.add(period.toString());
    }

    await box.add(PastPeriod(pastPeriods: allPastPeriods));
  }

  void setPeriodMetaData(int periodLength, int cycleLength) {
    var box = Hive.box('periodMetaData');
    box.put('periodLength', periodLength);
    box.put('cycleLength', cycleLength);
  }

  String _monthName(int month) {
    const monthNames = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month];
  }
}
