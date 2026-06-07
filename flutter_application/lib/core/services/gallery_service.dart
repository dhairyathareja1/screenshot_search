import 'package:photo_manager/photo_manager.dart';

class GalleryService {
  Future<List<String>> getScreenshotPaths({int maxCount = 500}) async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    AssetPathEntity? screenshotAlbum;
    for (final album in albums) {
      final String name = album.name.toLowerCase();
      if (name.contains('screenshot')) {
        screenshotAlbum = album;
        break;
      }
    }

    final AssetPathEntity? targetAlbum =
        screenshotAlbum ?? (albums.isNotEmpty ? albums.first : null);

    if (targetAlbum == null) return [];
    final List<AssetEntity> assets = await targetAlbum.getAssetListPaged(
      page: 0,
      size: maxCount,
    );

    final List<String> paths = [];
    for (final AssetEntity asset in assets) {
      final file = await asset.originFile;
      if (file != null) {
        paths.add(file.path);
      }
    }
    return paths;
  }

  Future<int> getScreenshotCount() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    for (final album in albums) {
      if (album.name.toLowerCase().contains('screenshot')) {
        return await album.assetCountAsync;
      }
    }
    return 0;
  }
}
