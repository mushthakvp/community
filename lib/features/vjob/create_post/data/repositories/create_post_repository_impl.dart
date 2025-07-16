import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/create_post_entity.dart';
import '../../domain/repositories/create_post_repository.dart';
import '../datasources/create_post_local_datasource.dart';
import '../datasources/create_post_remote_datasource.dart';
import '../models/create_post_model.dart';

class CreatePostRepositoryImpl implements CreatePostRepository {
  final CreatePostRemoteDataSource remoteDataSource;
  final CreatePostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CreatePostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CreatePostEntity>> createPost(
    CreatePostRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final requestModel = CreatePostRequestModel(
          title: request.title,
          description: request.description,
          image: request.image,
        );

        final result = await remoteDataSource.createPost(requestModel);

        // Clear draft post after successful creation
        await localDataSource.clearDraftPost();

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      // Cache draft post for later submission
      try {
        final requestModel = CreatePostRequestModel(
          title: request.title,
          description: request.description,
          image: request.image,
        );
        await localDataSource.cacheDraftPost(requestModel);
        return const Left(
          NetworkFailure(
            message: 'No internet connection. Draft saved locally.',
          ),
        );
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, CreatePostEntity>> updatePost(
    UpdatePostRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final requestModel = UpdatePostRequestModel(
          postId: request.postId,
          title: request.title,
          description: request.description,
          image: request.image,
        );

        final result = await remoteDataSource.updatePost(requestModel);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String imagePath) async {
    if (await networkInfo.isConnected) {
      try {
        final imageUrl = await remoteDataSource.uploadImage(imagePath);

        // Cache uploaded image URL
        final cachedImages = await localDataSource.getCachedImages();
        cachedImages.add(imageUrl);
        await localDataSource.cacheUploadedImages(cachedImages);

        return Right(imageUrl);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePost(String postId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deletePost(postId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  // Additional methods for draft management
  Future<Either<Failure, CreatePostRequest?>> getDraftPost() async {
    try {
      final draft = await localDataSource.getCachedDraftPost();
      return Right(draft);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  Future<Either<Failure, void>> clearDraftPost() async {
    try {
      await localDataSource.clearDraftPost();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  Future<Either<Failure, List<String>>> getCachedImages() async {
    try {
      final images = await localDataSource.getCachedImages();
      return Right(images);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
