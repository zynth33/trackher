import 'package:hive/hive.dart';

part 'past_period.g.dart';

@HiveType(typeId: 1)
class PastPeriod extends HiveObject {
  @HiveField(0)
  late List<String> pastPeriods;

  PastPeriod({
    required this.pastPeriods
  });

  Map<String, dynamic> toJson() => {
    'pastPeriods': pastPeriods,
  };
}
