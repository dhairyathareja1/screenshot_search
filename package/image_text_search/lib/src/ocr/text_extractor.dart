import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextExtractor {
  final TextRecognizer _recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  bool _isClosed = false;

  Future<String> extractText(String imagePath) async {
    if (_isClosed) {
      throw StateError(
        'TextExtractor is closed. Please create a new instance.',
      );
    }

    final file = File(imagePath);
    final bool fileExists = await file.exists();
    if (!fileExists) {
      return '';
    }

    try {
      final InputImage inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _recognizer.processImage(
        inputImage,
      );
      return recognizedText.text;
    } catch (error) {
      throw TextExtractionException(
        imagePath: imagePath,
        cause: error.toString(),
      );
    }
  }

  Future<Map<String, String>> extractFromMultiple(
    List<String> imagePaths,
  ) async {
    final Map<String, String> results = {};

    for (final String path in imagePaths) {
      try {
        results[path] = await extractText(path);
      } catch (_) {
        results[path] = '';
      }
    }
    return results;
  }

  Future<void> close() async {
    if (!_isClosed) {
      _isClosed = true;
      await _recognizer.close();
    }
  }
}

class TextExtractionException implements Exception {
  final String imagePath;
  final String cause;

  const TextExtractionException({required this.imagePath, required this.cause});

  @override
  String toString() {
    return 'TextExtractionException: Could not read text from "$imagePath". Reason: $cause';
  }
}
