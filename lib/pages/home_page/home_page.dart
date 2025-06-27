import 'dart:io';

import 'package:flutter/cupertino.dart';

import '_components/static_period_calender.dart';
import '_components/home_header.dart';
import '_components/menstrual_flow.dart';
import '_components/mood.dart';
import '_components/period_cycle_card.dart';
import '_components/period_data_cards.dart';
import '_components/symptom.dart';
import '_components/top_calender.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onSettingsTap;

  const HomePage({
    super.key, required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(7.0),
      child: Column(
        children: [
          SizedBox(height: Platform.isIOS ? 40 : 20),
          HomeHeader(onSettingsTap: onSettingsTap,),
          const SizedBox(height: 20),
          TopCalender(),
          const SizedBox(height: 20),
          PeriodCycleCard(),
          const SizedBox(height: 20),
          MenstrualFlow(),
          const SizedBox(height: 20),
          Mood(),
          const SizedBox(height: 20),
          Symptoms(),
          const SizedBox(height: 20),
          PeriodDataCards(),
          const SizedBox(height: 20),
          StaticPeriodCalendar(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}