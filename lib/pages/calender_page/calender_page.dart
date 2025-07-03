import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trackher/utils/components/mixins/glowing_background_mixin.dart';
import '../../pages/period_date_selection_page/period_date_selection_page.dart';
import '../../sessions/period_session.dart';
import '../../utils/components/screen_title.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';
import '_components/header_row.dart';
import '_components/period_legacy.dart';
import '_components/period_calender.dart';
import '_components/yearly_period_calender.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> with GlowingBackgroundMixin {
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  bool isMonth = true;
  late String heading = "month, year";

  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    heading = "${DateFormat.MMMM().format(DateTime(1, month))}, $year";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return withGlowingBackground(
      SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              children: [
                SizedBox(height: Platform.isIOS ? 45 : 30),
                ScreenTitle(title: "Ovlo Calender",),
                HeaderRow(
                  incrementMonth: () {
                    setState(() {
                      if(year < PeriodSession().limitYear) {
                        if (isMonth) {
                          if (month > 11) {
                            month = 1;
                            year = year + 1;
                          } else {
                            month = month + 1;
                          }
                          heading = "${DateFormat.MMMM().format(DateTime(1, month))}, $year";
                        } else {
                          year = year + 1;
                          heading = "$year";
                        }
                      }
                    });
                  },
                  decrementMonth: () {
                    setState(() {
                      if (year > PeriodSession().oldestYear - 1) {
                        if(isMonth) {
                          if (month == 0) {
                            month = 11;
                            year = year - 1;
                          } else {
                            month = month - 1;
                          }

                          heading = "${DateFormat.MMMM().format(DateTime(1, month))}, $year";
                        } else {
                          year = year - 1;
                          heading = "$year";
                        }
                      }
                    });
                  },

                  toggleMonthYear: () {
                    setState(() {
                      isLoading = true;
                    });

                    Future.delayed(const Duration(milliseconds: 50), () {
                      setState(() {
                        isMonth = !isMonth;
                        heading = isMonth
                            ? "${DateFormat.MMMM().format(DateTime(1, month))}, $year"
                            : "$year";
                        isLoading = false;
                      });
                    });
                  },

                  isMonth: isMonth,
                  text: heading,
                ),
                const SizedBox(height: 35),
                const PeriodLegacy(),
                const SizedBox(height: 35),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: isMonth ? 425 : 590,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 10,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: isMonth
                      ? SingleChildScrollView(
                    child: PeriodCalendar(month: month, year: year),
                  )
                      : YearlyPeriodPage(year: year),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PeriodDateSelectionPage(allowFutureMonths: true,)));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor.fromHex(AppConstants.primaryPurple).withValues(alpha: 0.54)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.penToSquare, size: 16, color: HexColor.fromHex(AppConstants.primaryColorLight),),
                        SizedBox(width: 10,),
                        Text("Edit Dates", style: TextStyle(
                            fontSize: 14,
                            color: HexColor.fromHex(AppConstants.primaryColorLight),
                            fontWeight: FontWeight.w600
                        ),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}