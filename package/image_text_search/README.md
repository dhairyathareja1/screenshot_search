# image_text_search

A Flutter package for indexing images via on-device OCR and searching through them by text content. Uses **Google ML Kit** for text recognition (no internet connection or external API required).

Perfect for screenshot search apps, document finders, and any use case where images need to be searchable by the text inside them.

---

## Features

- **On-device OCR** — extract text from images entirely on-device using Google ML Kit (Latin script).
- **Batch indexing** — index multiple images at once with an optional progress callback.
- **Keyword extraction** — automatically generates deduplicated keywords, strips stop words, and handles currency symbols (₹, $, €, £).
- **Relevance-ranked search** — scores results by phrase match, partial word match, and occurrence frequency; returns a configurable number of top results.
- **Context-aware previews** — each `SearchResult` includes a text snippet centred around the matching phrase.
- **Serializable models** — `IndexedImage` supports `toMap` / `fromMap` so you can persist and restore your index with any storage solution (Hive, SQLite, SharedPreferences, etc.).
- **Resource-safe** — `TextExtractor` and `ImageIndexer` expose `close()` / `dispose()` methods to release ML Kit resources when done.

---

## Getting Started

### 1. Add the dependency

```yaml
dependencies:
  image_text_search: ^0.0.1
```

### 2. Configure ML Kit (Android)

In your app-level `android/app/build.gradle`, make sure `minSdk` is at least **21**:

```gradle
android {
    defaultConfig {
        minSdk 21
    }
}
```

### 3. Configure ML Kit (iOS)

In `ios/Podfile`, set the iOS deployment target to at least **13.0**:

```ruby
platform :ios, '13.0'
```

---

## Usage

### Import the package

```dart
import 'package:image_text_search/image_text_search.dart';
```

### Index a list of images

```dart
final indexer = ImageIndexer();

final List<IndexedImage> index = await indexer.indexImages(
  paths: [
    '/path/to/screenshot1.png',
    '/path/to/screenshot2.jpg',
    '/path/to/receipt.png',
  ],
  onProgress: (completed, total) {
    print('Indexed $completed / $total');
  },
  skipEmptyText: true, // skip images with no detectable text (default: true)
);

// Always dispose when done to release ML Kit resources.
await indexer.dispose();
```

### Index a single image

```dart
final indexer = ImageIndexer();

final IndexedImage? result = await indexer.indexSingle('/path/to/image.png');
if (result != null) {
  print('Extracted text: ${result.extractedText}');
  print('Keywords: ${result.keywords}');
}

await indexer.dispose();
```

### Search the index

```dart
final engine = SearchEngine();

final List<SearchResult> results = engine.search(
  query: 'amazon order',
  images: index,
  maxResults: 20,   // optional, default 50
  minScore: 0.1,    // optional, minimum relevance score 0.0–1.0
  previewLength: 100, // optional, character length of the text snippet
);

for (final result in results) {
  print('Path:    ${result.image.path}');
  print('Score:   ${result.score}');   // 0.0 – 1.0
  print('Preview: ${result.preview}');
  print('---');
}
```

### Check for a simple phrase match

```dart
final engine = SearchEngine();
final bool found = engine.matches(query: 'netflix', image: indexedImage);
```

### Persist and restore the index

`IndexedImage` is fully serializable, so you can store the index however you like:

```dart
// Serialize
final List<Map<String, dynamic>> raw = index.map((img) => img.toMap()).toList();
// e.g. store `raw` as JSON in SharedPreferences or Hive

// Deserialize
final List<IndexedImage> restored =
    raw.map(IndexedImage.fromMap).toList();
```

### Use components individually

Each class can be used on its own:

```dart
// Extract text from a single image path
final extractor = TextExtractor();
final String text = await extractor.extractText('/path/to/image.png');
await extractor.close();

// Generate keywords from any text string
final generator = KeywordGenerator();
final List<String> keywords = generator.generate('Amazon Order Total ₹1499');
// → ['amazon', 'order', 'total', '1499']

// Score a query against a text string directly
final matcher = TextMatcher();
final double score = matcher.score(text: 'Amazon Order Total ₹1499', query: 'amazon');
// → 1.0 (exact phrase match)
```

---

## Example App

A full working example is included in the [`example/`](example/main.dart) folder. It simulates indexing five screenshots (Amazon, Zomato, HDFC Bank, Netflix, WhatsApp) and provides a live search UI with relevance score badges and text previews.

To run it:

```bash
cd example
flutter run
```

---

## Dependencies

| Package                                                                                   | Version   | Purpose       |
| ----------------------------------------------------------------------------------------- | --------- | ------------- |
| [`google_mlkit_text_recognition`](https://pub.dev/packages/google_mlkit_text_recognition) | `^0.15.0` | On-device OCR |

---

---

## License

MIT — see the [LICENSE](LICENSE) file for details.
