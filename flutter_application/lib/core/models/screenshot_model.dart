class ScreenshotModel {
  final String id;
  final String path;
  final String extractedText;
  final DateTime indexedAt;
  final String fileName;

  const ScreenshotModel({
    required this.id,
    required this.path,
    required this.extractedText,
    required this.indexedAt,
    required this.fileName,
  });

  bool get hasText => extractedText.trim().isNotEmpty;

  factory ScreenshotModel.fromPathAndText({
    required String path,
    required String extractedText,
    required DateTime indexedAt,
  }) {
    return ScreenshotModel(
      id: path.hashCode.abs().toString(),
      path: path,
      extractedText: extractedText,
      indexedAt: indexedAt,
      fileName: path.split('/').last,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'extractedText': extractedText,
      'indexedAt': indexedAt.toIso8601String(),
      'fileName': fileName,
    };
  }

  factory ScreenshotModel.fromMap(Map<String, dynamic> map) {
    return ScreenshotModel(
      id: map['id'] as String,
      path: map['path'] as String,
      extractedText: map['extractedText'] as String,
      indexedAt: DateTime.parse(map['indexedAt'] as String),
      fileName: map['fileName'] as String,
    );
  }

  @override
  String toString() => 'ScreenshotModel(id: $id, fileName: $fileName)';

  @override
  bool operator ==(Object other) => other is ScreenshotModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
