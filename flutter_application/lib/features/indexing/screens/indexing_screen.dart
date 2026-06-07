import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/indexing_bloc.dart';
import '../bloc/indexing_event.dart';
import '../bloc/indexing_state.dart';
import '../widgets/indexing_progress_card.dart';
import '../widgets/indexing_summary_card.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../core/constants/app_strings.dart';

class IndexingScreen extends StatelessWidget {
  const IndexingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.indexingTitle),
      ),
      body: BlocBuilder<IndexingBloc, IndexingState>(
        builder: (context, state) {
          if (state is IndexingLoading) {
            return const LoadingIndicator(message: 'Loading saved data...');
          }

          if (state is IndexingInProgress) {
            return IndexingProgressCard(state: state);
          }

          if (state is IndexingSuccess) {
            return IndexingSummaryCard(state: state);
          }

          if (state is IndexingPermissionDenied) {
            return _PermissionDeniedView(
              isPermanentlyDenied: state.isPermanentlyDenied,
            );
          }

          if (state is IndexingError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<IndexingBloc>().add(StartIndexingEvent());
              },
            );
          }

          return _InitialView();
        },
      ),
    );
  }
}

class _InitialView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_search, size: 80, color: Colors.indigo.shade300),
          const SizedBox(height: 24),
          Text(
            AppStrings.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.appTagline,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.indexingSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Sends StartIndexingEvent to IndexingBloc
                context.read<IndexingBloc>().add(StartIndexingEvent());
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text(AppStrings.indexingButtonStart),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  final bool isPermanentlyDenied;
  const _PermissionDeniedView({required this.isPermanentlyDenied});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 64, color: Colors.orange.shade300),
          const SizedBox(height: 20),
          Text(
            AppStrings.indexingPermissionDenied,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          if (isPermanentlyDenied)
            ElevatedButton.icon(
              onPressed: () {
                context.read<IndexingBloc>();
              },
              icon: const Icon(Icons.settings),
              label: const Text('Open Settings'),
            )
          else
            ElevatedButton.icon(
              onPressed: () {
                context.read<IndexingBloc>().add(StartIndexingEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.indexingGrantPermission),
            ),
        ],
      ),
    );
  }
}
