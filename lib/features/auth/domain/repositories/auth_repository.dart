import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    String? firebaseId,
  });

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
  });

  Future<Either<Failure, bool>> verifyOtp({
    required String otp,
    required String email,
    String? phone,
    String? dialCode,
    required String method,
    String? firebaseId,
  });

  Future<Either<Failure, bool>> resendOtp({
    required String email,
    String? phone,
    String? dialCode,
    required String method,
  });

  Future<Either<Failure, bool>> forgotPassword({required String email});

  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();
}
