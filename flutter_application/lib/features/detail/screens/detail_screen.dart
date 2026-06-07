import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/models/screenshot_model.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/extensions/datetime_extension.dart';

class DetailScreen extends StatelessWidget {
  final ScreenshotModel screenshot;
  const DetailScreen({super.key, required this.screenshot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenshot.fileName, overflow: TextOverflow.ellipsis),
        actions: [
          if (screenshot.hasText)
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: AppStrings.detailCopyButton,
              onPressed: () => _copyToClipboard(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full screenshot image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(screenshot.path),
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child:
                        Icon(Icons.broken_image, size: 48, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _MetadataCard(screenshot: screenshot),
            const SizedBox(height: 16),
            _ExtractedTextCard(text: screenshot.extractedText),
          ],
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: screenshot.extractedText));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.detailCopied)),
      );
    }
  }
}

class _MetadataCard extends StatelessWidget {
  final ScreenshotModel screenshot;
  const _MetadataCard({required this.screenshot});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.detailMetadata,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 8),
            _InfoRow(label: 'File', value: screenshot.fileName),
            _InfoRow(label: 'Indexed', value: screenshot.indexedAt.toReadable),
            _InfoRow(
              label: 'Text found',
              value: screenshot.hasText ? 'Yes' : 'No',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtractedTextCard extends StatelessWidget {
  final String text;
  const _ExtractedTextCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.detailExtractedText,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 12),
            if (text.isEmpty)
              Text(
                AppStrings.detailNoText,
                style: TextStyle(color: Colors.grey.shade500),
              )
            else
              SelectableText(
                text,
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
          ],
        ),
      ),
    );
  }
}
