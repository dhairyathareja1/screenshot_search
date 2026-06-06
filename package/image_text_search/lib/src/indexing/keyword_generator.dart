class KeywordGenerator {
  static const Set<String> _stopWords = {
    'a',
    'an',
    'the',
    'is',
    'it',
    'in',
    'on',
    'at',
    'to',
    'for',
    'of',
    'and',
    'or',
    'but',
    'not',
    'with',
    'this',
    'that',
    'was',
    'are',
    'be',
    'as',
    'by',
    'from',
    'has',
    'had',
    'he',
    'she',
    'we',
    'you',
    'i',
    'my',
    'your',
    'its',
    'our',
    'their',
    'will',
    'can',
    'do',
    'did',
    'have',
    'been',
    'if',
    'so',
    'up',
    'out',
    'no',
    'me',
    'him',
    'her',
    'us',
    'am',
    'than',
    'more',
    'into',
    'about',
    'also',
  };

  List<String> generate(String text) {
    if (text.trim().isEmpty) return [];
    final String lowered = text.toLowerCase();
    final List<String> rawWords = lowered.split(RegExp(r'[^\w₹]+'));
    final Set<String> seen = {};
    final List<String> keywords = [];

    for (final String word in rawWords) {
      final String betterWord = word.replaceAll(RegExp(r'[₹$€£]'), '');
      if (betterWord.isEmpty) continue;
      if (betterWord.length < 2) continue;
      if (_stopWords.contains(betterWord)) continue;
      if (seen.contains(betterWord)) continue;
      seen.add(betterWord);
      keywords.add(betterWord);
    }
    return keywords;
  }

  bool hasKeywordOverlap({required String query, required String text}) {
    final List<String> queryKeywords = generate(query);
    final List<String> textKeywords = generate(text);

    for (final String keyword in queryKeywords) {
      if (textKeywords.contains(keyword)) {
        return true;
      }
    }
    return false;
  }
}
