class AppStrings {
  AppStrings._();
  static const String appName = 'Screenshot Search';
  static const String appTagline = 'Search your screenshots by text';
  static const String navIndex = 'Index';
  static const String navSearch = 'Search';
  static const String navInsights = 'Insights';
  static const String indexingTitle = 'Index Screenshots';
  static const String indexingSubtitle =
      'We scan your screenshots and extract text from them so you can search later.';
  static const String indexingButtonStart = 'Start Indexing';
  static const String indexingButtonReindex = 'Re-Index Screenshots';
  static const String indexingInProgress = 'Indexing in progress...';
  static const String indexingDone = 'Indexing complete!';
  static const String indexingError = 'Something went wrong. Please try again.';
  static const String indexingPermissionDenied =
      'Storage permission is required to read your screenshots.';
  static const String indexingGrantPermission = 'Grant Permission';
  static const String indexingNoScreenshots =
      'No screenshots found on your device.';
  static const String searchHint = 'Search screenshots... e.g. "receipt"';
  static const String searchEmpty = 'No results found for that query.';
  static const String searchInitial =
      'Type something to search your screenshots.';
  static const String searchNotIndexed =
      'You haven\'t indexed your screenshots yet.\nGo to the Index tab first.';
  static const String searchResultsCount = 'results found';
  static const String detailExtractedText = 'Extracted Text';
  static const String detailNoText = 'No text was found in this screenshot.';
  static const String detailMetadata = 'Details';
  static const String detailCopied = 'Text copied to clipboard!';
  static const String detailCopyButton = 'Copy Text';
  static const String insightsTitle = 'Insights';
  static const String insightsNotReady =
      'Index your screenshots first to see insights.';
  static const String insightsTotal = 'Total Indexed';
  static const String insightsWithText = 'With Text';
  static const String insightsWithoutText = 'No Text';
  static const String insightsAiTitle = 'AI Summary';
  static const String insightsAiLoading = 'Analyzing your screenshots...';
  static const String insightsAiError = 'Could not generate AI summary.';
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNoInternet = 'No internet connection.';
  static const String retry = 'Retry';
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
}
