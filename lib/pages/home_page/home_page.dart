import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/components/mixins/glowing_background_mixin.dart';
import '../../utils/components/screen_title.dart';
import '../../utils/enums.dart';
import '../../sessions/dates_session.dart';
import '../../sessions/period_session.dart';
import '../../utils/helper_functions.dart';
import '_components/banner_widget.dart';
import '_components/static_period_calender.dart';
import '_components/home_header.dart';
import '_components/menstrual_flow.dart';
import '_components/mood.dart';
import '_components/period_cycle_card.dart';
import '_components/period_data_cards.dart';
import '_components/symptom.dart';
import '_components/top_calender.dart';

class HomePage extends StatelessWidget with GlowingBackgroundMixin {
  final VoidCallback onSettingsTap;

  const HomePage({
    super.key,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<DateTime, Map<String, dynamic>>>(
      valueListenable: DatesSession().dataMapNotifier,
      builder: (context, dataMap, _) {
        return ValueListenableBuilder(
          valueListenable: DatesSession().selectedDateNotifier,
          builder: (context, selectedDate, _) {
            final today = normalizeDate(DateTime.now());

            final rawFlow = DatesSession().getValueForKey(selectedDate, 'flow');
            FlowLevel? flow;
            if (rawFlow is String) {
              flow = FlowLevel.values.firstWhere(
                (e) => e.name == rawFlow,
              );
            }

            final showBanner =
              DatesSession().getValueForKey(today, 'flow') == null &&
                (PeriodSession().periodDays.contains(today) ||
                PeriodSession().pmsDays.contains(today));

            return ValueListenableBuilder<bool>(
              valueListenable: DatesSession().isSelectedDatePastTodayNotifier,
              builder: (context, isPastToday, _) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(100),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1,
                        child: child,
                      ),
                      child: showBanner
                          ? BannerWidget(key: const ValueKey('banner'))
                          : const SizedBox.shrink(key: ValueKey('empty')),
                    ),
                  ),
                  body: withGlowingBackground(
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          // gradient: backgroundGradient,
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(7.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              ScreenTitle(title: "Ovlo Home",),
                              HomeHeader(onSettingsTap: onSettingsTap),
                              // const SizedBox(height: 20),
                              TopCalender(),
                              const SizedBox(height: 20),
                              PeriodCycleCard(),
                              isPastToday ? Column(
                                children: [
                                  const SizedBox(height: 20),
                                  MenstrualFlow(),
                                  const SizedBox(height: 20),
                                  Mood(),
                                  const SizedBox(height: 20),
                                  Symptoms(),
                                  const SizedBox(height: 20),
                                  PeriodDataCards(),
                                ],
                              ) : SizedBox.shrink(),
                              const SizedBox(height: 20),
                              StaticPeriodCalendar(),
                              const SizedBox(height: 150),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            );
          }
        );
      },
    );
  }
}
