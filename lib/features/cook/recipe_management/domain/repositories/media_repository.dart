import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';

abstract class MediaRepository {
  Future<Either<Failure, File?>> pickImageFromGallery();
  Future<Either<Failure, File?>> pickVideoFromGallery();

  Future<Either<Failure, String>> uploadImage({
    required File imageFile,
    required Function(double progress) onProgress,
  });

  Future<Either<Failure, String>> uploadVideo({
    required File videoFile,
    required Function(double progress) onProgress,
  });
}
