import 'package:flutter/material.dart';
import 'package:trackher/models/journal_entry.dart';
import 'package:trackher/repositories/period_repository.dart';
import 'package:trackher/sessions/symptoms_session.dart';

import 'mood_selector.dart';

class EnterEntryCard extends StatefulWidget {
  const EnterEntryCard({
    super.key,
  });

  @override
  State<EnterEntryCard> createState() => _EnterEntryCardState();
}

class _EnterEntryCardState extends State<EnterEntryCard> {
  String? selectedMood;
  String? selectedEmoji;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 13.0),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(20, 0, 0, 0),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("How was your day?", style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 20,),
          Text("Mood", style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold
          ),),
          Center(child: MoodSelector(
            onMoodSelect: (name, emoji) {
              setState(() {
                selectedMood = name;
                selectedEmoji = emoji;
              });
            },
          )),
          SizedBox(height: 20,),
          TextField(
            maxLines: 4,
            cursorColor: Colors.deepPurpleAccent,
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: "Write about your day, how you're feeling, or anything on your mind...",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey,)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3), width: 2)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2)
              ),
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14
              ),
              contentPadding: EdgeInsets.only(left: 10, top: 20, right: 10),
            ),
            style: TextStyle(
                color: Colors.deepPurpleAccent
            ),
            onChanged: (value) {
              if (value.isEmpty || value == "") {
                return;
              }
            },
          ),
          SizedBox(height: 20,),
          SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurpleAccent.shade100,
                      Colors.pinkAccent.shade100
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (textEditingController.text.isEmpty || textEditingController.text == "" || selectedEmoji == null || selectedMood == null) {
                      return;
                    }

                    final allSymptoms = SymptomsSession().symptoms.values.expand((list) => list).toList();

                    print(SymptomsSession().symptoms);

                    JournalEntry entry = JournalEntry(
                        selectedEmoji!,
                        DateTime.now().toString(),
                        selectedMood!,
                        textEditingController.text,
                        allSymptoms,
                        "1"
                    );

                    PeriodRepository().addJournalEntry(entry);
                    textEditingController.text = "";
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    "Save Entry",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}