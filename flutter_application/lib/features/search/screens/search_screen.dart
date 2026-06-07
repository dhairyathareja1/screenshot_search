import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/screenshot_card.dart';
import '../widgets/empty_search_widget.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/app_error_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _controller,
              onChanged: (query) {
                context.read<SearchBloc>().add(SearchQueryChanged(query));
              },
              onCleared: () {
                _controller.clear();
                context.read<SearchBloc>().add(SearchCleared());
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchNotIndexed) {
                  return const EmptySearchWidget(
                    icon: Icons.image_not_supported_outlined,
                    message: AppStrings.searchNotIndexed,
                  );
                }

                if (state is SearchInitial) {
                  return const EmptySearchWidget(
                    icon: Icons.search,
                    message: AppStrings.searchInitial,
                  );
                }

                if (state is SearchLoading) {
                  return const LoadingIndicator();
                }

                if (state is SearchEmpty) {
                  return EmptySearchWidget(
                    icon: Icons.search_off,
                    message: 'No results for "${state.query}"',
                  );
                }

                if (state is SearchError) {
                  return AppErrorWidget(message: state.message);
                }

                if (state is SearchResults) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              '${state.count} ${AppStrings.searchResultsCount}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.results.length,
                          itemBuilder: (context, index) {
                            final item = state.results[index];
                            return ScreenshotCard(
                              item: item,
                              query: state.query,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
