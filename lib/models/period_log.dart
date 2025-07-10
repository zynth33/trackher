import 'dart:convert';

class PeriodLog {
  final int? id;
  final String date;
  final String? flow;
  final String? mood;
  final List<String>? symptoms;
  final String? type; // 'period', 'pms', 'ovulation', 'fertile', 'normal'
  final String? cycleDayNumber;
  final String? cycleNumber;

  PeriodLog({
    this.id,
    required this.date,
    this.flow,
    this.mood,
    this.symptoms,
    this.type,
    this.cycleDayNumber,
    this.cycleNumber,
  });

  factory PeriodLog.fromMap(Map<String, dynamic> map) {
    return PeriodLog(
      id: map['id'],
      date: map['date'],
      flow: map['flow'],
      mood: map['mood'],
      symptoms: map['symptoms'] != null
          ? List<String>.from(json.decode(map['symptoms']))
          : null,
      type: map['type'],
      cycleDayNumber: map['cycle_day_number'],
      cycleNumber: map['cycle_number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'flow': flow,
      'mood': mood,
      'symptoms': symptoms != null ? json.encode(symptoms) : null,
      'type': type,
      'cycle_day_number': cycleDayNumber,
      'cycle_number': cycleNumber,
    };
  }
}
