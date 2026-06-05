import 'indexed_image.dart';

class SearchResult {
  final IndexedImage image;
  final String preview;
  final double score;

  const SearchResult({
    required this.image,
    required this.preview,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {'image': image.toMap(), 'snippet': preview, 'score': score};
  }

  @override
  String toString() {
    return 'SearchResult(score: ${score.toStringAsFixed(2)}, snippet: "$preview")';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchResult &&
        other.image == image &&
        other.preview == preview &&
        other.score == score;
  }

  @override
  int get hashCode => Object.hash(image, preview, score);
}
