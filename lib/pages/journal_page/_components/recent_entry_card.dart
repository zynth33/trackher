import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/period_repository.dart';
import '../../../models/journal_entry.dart';
import '../../../utils/components/dialogs/confirm_dialog.dart';

class RecentEntryCard extends StatelessWidget {
  final JournalEntry entry;
  const RecentEntryCard({
    super.key, required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 13.0),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withValues(alpha: Theme.of(context).brightness == Brightness.light ? 0.2 : 0.5),
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: Center(child: Text(entry.emoji, style: TextStyle(
                        fontSize: 18
                      ),)),
                    ),
                    SizedBox(width: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('MMMM d, y').format(DateTime.parse(entry.date)), style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600
                        ),),
                        Text(entry.mood, style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        ),)
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Text(entry.entry, style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    fontSize: 14
                )),
                SizedBox(height: 15,),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment:WrapAlignment.start,
                  spacing: 10,
                  runSpacing: 10,
                  children: entry.symptoms != null ? entry.symptoms!.map((symptom) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(20, 0, 0, 0),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Text(symptom, style: TextStyle(
                          fontSize: 12,
                          color: Colors.white
                      ),),
                    );
                  }).toList() : [SizedBox.shrink()]
                )
              ],
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => const ConfirmDeleteDialog(),
                );

                if (shouldDelete == true) {
                  await PeriodRepository().deleteJournalEntry(entry.id);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.pink.shade200,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(20, 0, 0, 0),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}