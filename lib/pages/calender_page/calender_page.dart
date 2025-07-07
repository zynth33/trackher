import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../sessions/period_session.dart';
import '../../utils/components/screen_title.dart';
import '../../utils/extensions/color.dart';
import '_components/header_row.dart';
import '_components/period_legend.dart';
import '_components/period_calender.dart';
import '_components/yearly_period_calender.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.topRight,
            colors: [
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white.withValues(alpha: 0.4),
              HexColor.fromHex("#F8ADD5").withValues(alpha: 0.4),
              HexColor.fromHex("#337AF7").withValues(alpha: 0.3),
            ]
          )
        ),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(height: Platform.isIOS ? 35 : 30),
                ScreenTitle(title: "Ovlo Calendar",),
                const SizedBox(height: 25),
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
                const SizedBox(height: 40),
                const PeriodLegend(),
                const SizedBox(height: 30),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: isMonth ? 425 : 570,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.09)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 10,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: isMonth ? SingleChildScrollView(
                    child: PeriodCalendar(month: month, year: year),
                  ) : YearlyPeriodPage(year: year),
                ),
                SizedBox(height: isMonth ? 20: 100),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => PeriodDateSelectionPage(allowFutureMonths: true,)));
                //   },
                //   child: Container(
                //     width: double.infinity,
                //     padding: EdgeInsets.symmetric(vertical: 15.0),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: HexColor.fromHex(AppConstants.primaryPurple).withValues(alpha: 0.54)
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(FontAwesomeIcons.penToSquare, size: 16, color: HexColor.fromHex(AppConstants.primaryColorLight),),
                //         SizedBox(width: 10,),
                //         Text("Edit Dates", style: TextStyle(
                //             fontSize: 14,
                //             color: HexColor.fromHex(AppConstants.primaryColorLight),
                //             fontWeight: FontWeight.w600
                //         ),),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 100,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}