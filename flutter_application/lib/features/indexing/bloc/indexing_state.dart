import '../../../core/models/screenshot_model.dart';

abstract class IndexingState {}

class IndexingInitial extends IndexingState {}

class IndexingLoading extends IndexingState {}

class IndexingInProgress extends IndexingState {
  final int completed;
  final int total;

  IndexingInProgress({required this.completed, required this.total});
  double get progress => total == 0 ? 0.0 : completed / total;
  String get progressText => '$completed / $total';
}

class IndexingSuccess extends IndexingState {
  final List<ScreenshotModel> screenshots;
  final bool justFinishedIndexing;

  IndexingSuccess({
    required this.screenshots,
    this.justFinishedIndexing = false,
  });

  int get count => screenshots.length;
}

class IndexingPermissionDenied extends IndexingState {
  final bool isPermanentlyDenied;
  IndexingPermissionDenied({this.isPermanentlyDenied = false});
}

class IndexingError extends IndexingState {
  final String message;
  IndexingError({required this.message});
}
