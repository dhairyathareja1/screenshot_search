import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../indexing/bloc/indexing_bloc.dart';
import '../../indexing/bloc/indexing_state.dart';
import '../../indexing/screens/indexing_screen.dart';
import '../../search/bloc/search_bloc.dart';
import '../../search/bloc/search_event.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    IndexingScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<IndexingBloc, IndexingState>(
      listener: (context, indexingState) {
        if (indexingState is IndexingSuccess) {
          context.read<SearchBloc>().add(
                SearchScreenshotsLoaded(indexingState.screenshots),
              );

          if (indexingState.justFinishedIndexing) {
            setState(() => _currentIndex = 1);
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
        ),
      ),
    );
  }
}
