import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> hasStoragePermission() async {
    final status = await _getCorrectPermission().status;
    return status.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    final permission = _getCorrectPermission();
    final currentStatus = await permission.status;
    if (currentStatus.isGranted) return true;
    final result = await permission.request();
    return result.isGranted;
  }

  Future<bool> isPermanentlyDenied() async {
    final status = await _getCorrectPermission().status;
    return status.isPermanentlyDenied;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }

  Permission _getCorrectPermission() {
    return Permission.photos;
  }
}
