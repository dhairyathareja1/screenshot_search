import 'package:image_text_search/image_text_search.dart';
import '../models/screenshot_model.dart';

class OcrService {
  final ImageIndexer _indexer = ImageIndexer();
  Future<List<ScreenshotModel>> indexImages({
    required List<String> paths,
    void Function(int done, int total)? onProgress,
  }) async {
    final List<IndexedImage> indexed = await _indexer.indexImages(
      paths: paths,
      onProgress: onProgress,
      skipEmptyText: true,
    );

    final List<ScreenshotModel> screenshots = indexed.map((indexedImage) {
      return ScreenshotModel.fromPathAndText(
        path: indexedImage.path,
        extractedText: indexedImage.extractedText,
        indexedAt: indexedImage.indexedAt,
      );
    }).toList();
    return screenshots;
  }

  Future<ScreenshotModel?> indexSingle(String path) async {
    final IndexedImage? result = await _indexer.indexSingle(path);
    if (result == null) return null;

    return ScreenshotModel.fromPathAndText(
      path: result.path,
      extractedText: result.extractedText,
      indexedAt: result.indexedAt,
    );
  }

  Future<void> dispose() async {
    await _indexer.dispose();
  }
}
