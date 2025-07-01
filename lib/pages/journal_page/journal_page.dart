import 'dart:io';

import 'package:flutter/material.dart';

import '_components/enter_entry_card.dart';
import '_components/recent_entries.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
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
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Platform.isIOS ? 40 : 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text("Journal", style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ), textAlign: TextAlign.center,),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text("Your private thoughts and feelings", style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal
                ), textAlign: TextAlign.center,),
              ),
              SizedBox(height: 20,),
              EnterEntryCard(),
              SizedBox(height: 20,),
              RecentEntries(),
              SizedBox(height: 100,),
            ],
          ),
        ),
      ),
    );
  }
}









