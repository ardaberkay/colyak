import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static final CustomCacheManager _instance = CustomCacheManager._internal();
  final Map<String, Uint8List?> _imageBytesMap = {};

  factory CustomCacheManager() {
    return _instance;
  }

  CustomCacheManager._internal();

  Future<Uint8List?> getImageBytes(String imageUrl) async {
    if (_imageBytesMap.containsKey(imageUrl)) {
      print('Image found in _imageBytesMap cache: $imageUrl');
      return _imageBytesMap[imageUrl];
    } else {
      try {
        FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(imageUrl);
        if (fileInfo != null) {
          print('Image found in DefaultCacheManager cache: $imageUrl');
          _imageBytesMap[imageUrl] = await fileInfo.file.readAsBytes();
          return _imageBytesMap[imageUrl];
        } else {
          print('Fetching image from network: $imageUrl');
          var response = await DefaultCacheManager().getSingleFile(imageUrl);
          _imageBytesMap[imageUrl] = await response.readAsBytes();
          return _imageBytesMap[imageUrl];
        }
      } catch (e) {
        print('Error fetching image: $e');
        return null;
      }
    }
  }

  Future<void> cleanDefaultCacheManager() async {
    await DefaultCacheManager().emptyCache();
    _imageBytesMap.clear();
  }
}

