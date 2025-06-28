import 'dart:async';
import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/foundation.dart';

class UploadProgress {
  final String fileKey;
  final String fileName;
  final double progress;
  final String? url;
  final Map<String, String>? urls;
  final String? error;

  UploadProgress({
    required this.fileKey,
    required this.fileName,
    required this.progress,
    this.url,
    this.urls,
    this.error,
  });
}

class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  late final Cloudinary _cloudinary;

  void initialize() {
    _cloudinary = Cloudinary.signedConfig(
      apiKey: "856197342338424",
      apiSecret: "TbKAxeMx8jsxTWruUNlZ1Vc1uxU",
      cloudName: "gadpark",
    );
  }

  Future<String?> uploadSingleImage({
    required File file,
    String? folder,
    Function(double)? onProgress,
  }) async {
    try {
      String fileName = file.path.split('/').last;

      final response = await _cloudinary.upload(
        file: file.path,
        fileBytes: file.readAsBytesSync(),
        resourceType: CloudinaryResourceType.auto,
        folder: folder ?? 'vivera_uploads',
        fileName: fileName,
        progressCallback: (count, total) {
          if (onProgress != null) {
            double progress = count / total;
            onProgress(progress);
          }
        },
      );

      return response.secureUrl;
    } catch (e) {
      debugPrint("Cloudinary upload error: $e");
      return null;
    }
  }

  static Stream<UploadProgress> uploadFiles({
    required Map<String, File> files,
    String? folder,
  }) {
    final StreamController<UploadProgress> controller =
        StreamController.broadcast();

    final cloudinary = Cloudinary.signedConfig(
      apiKey: "856197342338424",
      apiSecret: "TbKAxeMx8jsxTWruUNlZ1Vc1uxU",
      cloudName: "gadpark",
    );

    Map<String, String> uploadedUrls = {};

    Future<void> uploadFile(String fileKey, File file) async {
      String fileName = file.path.split('/').last;
      try {
        final response = await cloudinary.upload(
          file: file.path,
          fileBytes: file.readAsBytesSync(),
          resourceType: CloudinaryResourceType.auto,
          folder: folder ?? 'vivera_uploads',
          fileName: fileName,
          progressCallback: (count, total) {
            double progress = count / total;
            controller.add(
              UploadProgress(
                fileKey: fileKey,
                fileName: fileName,
                progress: progress,
              ),
            );
          },
        );

        uploadedUrls[fileKey] = response.secureUrl ?? '';
        controller.add(
          UploadProgress(
            fileKey: fileKey,
            fileName: fileName,
            progress: 1.0,
            url: response.secureUrl,
          ),
        );
      } catch (e) {
        debugPrint("Upload error for $fileKey: $e");
        controller.add(
          UploadProgress(
            fileKey: fileKey,
            fileName: fileName,
            progress: 0.0,
            error: e.toString(),
          ),
        );
      }
    }

    Future.wait(
      files.entries.map((entry) => uploadFile(entry.key, entry.value)),
    ).then((_) {
      controller.add(
        UploadProgress(
          fileKey: 'all',
          fileName: 'all',
          progress: 1.0,
          urls: uploadedUrls,
        ),
      );
      controller.close();
    });

    return controller.stream;
  }
}
