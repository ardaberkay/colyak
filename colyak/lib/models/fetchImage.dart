import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:colyak/models/service/cachemanager.dart';

class ImageService {
  final CustomCacheManager _cacheManager = CustomCacheManager();

  Future<Uint8List?> getImageBytes(String imageUrl) async {
    return await _cacheManager.getImageBytes(imageUrl);
  }

  Future<ui.Image?> getImage(String imageUrl) async {
    Uint8List? imageBytes = await getImageBytes(imageUrl);
    if (imageBytes != null) {
      return decodeImageFromList(imageBytes);
    }
    return null;
  }

  Future<ui.Image?> decodeImageFromList(Uint8List imageBytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }
}
