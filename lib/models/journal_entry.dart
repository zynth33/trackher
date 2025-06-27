class JournalEntry {
  final String id;
  final String emoji;
  final String date;
  final String mood;
  final String entry;
  final String? flow;
  final List<String>? symptoms;

  JournalEntry(this.emoji, this.date, this.mood, this.entry, this.symptoms, this.id,
      {this.flow = ""});
}