import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../sessions/period_session.dart';
import '../../../utils/helper_functions.dart';

class DayNavigator extends StatefulWidget {
  final DateTime date;
  const DayNavigator({super.key, required this.date});

  @override
  State<DayNavigator> createState() => _DayNavigatorState();
}

class _DayNavigatorState extends State<DayNavigator> {
  DateTime _focusedDay = DateTime.now();
  bool _canGoForward = true;

  String _getDayLabel() {
    final now = DateTime.now();
    final difference = now.difference(_focusedDay).inDays;

    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    return DateFormat('EEE, MMM d').format(_focusedDay);
  }

  void _goToPreviousDay() {
    setState(() {
      _focusedDay = _focusedDay.subtract(const Duration(days: 1));
      _canGoForward = true;
    });
  }

  void _goToNextDay() {
    final now = DateTime.now();
    if (_focusedDay.isBefore(DateTime(now.year, now.month, now.day))) {
      setState(() {
        _focusedDay = _focusedDay.add(const Duration(days: 1));
        _canGoForward = true;
      });

      if (_focusedDay.isAfter(DateTime(now.year, now.month, now.day))) {
        setState(() {
          _canGoForward = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.date;
    final now = DateTime.now();
    if (_focusedDay.isBefore(DateTime(now.year, now.month, now.day))) {
      setState(() {
        _canGoForward = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var cycle = getValueForDateInMap(_focusedDay, PeriodSession().cycleNumbers) == -1 ? "" : "Cycle Day ${getValueForDateInMap(_focusedDay, PeriodSession().cycleNumbers)}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 25),
          onPressed: _goToPreviousDay,
        ),
        Column(
          children: [
            Text(
              _getDayLabel(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            cycle.isNotEmpty ? Text(
              cycle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ) : SizedBox.shrink(),
          ],
        ),
        IconButton(
          icon: Icon(Icons.chevron_right, color: _canGoForward ? Colors.black : Colors.grey, size: 25),
          onPressed: _goToNextDay,
        ),
      ],
    );
  }
}