abstract class IndexingEvent {}

class StartIndexingEvent extends IndexingEvent {}

class ClearAndReindexEvent extends IndexingEvent {}

class LoadSavedScreenshotsEvent extends IndexingEvent {}
