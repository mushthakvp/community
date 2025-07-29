import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/repositories/media_repository.dart';
import '../datasources/media_remote_data_source.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaRemoteDataSource remoteDataSource;

  MediaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, File?>> pickImageFromGallery() async {
    try {
      final file = await remoteDataSource.pickImageFromGallery();
      return Right(file);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, File?>> pickVideoFromGallery() async {
    try {
      final file = await remoteDataSource.pickVideoFromGallery();
      return Right(file);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage({
    required File imageFile,
    required Function(double progress) onProgress,
  }) async {
    try {
      final url = await remoteDataSource.uploadImage(
        imageFile: imageFile,
        onProgress: onProgress,
      );
      return Right(url);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadVideo({
    required File videoFile,
    required Function(double progress) onProgress,
  }) async {
    try {
      final url = await remoteDataSource.uploadVideo(
        videoFile: videoFile,
        onProgress: onProgress,
      );
      return Right(url);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
