import 'package:flutter/material.dart';
import '../bloc/indexing_state.dart';

class IndexingProgressCard extends StatelessWidget {
  final IndexingInProgress state;
  const IndexingProgressCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.document_scanner, size: 64, color: Colors.indigo),
          const SizedBox(height: 24),
          Text(
            'Extracting text from screenshots...',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a minute. Please keep the app open.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          LinearProgressIndicator(
            value: state.total > 0 ? state.progress : null,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 12),
          Text(
            state.total > 0 ? state.progressText : 'Preparing...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (state.total > 0) ...[
            const SizedBox(height: 4),
            Text(
              '${(state.progress * 100).toStringAsFixed(0)}% complete',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
