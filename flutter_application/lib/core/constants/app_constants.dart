class AppConstants {
  AppConstants._();
  static const String appName = 'ScreenshotSearch';
  static const String appVersion = '1.0.0';
  static const String hiveBoxName = 'indexed_screenshots';
  static const int indexingBatchSize = 10;
  static const int maxScreenshotsToIndex = 500;
  static const double searchMinScore = 0.1;
  static const int searchMaxResults = 50;
  static const int snippetLength = 100;
  static const Duration searchDebounce = Duration(milliseconds: 400);
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
}
