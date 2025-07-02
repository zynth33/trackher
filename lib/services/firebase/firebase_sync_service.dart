import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../models/past_period.dart';
import '../../models/period_prediction.dart';

class FirebaseSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncUserPeriodData(String uid) async {
    try {
      final pastPeriodsBox = Hive.box<PastPeriod>('pastPeriods');
      final metadataBox = Hive.box('periodMetaData');
      final predictionsBox = Hive.box<PeriodPrediction>('predictions');

      final pastPeriodsMap = {
        for (var key in pastPeriodsBox.keys)
          key.toString(): pastPeriodsBox.get(key)?.toJson()
      };

      final metadataMap = {
        for (var key in metadataBox.keys)
          key.toString(): metadataBox.get(key)
      };

      final predictionsMap = {
        for (var key in predictionsBox.keys)
          key.toString(): predictionsBox.get(key)?.toJson()
      };

      await _firestore.collection('pastPeriods').doc(uid).set(pastPeriodsMap);
      await _firestore.collection('periodMetaData').doc(uid).set(metadataMap);
      await _firestore.collection('predictions').doc(uid).set(predictionsMap);
    } catch (e) {
      print("Firestore sync error: $e");
    }
  }
}
