import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/screenshot_model.dart';
import '../repository/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository;
  List<ScreenshotModel> _allScreenshots = [];

  SearchBloc({required SearchRepository repository})
      : _repository = repository,
        super(SearchNotIndexed()) {
    on<SearchScreenshotsLoaded>(_onScreenshotsLoaded);
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchCleared>(_onCleared);
  }

  void _onScreenshotsLoaded(
    SearchScreenshotsLoaded event,
    Emitter<SearchState> emit,
  ) {
    _allScreenshots = event.screenshots;
    if (_allScreenshots.isEmpty) {
      emit(SearchNotIndexed());
    } else {
      emit(SearchInitial()); // ready to search
    }
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final String query = event.query.trim();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    if (_allScreenshots.isEmpty) {
      emit(SearchNotIndexed());
      return;
    }

    emit(SearchLoading());

    try {
      final results = _repository.search(
        query: query,
        screenshots: _allScreenshots,
      );

      if (results.isEmpty) {
        emit(SearchEmpty(query: query));
      } else {
        emit(SearchResults(results: results, query: query));
      }
    } catch (e) {
      emit(SearchError(message: 'Search failed: ${e.toString()}'));
    }
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
