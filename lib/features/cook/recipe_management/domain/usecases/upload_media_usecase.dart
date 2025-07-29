import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/media_repository.dart';

class UploadImageUseCase implements UseCase<String, UploadImageParams> {
  final MediaRepository repository;

  UploadImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) async {
    return await repository.uploadImage(
      imageFile: params.imageFile,
      onProgress: params.onProgress,
    );
  }
}

class UploadImageParams extends Equatable {
  final File imageFile;
  final Function(double progress) onProgress;

  const UploadImageParams({required this.imageFile, required this.onProgress});

  @override
  List<Object> get props => [imageFile];
}

class UploadVideoUseCase implements UseCase<String, UploadVideoParams> {
  final MediaRepository repository;

  UploadVideoUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadVideoParams params) async {
    return await repository.uploadVideo(
      videoFile: params.videoFile,
      onProgress: params.onProgress,
    );
  }
}

class UploadVideoParams extends Equatable {
  final File videoFile;
  final Function(double progress) onProgress;

  const UploadVideoParams({required this.videoFile, required this.onProgress});

  @override
  List<Object> get props => [videoFile];
}
