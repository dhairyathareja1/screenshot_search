class IndexedImage {
  final String id;
  final String path;
  final String extractedText;
  final DateTime indexedAt;

  const IndexedImage({
    required this.id,
    required this.path,
    required this.extractedText,
    required this.indexedAt,
  });

  bool get hasText => extractedText.trim().isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'extractedText': extractedText,
      'indexedAt': indexedAt.toIso8601String(),
    };
  }

  factory IndexedImage.fromMap(Map<String, dynamic> map) {
    return IndexedImage(
      id: map['id'] as String,
      path: map['path'] as String,
      extractedText: map['extractedText'] as String,
      indexedAt: DateTime.parse(map['indexedAt'] as String),
    );
  }

  IndexedImage copyWith({
    String? id,
    String? path,
    String? extractedText,
    DateTime? indexedAt,
  }) {
    return IndexedImage(
      id: id ?? this.id,
      path: path ?? this.path,
      extractedText: extractedText ?? this.extractedText,
      indexedAt: indexedAt ?? this.indexedAt,
    );
  }

  @override
  String toString() {
    return 'IndexedImage(id: $id, hasText: $hasText, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IndexedImage && other.id == id && other.path == path;
  }

  @override
  int get hashCode => Object.hash(id, path);
}
