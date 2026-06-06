import '../../../core/models/screenshot_model.dart';
import '../../../core/services/gallery_service.dart';
import '../../../core/services/ocr_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/storage/screenshot_storage.dart';

class IndexingRepository {
  final PermissionService _permissionService;
  final GalleryService _galleryService;
  final OcrService _ocrService;
  final ScreenshotStorage _storage;

  IndexingRepository({
    required PermissionService permissionService,
    required GalleryService galleryService,
    required OcrService ocrService,
    required ScreenshotStorage storage,
  })  : _permissionService = permissionService,
        _galleryService = galleryService,
        _ocrService = ocrService,
        _storage = storage;

  Future<bool> hasPermission() async {
    return _permissionService.hasStoragePermission();
  }

  Future<bool> requestPermission() async {
    return _permissionService.requestStoragePermission();
  }

  Future<bool> isPermissionPermanentlyDenied() async {
    return _permissionService.isPermanentlyDenied();
  }

  Future<void> openSettings() async {
    await _permissionService.openSettings();
  }

  Future<List<ScreenshotModel>> loadFromDatabase() async {
    return _storage.loadScreenshots();
  }

  Future<List<ScreenshotModel>> indexScreenshots({
    void Function(int completed, int total)? onProgress,
  }) async {
    final List<String> paths = await _galleryService.getScreenshotPaths();
    if (paths.isEmpty) return [];
    final List<ScreenshotModel> screenshots = await _ocrService.indexImages(
      paths: paths,
      onProgress: onProgress,
    );

    if (screenshots.isNotEmpty) {
      await _storage.saveScreenshots(screenshots);
    }
    return screenshots;
  }

  bool get hasIndexedBefore => _storage.hasIndexedBefore;
}
