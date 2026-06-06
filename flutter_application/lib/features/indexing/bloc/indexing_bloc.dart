import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/indexing_repository.dart';
import 'indexing_event.dart';
import 'indexing_state.dart';

class IndexingBloc extends Bloc<IndexingEvent, IndexingState> {
  final IndexingRepository _repository;

  IndexingBloc({required IndexingRepository repository})
      : _repository = repository,
        super(IndexingInitial()) {
    on<LoadSavedScreenshotsEvent>(_onLoadSaved);
    on<StartIndexingEvent>(_onStartIndexing);
  }

  Future<void> _onLoadSaved(
    LoadSavedScreenshotsEvent event,
    Emitter<IndexingState> emit,
  ) async {
    emit(IndexingLoading());

    try {
      final screenshots = await _repository.loadFromDatabase();
      if (screenshots.isEmpty) {
        emit(IndexingInitial());
      } else {
        emit(IndexingSuccess(screenshots: screenshots));
      }
    } catch (e) {
      emit(
          IndexingError(message: 'Failed to load saved data: ${e.toString()}'));
    }
  }

  Future<void> _onStartIndexing(
    StartIndexingEvent event,
    Emitter<IndexingState> emit,
  ) async {
    final bool granted = await _repository.requestPermission();

    if (!granted) {
      final bool permanent = await _repository.isPermissionPermanentlyDenied();
      emit(IndexingPermissionDenied(isPermanentlyDenied: permanent));
      return;
    }

    emit(IndexingInProgress(completed: 0, total: 0));

    try {
      final screenshots = await _repository.indexScreenshots(
        onProgress: (completed, total) {
          emit(IndexingInProgress(completed: completed, total: total));
        },
      );

      if (screenshots.isEmpty) {
        emit(IndexingError(
          message: 'No screenshots with text were found on your device.',
        ));
      } else {
        emit(IndexingSuccess(
          screenshots: screenshots,
          justFinishedIndexing: true,
        ));
      }
    } catch (e) {
      emit(IndexingError(message: 'Indexing failed: ${e.toString()}'));
    }
  }
}
