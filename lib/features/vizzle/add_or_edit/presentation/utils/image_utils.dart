import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static const int maxImageSize = 1024;
  static const int maxFileSize = 5 * 1024 * 1024;

  static Future<File?> pickAndProcessImage({
    required ImageSource source,
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );
      if (image == null) return null;
      final File imageFile = File(image.path);
      final fileSize = await imageFile.length();
      if (fileSize > maxFileSize) {
        throw Exception(
          'Image size too large. Please select an image smaller than 5MB.',
        );
      }
      return await _compressImage(imageFile);
    } catch (e) {
      debugPrint('Error picking image: $e');
      rethrow;
    }
  }

  static Future<File> _compressImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return imageFile;
      if (image.width > maxImageSize || image.height > maxImageSize) {
        image = img.copyResize(
          image,
          width: image.width > image.height ? maxImageSize : null,
          height: image.height > image.width ? maxImageSize : null,
        );
      }
      final compressedBytes = img.encodeJpg(image, quality: 85);
      final tempDir = await getTemporaryDirectory();
      final compressedFile = File(
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await compressedFile.writeAsBytes(compressedBytes);
      return compressedFile;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return imageFile;
    }
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
