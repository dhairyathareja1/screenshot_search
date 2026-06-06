class TextMatcher {
  bool containsPhrase({required String text, required String phrase}) {
    if (text.isEmpty || phrase.isEmpty) return false;
    return text.toLowerCase().contains(phrase.toLowerCase());
  }

  int findMatchIndex({required String text, required String query}) {
    if (text.isEmpty || query.isEmpty) return -1;
    return text.toLowerCase().indexOf(query.toLowerCase());
  }

  double score({required String text, required String query}) {
    if (text.isEmpty || query.isEmpty) return 0.0;

    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.trim().toLowerCase();

    if (lowerText.contains(lowerQuery)) {
      return 1.0;
    }

    final List<String> queryWords = lowerQuery
        .split(RegExp(r'\s+'))
        .where((word) => word.length >= 2)
        .toList();

    if (queryWords.isEmpty) return 0.0;

    int matchCount = 0;
    for (final String word in queryWords) {
      if (lowerText.contains(word)) {
        matchCount++;
      }
    }

    return matchCount / queryWords.length;
  }

  int countOccurrences({required String text, required String query}) {
    if (text.isEmpty || query.isEmpty) return 0;

    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();

    int count = 0;
    int startIndex = 0;

    while (true) {
      final int index = lowerText.indexOf(lowerQuery, startIndex);
      if (index == -1) break;
      count++;
      startIndex = index + lowerQuery.length;
    }
    return count;
  }
}
