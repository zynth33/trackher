import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

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
              color: HexColor.fromHex(AppConstants.primaryWhite),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(60),
                  blurRadius: 10,
                  offset: const Offset(1, 3),
                ),
              ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('EEE, MMM d').format(DateTime.now()), style: TextStyle(
                      fontSize: 12,
                      color: HexColor.fromHex("#7A38B1").withValues(alpha: 0.8)
                    ),),
                    Text(DateFormat('y').format(DateTime.now()), style: TextStyle(
                      fontSize: 12,
                      color: HexColor.fromHex("#7A38B1").withValues(alpha: 0.8)
                    ),),
                  ],
                ),
                SizedBox(height: 10,),
                Text(entry.entry, style: TextStyle(
                  color: HexColor.fromHex(AppConstants.primaryText),
                  fontSize: 15
                )),
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
                  color: HexColor.fromHex(AppConstants.primaryColorLight),
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