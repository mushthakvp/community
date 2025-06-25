import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../models/coupon_model.dart';

class CouponRepositoryImpl implements CouponRepository {
  final ApiClient _apiClient;

  CouponRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, List<CouponEntity>>> getCoupons({
    String? categoryId,
    String? appId,
    String? search,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['categoryId'] = categoryId;
      }
      if (appId != null && appId.isNotEmpty) {
        queryParams['appId'] = appId;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiClient.get(
        ApiConstants.getCoupons,
        queryParameters: queryParams,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final getCouponsModel = GetCouponsModel.fromJson(responseData);

        if (getCouponsModel.success == true &&
            getCouponsModel.data?.couponRewards != null) {
          // Convert models to entities
          final coupons = getCouponsModel.data!.couponRewards!
              .map((couponModel) => _mapCouponModelToEntity(couponModel))
              .toList();

          return Right(coupons);
        } else {
          return Left(
            ServerFailure(
              message: getCouponsModel.message ?? 'Failed to load coupons',
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load coupons',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getCoupons: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getCoupons: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getCoupons',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: ' ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> likeCoupon(String couponId) async {
    try {
      if (couponId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid coupon ID'));
      }

      final response = await _apiClient.put(
        '${ApiConstants.actionOnCoupons}$couponId',
        body: {'action': 'like'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(true);
      } else {
        final responseData = json.decode(response.body);
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to like coupon',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in likeCoupon: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in likeCoupon: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } on ValidationException catch (e) {
      dev.log('Validation exception in likeCoupon: ${e.message}');
      return Left(ValidationFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in likeCoupon',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> dislikeCoupon(
    String couponId,
    String reason,
  ) async {
    try {
      if (couponId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid coupon ID'));
      }

      if (reason.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Reason is required for dislike'),
        );
      }

      final response = await _apiClient.put(
        '${ApiConstants.actionOnCoupons}$couponId',
        body: {'action': 'dislike', 'reason': reason.trim()},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(true);
      } else {
        final responseData = json.decode(response.body);
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to dislike coupon',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in dislikeCoupon: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in dislikeCoupon: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } on ValidationException catch (e) {
      dev.log('Validation exception in dislikeCoupon: ${e.message}');
      return Left(ValidationFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in dislikeCoupon',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> useCoupon(String couponId) async {
    try {
      if (couponId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid coupon ID'));
      }

      final response = await _apiClient.put(
        '${ApiConstants.useCoupon}$couponId',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(true);
      } else {
        final responseData = json.decode(response.body);
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to use coupon',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in useCoupon: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in useCoupon: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } on ValidationException catch (e) {
      dev.log('Validation exception in useCoupon: ${e.message}');
      return Left(ValidationFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in useCoupon',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiConstants.getCoupons);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final getCouponsModel = GetCouponsModel.fromJson(responseData);

        if (getCouponsModel.success == true &&
            getCouponsModel.data?.categories != null) {
          final categories = getCouponsModel.data!.categories!
              .map((categoryModel) => _mapCategoryModelToEntity(categoryModel))
              .toList();

          return Right(categories);
        } else {
          return Left(
            ServerFailure(
              message: getCouponsModel.message ?? 'Failed to load categories',
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load categories',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getCategories: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getCategories: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getCategories',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppEntity>>> getApps() async {
    try {
      final response = await _apiClient.get(ApiConstants.getCoupons);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final getCouponsModel = GetCouponsModel.fromJson(responseData);

        if (getCouponsModel.success == true &&
            getCouponsModel.data?.apps != null) {
          final apps = getCouponsModel.data!.apps!
              .map((appModel) => _mapAppModelToEntity(appModel))
              .toList();

          return Right(apps);
        } else {
          return Left(
            ServerFailure(
              message: getCouponsModel.message ?? 'Failed to load apps',
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load apps',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getApps: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getApps: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log('Unexpected error in getApps', error: e, stackTrace: stackTrace);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // Private helper methods for mapping models to entities
  CouponEntity _mapCouponModelToEntity(CouponReward couponModel) {
    return CouponEntity(
      id: couponModel.id ?? '',
      description: couponModel.description ?? '',
      couponCode: couponModel.couponCode ?? '',
      websiteLink: couponModel.websiteLink,
      app: _mapAppModelToEntity(couponModel.app ?? const CouponRewardApp()),
      category: _mapCategoryModelToEntity(
        couponModel.category ?? const CouponRewardCategory(),
      ),
      likes: couponModel.likes ?? 0,
      dislikes: couponModel.dislikes ?? 0,
      isLiked: couponModel.isLiked ?? false,
      isDisliked: couponModel.isDisliked ?? false,
      usageCount: couponModel.usageByUsers?.count ?? 0,
      lastUsed: couponModel.usageByUsers?.lastUsed,
      createdAt: couponModel.createdAt ?? DateTime.now(),
    );
  }

  AppEntity _mapAppModelToEntity(dynamic appModel) {
    if (appModel is CouponRewardApp) {
      return AppEntity(
        id: appModel.id ?? '',
        name: appModel.appName ?? '',
        logo: appModel.logo ?? '',
        websiteLink: appModel.websiteLink,
      );
    } else if (appModel is AppElement) {
      return AppEntity(
        id: appModel.id ?? '',
        name: appModel.appName ?? '',
        logo: appModel.logo ?? '',
        websiteLink: appModel.websiteLink,
      );
    } else {
      return const AppEntity(id: '', name: 'Unknown App', logo: '');
    }
  }

  CategoryEntity _mapCategoryModelToEntity(dynamic categoryModel) {
    if (categoryModel is CouponRewardCategory) {
      return CategoryEntity(
        id: categoryModel.id ?? '',
        name: categoryModel.name ?? '',
      );
    } else if (categoryModel is CategoryElement) {
      return CategoryEntity(
        id: categoryModel.id ?? '',
        name: categoryModel.name ?? '',
      );
    } else {
      return const CategoryEntity(id: '', name: 'Unknown Category');
    }
  }
}
