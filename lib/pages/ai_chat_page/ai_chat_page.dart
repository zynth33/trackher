import 'dart:io';

import 'package:flutter/material.dart';
import '../../utils/constants.dart';

import '_components/chat_list.dart';
import '_components/header_row.dart';
import '_components/quick_questions.dart';
import '_components/recent_chats.dart';
import '_components/search_bar_with_focus_border.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}


class _AIChatPageState extends State<AIChatPage> {
  bool searchedOnce = false;
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Platform.isIOS ? 50 : 20),
                HeaderRow(),
                SizedBox(height: 10,),
                searchedOnce ? ChatList(chats: AppConstants.chats) : SizedBox.shrink(),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Quick Questions", style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 20,),
                    QuickQuestions(),
                    SizedBox(height: 20,),
                    SearchBarWithFocusBorder(
                      onSearch: () {
                        setState(() {
                          searchedOnce = true;
                        });
                      },
                    ),
                    SizedBox(height: 20,),
                    Text("Recent Chats", style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),),
                    SizedBox(height: 15,),
                    RecentChats(),
                    SizedBox(height: 10,),
                    Center(
                      child: Text("AI responses are for informational purposes only", style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10
                      ),),
                    ),
                    SizedBox(
                      height: searchedOnce ? 100 : 170,
                    )
                  ],
                ),
              ]
          ),
        ),
      ),
    );
  }
}
