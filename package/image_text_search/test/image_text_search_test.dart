import 'package:flutter_test/flutter_test.dart';
import 'package:image_text_search/image_text_search.dart';

void main() {
  group('KeywordGenerator', () {
    test('generates keywords from text', () {
      final generator = KeywordGenerator();
      final keywords = generator.generate('Amazon Order Total ₹1499');
      expect(keywords.contains('amazon'), true);
      expect(keywords.contains('order'), true);
      expect(keywords.contains('1499'), true);
    });
  });

  group('SearchEngine', () {
    test('finds matching screenshots', () {
      final image = IndexedImage(
        id: '1',
        path: 'amazon.png',
        extractedText: 'Amazon Order Total ₹1499',
        indexedAt: DateTime.now(),
        keywords: ['amazon', 'order', '1499'],
      );

      final engine = SearchEngine();
      final results = engine.search(query: 'amazon', images: [image]);

      expect(results.isNotEmpty, true);
      expect(results.first.image.id, '1');
    });
  });

  group('IndexedImage', () {
    test('hasText returns true when text exists', () {
      final image = IndexedImage(
        id: '1',
        path: 'test.png',
        extractedText: 'hello world',
        indexedAt: DateTime.now(),
        keywords: ['hello', 'world'],
      );

      expect(image.hasText, true);
    });
  });
}
