import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../models/screenshot_model.dart';

class DatabaseService {
  late Box _box;
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(AppConstants.hiveBoxName);
  }

  Future<void> saveAll(List<ScreenshotModel> screenshots) async {
    final Map<String, dynamic> entries = {};
    for (final screenshot in screenshots) {
      entries[screenshot.id] = screenshot.toMap();
    }
    await _box.putAll(entries);
  }

  Future<void> saveOne(ScreenshotModel screenshot) async {
    await _box.put(screenshot.id, screenshot.toMap());
  }

  Future<List<ScreenshotModel>> loadAll() async {
    final List<ScreenshotModel> results = [];
    for (final dynamic rawValue in _box.values) {
      try {
        final Map<String, dynamic> map =
            Map<String, dynamic>.from(rawValue as Map);
        results.add(ScreenshotModel.fromMap(map));
      } catch (_) {
        continue;
      }
    }
    return results;
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  int get count => _box.length;
  bool get hasData => _box.isNotEmpty;

  Future<void> close() async {
    await _box.close();
  }
}
