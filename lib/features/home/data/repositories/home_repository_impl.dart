import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/notification_model.dart';
import '../models/user_details_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;

  HomeRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, UserDetailsEntity>> getUserDetails() async {
    try {
      final response = await ApiClient.main().get(ApiConstants.getHome);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final userDetailsModel = UserDetailsModel.fromJson(responseData);
        final entity = _mapUserDetailsToEntity(userDetailsModel);
        return Right(entity);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to get user details',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getUserDetails: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getUserDetails: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getUserDetails',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final response = await ApiClient.main().get(
        ApiConstants.getNotifications,
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final notificationModel = ViveraNotificationModel.fromJson(
          responseData,
        );
        final entities =
            notificationModel.notifications
                ?.map((notification) => _mapNotificationToEntity(notification))
                .toList() ??
            [];
        return Right(entities);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to get notifications',
          ),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  UserDetailsEntity _mapUserDetailsToEntity(UserDetailsModel model) {
    return UserDetailsEntity(
      id: model.userDetails?.id ?? '',
      name: model.userDetails?.name ?? '',
      email: model.userDetails?.email ?? '',
      phone: model.userDetails?.phone ?? '',
      profileImage: model.userDetails?.profileImage,
      tier: model.userDetails?.tier ?? 'Moon',
      loyaltyPoints: model.userDetails?.loyalityPoints ?? 0,
      walletAmount: model.userDetails?.walletAmount ?? 0.0,
      currencyCode: model.userDetails?.currencyCode ?? 'INR',
      communityId: model.userDetails?.communityId ?? '',
      banners:
          model.banners
              ?.map(
                (banner) => BannerEntity(
                  id: banner.id ?? '',
                  image: banner.image ?? '',
                  type: banner.type ?? '',
                ),
              )
              .toList() ??
          [],
      marquee: model.marquee,
      stateEmail: model.stateEmail,
      isSpinned: model.isSpinned ?? false,
    );
  }

  NotificationEntity _mapNotificationToEntity(NotificationData notification) {
    return NotificationEntity(
      id: notification.id ?? '',
      title: notification.title ?? '',
      message: notification.message ?? '',
      createdAt: notification.createdAt ?? DateTime.now(),
    );
  }
}
