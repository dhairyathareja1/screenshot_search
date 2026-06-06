import 'package:image_text_search/image_text_search.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/screenshot_model.dart';
import '../bloc/search_state.dart';

class SearchRepository {
  final SearchEngine _searchEngine = SearchEngine();
  List<SearchResultItem> search({
    required String query,
    required List<ScreenshotModel> screenshots,
  }) {
    if (query.trim().isEmpty) return [];

    final keywordGenerator = KeywordGenerator();
    final List<IndexedImage> indexedImages = screenshots.map((s) {
      return IndexedImage(
        id: s.id,
        path: s.path,
        extractedText: s.extractedText,
        indexedAt: s.indexedAt,
        keywords: keywordGenerator.generate(s.extractedText),
      );
    }).toList();

    final List<SearchResult> rawResults = _searchEngine.search(
      query: query,
      images: indexedImages,
      maxResults: AppConstants.searchMaxResults,
      minScore: AppConstants.searchMinScore,
      previewLength: AppConstants.snippetLength,
    );

    return rawResults.map((result) {
      final ScreenshotModel screenshot = screenshots.firstWhere(
        (s) => s.id == result.image.id,
      );

      return SearchResultItem(
        screenshot: screenshot,
        preview: result.preview,
        score: result.score,
      );
    }).toList();
  }
}
