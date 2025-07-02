import 'package:hive/hive.dart';

part 'period_prediction.g.dart';

@HiveType(typeId: 0)
class PeriodPrediction extends HiveObject {
  @HiveField(0)
  late String month;

  @HiveField(1)
  late List<String> periodWindow;

  @HiveField(2)
  late String ovulation;

  @HiveField(3)
  late List<String> fertileWindow;

  @HiveField(4)
  late List<String> pmsWindow;

  PeriodPrediction({
    required this.month,
    required this.periodWindow,
    required this.ovulation,
    required this.fertileWindow,
    required this.pmsWindow,
  });

  Map<String, dynamic> toJson() => {
    'month': month,
    'periodWindow': periodWindow,
    'ovulation': ovulation,
    'fertileWindow': fertileWindow,
    'pmsWindow': pmsWindow,
  };
}

