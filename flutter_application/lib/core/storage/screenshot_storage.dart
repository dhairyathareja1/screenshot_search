import '../models/screenshot_model.dart';
import 'database_service.dart';

class ScreenshotStorage {
  final DatabaseService _db;
  ScreenshotStorage({required DatabaseService db}) : _db = db;

  Future<void> saveScreenshots(List<ScreenshotModel> screenshots) async {
    await _db.saveAll(screenshots);
  }

  Future<List<ScreenshotModel>> loadScreenshots() async {
    return _db.loadAll();
  }

  Future<void> clearAll() async {
    await _db.clearAll();
  }

  bool get hasIndexedBefore => _db.hasData;
  int get savedCount => _db.count;
}
