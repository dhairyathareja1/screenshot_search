import '../models/indexed_image.dart';
import '../models/search_result.dart';
import 'text_matcher.dart';

class SearchEngine {
  final TextMatcher _matcher;

  SearchEngine({TextMatcher? matcher}) : _matcher = matcher ?? TextMatcher();

  List<SearchResult> search({
    required String query,
    required List<IndexedImage> images,
    int maxResults = 50,
    double minScore = 0.1,
    int previewLength = 100,
  }) {
    final String trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return [];
    final List<SearchResult> results = [];

    for (final IndexedImage image in images) {
      if (!image.hasText) continue;
      final double matchScore = _calculateScore(
        query: trimmedQuery,
        image: image,
      );

      if (matchScore < minScore) continue;

      final String preview = _buildpreview(
        query: trimmedQuery,
        text: image.extractedText,
        previewLength: previewLength,
      );
      results.add(
        SearchResult(image: image, preview: preview, score: matchScore),
      );
    }
    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(maxResults).toList();
  }

  bool matches({required String query, required IndexedImage image}) {
    if (query.trim().isEmpty || !image.hasText) return false;
    return _matcher.containsPhrase(
      text: image.extractedText,
      phrase: query.trim(),
    );
  }

  double _calculateScore({required String query, required IndexedImage image}) {
    double baseScore = _matcher.score(text: image.extractedText, query: query);

    final int occurrences = _matcher.countOccurrences(
      text: image.extractedText,
      query: query,
    );

    final double occurrenceBonus = (occurrences > 1)
        ? ((occurrences - 1) * 0.05).clamp(0.0, 0.2)
        : 0.0;
    return (baseScore + occurrenceBonus).clamp(0.0, 1.0);
  }

  String _buildpreview({
    required String query,
    required String text,
    required int previewLength,
  }) {
    final int matchIndex = _matcher.findMatchIndex(text: text, query: query);

    if (matchIndex == -1) {
      if (text.length <= previewLength) return text;
      return '${text.substring(0, previewLength)}...';
    }

    final int half = previewLength ~/ 2;
    final int start = (matchIndex - half).clamp(0, text.length);
    final int end = (matchIndex + query.length + half).clamp(0, text.length);
    String preview = text.substring(start, end);
    if (start > 0) preview = '...$preview';
    if (end < text.length) preview = '$preview...';
    return preview;
  }
}
