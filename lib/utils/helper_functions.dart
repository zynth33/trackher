import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../services/notification_service.dart';
import '../sessions/period_session.dart';

bool isPastDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);

  return target.isBefore(today);
}

bool dateExistsInSet(DateTime target, Set<DateTime> dates) {
  final normalizedTarget = DateTime(target.year, target.month, target.day);
  return dates.any((d) =>
  d.year == normalizedTarget.year &&
      d.month == normalizedTarget.month &&
      d.day == normalizedTarget.day);
}

T? getValueForDateInMap<T>(DateTime target, Map<DateTime, T> map) {
  final normalizedTarget = DateTime(target.year, target.month, target.day);
  for (var entry in map.entries) {
    final d = entry.key;
    if (d.year == normalizedTarget.year &&
        d.month == normalizedTarget.month &&
        d.day == normalizedTarget.day) {
      return entry.value;
    }
  }
  return null;
}

Widget getMessageForDate(DateTime date) {
  String auxVerb = "Was";
  if (isPastDate(date)) {
    auxVerb = "Was";
  } else {
    auxVerb = "Will be";
  }

  if (dateExistsInSet(date, PeriodSession().ovulationDays)) {
    return Text(
      "$auxVerb a high chance to get pregnant",
      style: TextStyle(color: Colors.grey, fontSize: 14),
    );
  } else if (dateExistsInSet(date, PeriodSession().fertileDays)) {
    return Text(
      "$auxVerb a chance to get pregnant",
      style: TextStyle(color: Colors.grey, fontSize: 14),
    );
  } else if (dateExistsInSet(date, PeriodSession().pmsDays)) {
    return Text(
      "$auxVerb a chance to get a period",
      style: TextStyle(color: Colors.grey, fontSize: 14),
    );
  } else if (dateExistsInSet(date, PeriodSession().periodDays)) {
    return Text(
      "$auxVerb a high chance to get a period",
      style: TextStyle(color: Colors.grey, fontSize: 14),
    );
  }

  return const SizedBox.shrink();
}

Future<void> scheduleNotification({
  required DateTime date,
  required String title,
  required String body,
  required int id,
}) async {
  final now = DateTime.now();
  final scheduledDate = DateTime(date.year, date.month, date.day, 8); // 8AM

  if (scheduledDate.isBefore(now)) return;

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduledDate, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'period_channel',
        'Period Notifications',
        channelDescription: 'Notifications for period cycle',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
  );
}

T getRandom<T>(List<T> list) => list[Random().nextInt(list.length)];

DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

