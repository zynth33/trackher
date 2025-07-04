import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';
import '../../utils/components/bottom_nav_icon.dart';
import '../home_page/home_page.dart';
import '../calender_page/calender_page.dart';
import '../ai_chat_page/ai_chat_page.dart';
import '../journal_page/journal_page.dart';

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
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    // throw Exception("The following assertion was thrown while dispatching notifications for ValueNotifier<bool>:setState() or markNeedsBuild() called during build.");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageTransitionSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation, secondaryAnimation) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(page),
              child: pages[page],
            ),
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
                      backgroundColor: HexColor.fromHex(AppConstants.navHome),
                      icon: SizedBox(
                        height: 22,
                        width: 22,
                        child: SvgPicture.asset(AppAssets.iconNavHome)
                      ),
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
                      backgroundColor: HexColor.fromHex(AppConstants.navCalender),
                      icon: SizedBox(
                        height: 22,
                        width: 22,
                        child: SvgPicture.asset(AppAssets.iconNavCalender)
                      ),
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
                      backgroundColor: HexColor.fromHex(AppConstants.navJournal).withValues(alpha: 0.5),
                      icon: SizedBox(
                        height: 22,
                        width: 22,
                        child: SvgPicture.asset(AppAssets.iconNavJournal)
                      ),
                      name: "Notes",
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
                      backgroundColor: HexColor.fromHex(AppConstants.navAiChat),
                      icon: SizedBox(
                        height: 22,
                        width: 22,
                        child: SvgPicture.asset(AppAssets.iconNavAiChat)
                      ),
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

