import '../models/indexed_image.dart';
import '../ocr/text_extractor.dart';
import 'keyword_generator.dart';

class ImageIndexer {
  final TextExtractor _extractor;
  final KeywordGenerator _keywordGenerator;

  ImageIndexer({TextExtractor? extractor, KeywordGenerator? keywordGenerator})
    : _extractor = extractor ?? TextExtractor(),
      _keywordGenerator = keywordGenerator ?? KeywordGenerator();

  Future<List<IndexedImage>> indexImages({
    required List<String> paths,
    void Function(int completed, int total)? onProgress,
    bool skipEmptyText = true,
  }) async {
    final List<IndexedImage> results = [];
    final int total = paths.length;

    for (int i = 0; i < total; i++) {
      final String path = paths[i];

      String extractedText = '';
      try {
        extractedText = await _extractor.extractText(path);
      } catch (_) {
        onProgress?.call(i + 1, total);
        continue;
      }

      if (skipEmptyText && extractedText.trim().isEmpty) {
        onProgress?.call(i + 1, total);
        continue;
      }

      final String id = _generateIdFromPath(path);
      final List<String> keywords = _keywordGenerator.generate(extractedText);

      results.add(
        IndexedImage(
          id: id,
          path: path,
          extractedText: extractedText,
          indexedAt: DateTime.now(),
          keywords: keywords,
        ),
      );

      onProgress?.call(i + 1, total);
    }

    return results;
  }

  Future<IndexedImage?> indexSingle(
    String path, {
    bool skipEmptyText = true,
  }) async {
    try {
      final String text = await _extractor.extractText(path);

      if (skipEmptyText && text.trim().isEmpty) return null;

      final List<String> keywords = _keywordGenerator.generate(text);

      return IndexedImage(
        id: _generateIdFromPath(path),
        path: path,
        extractedText: text,
        indexedAt: DateTime.now(),
        keywords: keywords,
      );
    } catch (_) {
      return null;
    }
  }

  String _generateIdFromPath(String path) {
    return path.hashCode.abs().toString();
  }

  Future<void> dispose() async {
    await _extractor.close();
  }
}
