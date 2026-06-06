import '../../../core/models/screenshot_model.dart';

abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class SearchScreenshotsLoaded extends SearchEvent {
  final List<ScreenshotModel> screenshots;
  SearchScreenshotsLoaded(this.screenshots);
}

class SearchCleared extends SearchEvent {}
