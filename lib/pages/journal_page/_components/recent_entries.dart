import 'package:flutter/material.dart';

import '../../../utils/assets.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';
import '../../../models/journal_entry.dart';
import '../../../repositories/journal_repository.dart';

import 'recent_entry_card.dart';

class RecentEntries extends StatelessWidget {
  const RecentEntries({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = JournalRepository();

    return ValueListenableBuilder<List<JournalEntry>>(
      valueListenable: JournalRepository().recentEntriesNotifier,
      builder: (context, entries, _) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: HexColor.fromHex(AppConstants.primaryWhite),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(60, 0, 0, 0),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.27)
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.isNotEmpty ? [
              Text("Your Journal", style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black.withValues(alpha: 0.7)
              )),
              const SizedBox(height: 15),
              ...entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: RecentEntryCard(entry: entry),
              )),
            ] : [
              Text("No entries found!", style: TextStyle(
                fontFamily: "Mali",
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: HexColor.fromHex(AppConstants.primaryText)
              ), textAlign: TextAlign.center,),
              Center(
                child: Image.asset(
                  AppAssets.postNoJournalEntries,
                  height: 160,
                  width: 160,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
