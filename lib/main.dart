import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:trackher/pages/period_date_selection_page/period_date_selection_page.dart';
import 'package:trackher/services/notification_service.dart';
import 'package:trackher/sessions/symptoms_session.dart';
import './repositories/period_repository.dart';
import './sessions/period_session.dart';
import './pages/period_page/period_page.dart';
import 'firebase_options.dart';
import 'models/past_period.dart';
import 'models/period_prediction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize timezones (for zoned notifications)
  tz.initializeTimeZones();

  // Local notification setup
  await initNotifications();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PeriodPredictionAdapter());
  Hive.registerAdapter(PastPeriodAdapter());

  await Hive.openBox<PeriodPrediction>('predictions');
  await Hive.openBox<PastPeriod>('pastPeriods');
  await Hive.openBox('periodCycleData');
  await Hive.openBox('periodMetaData');

  // Load any app-specific state
  await PeriodRepository().loadRecentJournalEntries();

  // Run the app
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    setData();
    final _ = PeriodRepository();
    SymptomsSession().setDate(DateTime.now());

    return MaterialApp(
      title: 'TrackHer',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark
        )
      ),
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        )
      ),
      home: PeriodSession().periodDays.isNotEmpty ? PeriodPage() : PeriodDateSelectionPage(),
    );
  }
  
  void setData() {
    final Box<PeriodPrediction> periodPredictionBox = Hive.box<PeriodPrediction>('predictions');
    final Box<PastPeriod> pastPeriodBox = Hive.box<PastPeriod>('pastPeriods');
    var periodMetaDataBox = Hive.box('periodMetaData');
    var periodCycleDataBox = Hive.box('periodCycleData');

    final Set<DateTime> allPeriodDays = {};
    final Set<DateTime> allFertileDays = {};
    final Set<DateTime> allPmsDays = {};
    final Set<DateTime> allOvulationDays = {};

    if (periodPredictionBox.isNotEmpty) {
      final allPredictions = periodPredictionBox.values.toList();

      for (final prediction in allPredictions) {
        allPeriodDays.addAll(prediction.periodWindow.map((d) => DateTime.parse(d)));
        allPmsDays.addAll(prediction.pmsWindow.map((d) => DateTime.parse(d)));
        allFertileDays.addAll(prediction.fertileWindow.map((d) => DateTime.parse(d)));
        allOvulationDays.add(DateTime.parse(prediction.ovulation));
      }

      PeriodSession().setPeriodDays(allPeriodDays);
      PeriodSession().setPmsDays(allPmsDays);
      PeriodSession().setFertileDays(allFertileDays);
      PeriodSession().setOvulationDays(allOvulationDays);
    }

    if (pastPeriodBox.isNotEmpty) {
      final List<String> listOfPastPeriods = pastPeriodBox.values.toList()[0].pastPeriods;
      final Set<DateTime> pastPeriods = {};

      for (final period in listOfPastPeriods) {
        pastPeriods.add(DateTime.parse(period));
      }

      allPeriodDays.addAll(pastPeriods);

      PeriodSession().setPeriodDays(allPeriodDays);
    }

    if (periodMetaDataBox.isNotEmpty) {
      PeriodSession().setCycleLength(periodMetaDataBox.get('cycleLength'));
      PeriodSession().setPeriodLength(periodMetaDataBox.get('periodLength'));
    }

    // if (periodCycleDataBox.isNotEmpty) {
    //   PeriodSession().setCycleNumbers(periodCycleDataBox.get('cycleMap'));
    // }

    if (periodCycleDataBox.isNotEmpty) {
      final rawMap = periodCycleDataBox.get('cycleMap') as Map;

      final Map<DateTime, int> convertedMap = rawMap.map(
            (key, value) => MapEntry(DateTime.parse(key.toString()), value as int),
      );

      PeriodSession().setCycleNumbers(convertedMap);
    }
  }
}