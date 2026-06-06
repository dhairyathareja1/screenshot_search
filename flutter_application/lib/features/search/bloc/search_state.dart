import '../../../core/models/screenshot_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchNotIndexed extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResults extends SearchState {
  final List<SearchResultItem> results;
  final String query;
  SearchResults({required this.results, required this.query});
  int get count => results.length;
}

class SearchEmpty extends SearchState {
  final String query;
  SearchEmpty({required this.query});
}

class SearchError extends SearchState {
  final String message;
  SearchError({required this.message});
}

class SearchResultItem {
  final ScreenshotModel screenshot;
  final String preview;
  final double score;

  const SearchResultItem({
    required this.screenshot,
    required this.preview,
    required this.score,
  });
}
