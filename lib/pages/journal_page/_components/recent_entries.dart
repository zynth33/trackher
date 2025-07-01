import 'package:flutter/material.dart';
import 'package:trackher/utils/assets.dart';

import '../_components/recent_entry_card.dart';
import '../../../models/journal_entry.dart';
import '../../../repositories/period_repository.dart';

class RecentEntries extends StatelessWidget {
  const RecentEntries({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = PeriodRepository();

    return ValueListenableBuilder<List<JournalEntry>>(
      valueListenable: PeriodRepository().recentEntriesNotifier,
      builder: (context, entries, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: entries.isNotEmpty
              ? [
            const Text("Recent Entries", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
              color: Colors.pinkAccent
            ), textAlign: TextAlign.center,),
            Center(
              child: Image.asset(
                AppAssets.postNoJournalEntries,
                height: 160,
                width: 160,
              ),
            )
          ],
        );
      },
    );
  }
}
