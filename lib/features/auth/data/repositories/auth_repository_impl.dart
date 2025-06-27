// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    String? firebaseId,
  }) async {
    try {
      final requestData = LoginRequestModel(
        email: email,
        password: password,
        firebaseId: firebaseId ?? "empty token",
      );
      final response = await apiClient.post(
        ApiConstants.login,
        body: requestData.toJson(),
      );
      final responseData = json.decode(response.body);
      final loginResponse = LoginResponseModel.fromJson(responseData);
      if (loginResponse.success) {
        if (loginResponse.token != null) {
          await StorageService.saveToken(loginResponse.token!);
        }
        if (loginResponse.user != null) {
          await Future.wait([
            StorageService.setLoggedIn(true),
            StorageService.saveUserId(loginResponse.user!.id),
            StorageService.saveUserEmail(loginResponse.user!.email),
            StorageService.setCountryName(
              loginResponse.user?.country ?? "India",
            ),
            StorageService.saveUserData(
              name: loginResponse.user?.name ?? "",
              email: loginResponse.user?.email ?? "",
              phone: loginResponse.user?.phone ?? "",
              communityId: loginResponse.user?.id ?? "",
              tier: loginResponse.user?.tier ?? 'Moon',
              loyaltyPoints: loginResponse.user?.loyaltyPoints ?? 0,
              walletAmount: loginResponse.user?.walletAmount ?? 0,
              currencyCode: loginResponse.user?.currencyCode ?? 'INR',
              joinedDate: DateTime.now().toIso8601String(),
            ),
          ]);
          return Right(loginResponse.user!);
        } else {
          return const Left(AuthFailure(message: 'User data not found'));
        }
      } else {
        return Left(
          AuthFailure(message: loginResponse.message ?? 'Login failed'),
        );
      }
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String dialCode,
    required String gender,
    required String dateOfBirth,
    required String profession,
    required String country,
    required String state,
    required String stateCode,
    String? district,
    required String verificationMethod,
    String? profileImage,
    String? referralCode,
    String? firebaseId,
  }) async {
    try {
      await StorageService.setCountryName(country);
      final requestData = RegisterRequestModel(
        name: name,
        email: email,
        phone: phone,
        password: password,
        dialCode: dialCode,
        gender: gender,
        dateOfBirth: dateOfBirth,
        profession: profession,
        country: country,
        state: state,
        stateCode: stateCode,
        district: district,
        verificationMethod: verificationMethod,
        profileImage: profileImage,
        referralCode: referralCode,
        firebaseId: firebaseId ?? "empty token",
      );
      final response = await apiClient.post(
        ApiConstants.register,
        body: requestData.toJson(),
      );
      debugPrint("Response: $response");
      final responseData = json.decode(response.body);
      final success = responseData['success'] ?? false;
      if (success) {
        return const Right(true);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Registration failed',
          ),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String otp,
    required String email,
    String? phone,
    String? dialCode,
    required String method,
    String? firebaseId,
  }) async {
    try {
      final requestData = OtpRequestModel(
        otp: otp,
        email: email,
        phone: phone,
        dialCode: dialCode,
        method: method,
        firebaseId: firebaseId ?? "empty token",
      );
      final response = await apiClient.post(
        ApiConstants.verifyOtp,
        body: requestData.toJson(),
      );
      final responseData = json.decode(response.body);
      final success = responseData['status'] ?? false;
      if (success) {
        if (responseData['token'] != null) {
          await StorageService.setSecureString(
            'access_token',
            responseData['token'],
          );
        }
        UserEntity? user;
        if (responseData['userDetails'] != null) {
          final userDetails = responseData['userDetails'];
          await StorageService.saveUserData(
            name: userDetails['name'] ?? '',
            email: userDetails['email'] ?? email,
            phone: userDetails['phone'] ?? '',
            communityId: userDetails['communityId'] ?? '',
            tier: userDetails['tier'] ?? '',
            loyaltyPoints: userDetails['loyalityPoints'] ?? 0,
            walletAmount: (userDetails['walletAmount'] ?? 0).toDouble(),
            currencyCode: userDetails['currencyCode'] ?? 'INR',
            joinedDate: userDetails['joined'],
          );
          await StorageService.saveUserId(userDetails['id']);
          await StorageService.saveUserEmail(userDetails['email'] ?? email);
          user = UserEntity(
            name: userDetails['name'] ?? '',
            id: userDetails['id'] ?? '',
            email: userDetails['email'] ?? '',
            phone: userDetails['phone'] ?? '',
            country: userDetails['country'] ?? '',
            state: userDetails['state'] ?? '',
            tier: userDetails['tier'] ?? '',
            loyaltyPoints: userDetails['loyalityPoints'] ?? 0,
            walletAmount: (userDetails['walletAmount'] ?? 0).toDouble(),
          );
        }
        await StorageService.setLoggedIn(true);
        return Right(user!);
      } else {
        return Left(
          AuthFailure(
            message: responseData['message'] ?? 'OTP verification failed',
          ),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resendOtp({
    required String email,
    String? phone,
    String? dialCode,
    required String method,
  }) async {
    try {
      final requestData = {
        'email': email,
        'phone': phone,
        'dialCode': dialCode,
        'method': method,
      };
      final response = await apiClient.post(
        ApiConstants.resendOtp,
        body: requestData,
      );
      final responseData = json.decode(response.body);
      final success = responseData['status'] ?? false;
      if (success) {
        return const Right(true);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to resend OTP',
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

  @override
  Future<Either<Failure, bool>> forgotPassword({required String email}) async {
    try {
      final response = await apiClient.post(
        ApiConstants.forgotPassword,
        body: {'email': email},
      );
      final responseData = json.decode(response.body);
      final success = responseData['status'] ?? false;
      if (success) {
        return const Right(true);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to send reset email',
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

  @override
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.resetPassword,
        body: {'email': email, 'password': password},
      );
      final responseData = json.decode(response.body);
      final success = responseData['status'] ?? false;
      if (success) {
        return const Right(true);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to reset password',
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

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await StorageService.clearAuthTokens();
      await StorageService.setLoggedIn(false);
      return const Right(null);
    } on ServerException catch (e) {
      await StorageService.clearAuthTokens();
      await StorageService.setLoggedIn(false);
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      await StorageService.clearAuthTokens();
      await StorageService.setLoggedIn(false);
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      await StorageService.clearAuthTokens();
      await StorageService.setLoggedIn(false);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final isLoggedIn = StorageService.isLoggedIn();
      if (!isLoggedIn) {
        return const Left(AuthFailure(message: 'User not logged in'));
      }
      final userData = await StorageService.getUserData();
      final userId = await StorageService.getUserId();
      final userEmail = await StorageService.getUserEmail();
      if (userData['name'].isNotEmpty && userId != null && userEmail != null) {
        final user = UserEntity(
          id: userId,
          name: userData['name'],
          email: userEmail,
          phone: userData['phone'],
          tier: userData['tier'],
          loyaltyPoints: userData['loyaltyPoints'],
          walletAmount: userData['walletAmount'],
        );
        return Right(user);
      }
      final response = await apiClient.get(ApiConstants.profile);
      final responseData = json.decode(response.body);
      if (responseData['status'] == true && responseData['user'] != null) {
        final user = UserModel.fromJson(responseData['user']);
        await StorageService.saveUserData(
          name: user.name,
          email: user.email,
          phone: user.phone,
          communityId: user.id,
          tier: user.tier ?? 'Moon',
          loyaltyPoints: user.loyaltyPoints,
          walletAmount: user.walletAmount,
          currencyCode: 'INR',
        );
        return Right(user);
      } else {
        return const Left(AuthFailure(message: 'User not found'));
      }
    } on ServerException catch (e) {
      final userData = await StorageService.getUserData();
      final userId = await StorageService.getUserId();
      final userEmail = await StorageService.getUserEmail();
      if (userData['name'].isNotEmpty && userId != null && userEmail != null) {
        final user = UserEntity(
          id: userId,
          name: userData['name'],
          email: userEmail,
          phone: userData['phone'],
          tier: userData['tier'],
          loyaltyPoints: userData['loyaltyPoints'],
          walletAmount: userData['walletAmount'],
        );
        return Right(user);
      }
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      final userData = await StorageService.getUserData();
      final userId = await StorageService.getUserId();
      final userEmail = await StorageService.getUserEmail();
      if (userData['name'].isNotEmpty && userId != null && userEmail != null) {
        final user = UserEntity(
          id: userId,
          name: userData['name'],
          email: userEmail,
          phone: userData['phone'],
          tier: userData['tier'],
          loyaltyPoints: userData['loyaltyPoints'],
          walletAmount: userData['walletAmount'],
        );
        return Right(user);
      }
      return Left(NetworkFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
