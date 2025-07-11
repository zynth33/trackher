extension SentenceCase on String {
  String toSentenceCase() {
    if (trim().isEmpty) return this;
    final trimmed = trim();
    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }
}