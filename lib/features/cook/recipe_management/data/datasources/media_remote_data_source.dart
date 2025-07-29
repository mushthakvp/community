import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:livera/core/services/cloudinary_service.dart';

import '../../../../../core/error/exceptions.dart';

abstract class MediaRemoteDataSource {
  Future<File?> pickImageFromGallery();
  Future<File?> pickVideoFromGallery();
  Future<String> uploadImage({
    required File imageFile,
    required Function(double progress) onProgress,
  });
  Future<String> uploadVideo({
    required File videoFile,
    required Function(double progress) onProgress,
  });
}

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  @override
  Future<File?> pickImageFromGallery() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.first.path;
        if (path != null) {
          return File(path);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from gallery');
    }
  }

  @override
  Future<File?> pickVideoFromGallery() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        final path = result.files.first.path;
        if (path != null) {
          return File(path);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick video from gallery');
    }
  }

  @override
  Future<String> uploadImage({
    required File imageFile,
    required Function(double progress) onProgress,
  }) async {
    try {
      String? url = await CloudinaryService.uploadSingleImage(
        file: imageFile,
        onProgress: onProgress,
      );
      if (url == null) {
        throw const NetworkException('Failed to upload video');
      }
      return url;
    } catch (e) {
      throw const NetworkException('Failed to upload image');
    }
  }

  @override
  Future<String> uploadVideo({
    required File videoFile,
    required Function(double progress) onProgress,
  }) async {
    try {
      String? url = await CloudinaryService.uploadSingleImage(
        file: videoFile,
        onProgress: onProgress,
      );
      if (url == null) {
        throw const NetworkException('Failed to upload video');
      }
      return url;
    } catch (e) {
      throw const NetworkException('Failed to upload video');
    }
  }
}
