import 'dart:io';

import 'package:flutter/material.dart';

import '../../pages/journal_page/_components/top_calender.dart';
import '../../utils/components/mixins/glowing_background_mixin.dart';
import '../../utils/components/screen_title.dart';
import '_components/enter_entry_card.dart';
import '_components/recent_entries.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Platform.isIOS ? 40 : 20),
                    ScreenTitle(title: "Ovlo Notes",),
                    TopCalender(),
                    SizedBox(height: 25,),
                    EnterEntryCard(),
                    SizedBox(height: 20,),
                    RecentEntries(),
                    SizedBox(height: 100,),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -80,
            child: IgnorePointer(
              child: Image.asset('assets/gradients/grad_6.png'),
            ),
          ),
          Positioned(
            bottom: -155,
            left: -130,
            child: IgnorePointer(
              child: Image.asset('assets/gradients/grad_7.png'),
            ),
          ),
        ],
      ),
    );
  }
}









