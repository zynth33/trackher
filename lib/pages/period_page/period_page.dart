import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/components/bottom_nav_icon.dart';
import '../home_page/home_page.dart';
import '../calender_page/calender_page.dart';
import '../ai_chat_page/ai_chat_page.dart';
import '../journal_page/journal_page.dart';
import '../settings_page/settings_page.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class PeriodPage extends StatefulWidget {
  const PeriodPage({super.key});

  @override
  State<PeriodPage> createState() => _PeriodPageState();
}

class _PeriodPageState extends State<PeriodPage> {
  int page = 0;
  int doubleTapped = 25;

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(onSettingsTap: onSettingsTap,),
      CalenderPage(),
      JournalPage(),
      AIChatPage(),
      SettingsPage()
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).brightness);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.pink.shade100,
                ],
              ),
            ),
            child: pages[page],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    BottomNavIcon(
                      backgroundColor: Colors.pinkAccent.shade100,
                      icon: Symbols.home_rounded,
                      name: "Home",
                      onTap: () {
                        setState(() {
                          if(page == 0) {
                            doubleTapped = 0;
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted && doubleTapped == 0) {
                                setState(() {
                                  doubleTapped = 25;
                                });
                              }
                            });
                          } else {
                            page = 0;
                            doubleTapped = 0;
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted && doubleTapped == 0) {
                                setState(() {
                                  doubleTapped = 25;
                                });
                              }
                            });
                          }
                        });
                      },
                      selected: page == 0,
                      doubleTapped: doubleTapped == 0,
                    ),
                    BottomNavIcon(
                      backgroundColor: Colors.deepPurple.shade100,
                      icon: Icons.calendar_today_outlined,
                      name: "Calender",
                      onTap: () {
                        setState(() {
                          if(page == 1) {
                            doubleTapped = 1;
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted && doubleTapped == 1) {
                                setState(() {
                                  doubleTapped = 25;
                                });
                              }
                            });
                          } else {
                            page = 1;
                            doubleTapped = 1;
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted && doubleTapped == 1) {
                                setState(() {
                                  doubleTapped = 25;
                                });
                              }
                            });
                          }
                        });
                      },
                      selected: page == 1,
                      doubleTapped: doubleTapped == 1,
                    ),
                    BottomNavIcon(
                      backgroundColor: Colors.blue.shade100,
                      icon: Symbols.import_contacts_rounded,
                      name: "Journal",
                      onTap: () {
                        setState(() {
                          if(page == 2) {
                            doubleTapped = 2;
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted && doubleTapped == 2) {
                                setState(() {
                                  doubleTapped = 25;
                                });
                              }
                            });
                          } else {
                            page = 2;
                            doubleTapped = 2;
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted && doubleTapped == 2) {
                                setState(() {
                                  doubleTapped = 25;
                                });
                              }
                            });
                          }
                        });
                      },
                      selected: page == 2,
                      doubleTapped: doubleTapped == 2,
                    ),
                    BottomNavIcon(
                      backgroundColor: Colors.greenAccent.shade100,
                      icon: FontAwesomeIcons.comment,
                      name: "AI Chat",
                      onTap: () {
                       setState(() {
                         if(page == 3) {
                           doubleTapped = 3;
                           Future.delayed(const Duration(seconds: 2), () {
                             if (mounted && doubleTapped == 3) {
                               setState(() {
                                 doubleTapped = 25;
                               });
                             }
                           });
                         } else {
                           page = 3;
                           doubleTapped = 3;
                           Future.delayed(const Duration(seconds: 2), () {
                             if (mounted && doubleTapped == 3) {
                               setState(() {
                                 doubleTapped = 25;
                               });
                             }
                           });
                         }
                       });
                      },
                      selected: page == 3,
                      doubleTapped: doubleTapped == 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSettingsTap() {
    setState(() {
      page = 4;
    });
  }
}

