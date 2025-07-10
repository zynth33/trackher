import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';
import '../../../repositories/journal_repository.dart';
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
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 13.0),
                decoration: BoxDecoration(
                  color: HexColor.fromHex(AppConstants.primaryWhite),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(60),
                      blurRadius: 10,
                      offset: const Offset(1, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEE, MMM d').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('y').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      entry.entry,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.7),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              // Inner shadow overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                  await JournalRepository().deleteJournalEntry(entry.id);
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