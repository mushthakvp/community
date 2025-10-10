import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micons/micons.dart';

mixin ImageUploadService {
  // Upload state observables
  RxBool isUploading = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  Rx<File?> thumbnailImage = Rx<File?>(null);
  Rx<File?> selectedVideoFile = Rx<File?>(null);
  RxString imageUrlForUpload = ''.obs;
  RxString videoUrlForUpload = ''.obs;

  // Upload files and URLs
  Map<String, File> files = {};
  Map<String, String> uploadedUrls = {};

  // Pick image from gallery
  Future<void> pickFromGallery({required bool isFromVideo}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: isFromVideo ? FileType.video : FileType.image,
        allowedExtensions: isFromVideo ? ['mp4', 'mov', 'avi'] : ['jpg', 'png', 'jpeg'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        if (isFromVideo) {
          selectedVideoFile.value = file;
        } else {
          thumbnailImage.value = file;
        }
        log('File picked: ${file.path}');
      }
    } catch (e) {
      log('Error picking file: $e');
    }
  }

  // Upload image
  Future<String?> uploadImage({String? customKey, Function(double)? onProgress}) async {
    if (thumbnailImage.value == null) {
      log('No image selected for upload');
      return null;
    }

    try {
      isUploading.value = true;
      files.clear();
      files[customKey ?? "image"] = thumbnailImage.value!;

      final completer = Completer<String>();

      MIconsUploader.uploadFiles(
        files: files,
        apiKey: "517537169588441",
        folder: "onefreezone",
      ).listen(
        (progress) {
          uploadProgress.value = progress.progress * 100;
          onProgress?.call(progress.progress);

          if (progress.url != null) {
            uploadedUrls[progress.fileKey] = progress.url!;
            imageUrlForUpload.value = progress.url!;
          }
        },
        onDone: () {
          isUploading.value = false;
          uploadProgress.value = 100.0;

          final uploadedUrl = uploadedUrls[customKey ?? "image"];
          if (uploadedUrl != null) {
            completer.complete(uploadedUrl);
          } else {
            completer.completeError('Upload failed');
          }
        },
        onError: (error) {
          log('Image upload error: $error');
          isUploading.value = false;
          completer.completeError(error);
        },
      );

      return completer.future;
    } catch (e) {
      log('Unexpected error in image upload: $e');
      isUploading.value = false;
      return null;
    }
  }

  // Upload video
  Future<String?> uploadVideo({String? customKey, Function(double)? onProgress}) async {
    if (selectedVideoFile.value == null) {
      log('No video selected for upload');
      return null;
    }

    try {
      isUploading.value = true;
      files.clear();
      files[customKey ?? "video"] = selectedVideoFile.value!;

      final completer = Completer<String>();

      MIconsUploader.uploadFiles(
        files: files,
        apiKey: "517537169588441",
        folder: "onefreezone",
      ).listen(
        (progress) {
          uploadProgress.value = progress.progress * 100;
          onProgress?.call(progress.progress);

          if (progress.url != null) {
            uploadedUrls[progress.fileKey] = progress.url!;
            videoUrlForUpload.value = progress.url!;
          }
        },
        onDone: () {
          isUploading.value = false;
          uploadProgress.value = 100.0;

          final uploadedUrl = uploadedUrls[customKey ?? "video"];
          if (uploadedUrl != null) {
            completer.complete(uploadedUrl);
          } else {
            completer.completeError('Upload failed');
          }
        },
        onError: (error) {
          log('Video upload error: $error');
          isUploading.value = false;
          completer.completeError(error);
        },
      );

      return completer.future;
    } catch (e) {
      log('Unexpected error in video upload: $e');
      isUploading.value = false;
      return null;
    }
  }

  // Clear upload data
  void clearUploadData() {
    thumbnailImage.value = null;
    selectedVideoFile.value = null;
    imageUrlForUpload.value = '';
    videoUrlForUpload.value = '';
    files.clear();
    uploadedUrls.clear();
    isUploading.value = false;
    uploadProgress.value = 0.0;
  }
}
