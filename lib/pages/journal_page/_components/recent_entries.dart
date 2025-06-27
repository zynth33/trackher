import 'package:flutter/material.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
          ]
              : [Container(height: 250)],
        );
      },
    );
  }
}
