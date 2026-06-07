import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_strings.dart';
import 'core/services/gallery_service.dart';
import 'core/services/ocr_service.dart';
import 'core/services/permission_service.dart';
import 'core/storage/database_service.dart';
import 'core/storage/screenshot_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/home_screen.dart';
import 'features/indexing/bloc/indexing_bloc.dart';
import 'features/indexing/bloc/indexing_event.dart';
import 'features/indexing/repository/indexing_repository.dart';
import 'features/search/bloc/search_bloc.dart';
import 'features/search/repository/search_repository.dart';

class App extends StatefulWidget {
  final DatabaseService databaseService;
  const App({super.key, required this.databaseService});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final PermissionService _permissionService = PermissionService();
  late final GalleryService _galleryService = GalleryService();
  late final OcrService _ocrService = OcrService();
  late final ScreenshotStorage _storage = ScreenshotStorage(
    db: widget.databaseService,
  );

  late final IndexingRepository _indexingRepository = IndexingRepository(
    permissionService: _permissionService,
    galleryService: _galleryService,
    ocrService: _ocrService,
    storage: _storage,
  );
  late final SearchRepository _searchRepository = SearchRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IndexingBloc>(
          create: (_) => IndexingBloc(repository: _indexingRepository)
            ..add(LoadSavedScreenshotsEvent()),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(repository: _searchRepository),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }
}
