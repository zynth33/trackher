import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trackher/pages/ai_chat_page/_components/marquee_scroll_topics.dart';
import 'package:trackher/utils/components/mixins/glowing_background_mixin.dart';
import 'package:trackher/utils/components/screen_title.dart';
import 'package:trackher/utils/extensions/color.dart';
import '../../utils/constants.dart';

import '_components/chat_list.dart';
import '_components/header_row.dart';
import '_components/quick_questions.dart';
import '_components/recent_chats.dart';
import '_components/chat_bar.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> with GlowingBackgroundMixin {
  bool searchedOnce = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: withGlowingBackground(
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScreenTitle(title: "Ovlo AI", size: 35,),
                  Text("Hi there! I’m Ovlo AI — ask me anything, period.", style: TextStyle(
                    color: HexColor.fromHex(AppConstants.primaryText).withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600
                  ),),
                  SizedBox(height: 15,),
                  Text("Your smart assistant is ready", style: TextStyle(
                    color: HexColor.fromHex("BDAACD"),
                  ),),
                  // searchedOnce ? ChatList(chats: AppConstants.chats) : SizedBox.shrink(),
                  SizedBox(height: 15,),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: AppConstants.titles.map((topic) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: HexColor.fromHex(AppConstants.primaryWhite),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.27)
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(20, 0, 0, 0),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(topic, style: TextStyle(
                          color: HexColor.fromHex(AppConstants.primaryText).withValues(alpha: 0.7),
                          fontSize: 12
                        ),)
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 40,),
                  MarqueeScrollTopics(),
                  ChatBar(onSearch: (){})
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}
