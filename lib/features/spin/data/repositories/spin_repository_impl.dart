import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/spin_data_entity.dart';
import '../../domain/entities/spin_history_entity.dart';
import '../../domain/entities/spin_result_entity.dart';
import '../../domain/repositories/spin_repository.dart';
import '../models/spin_history_model.dart';
import '../models/spin_model.dart';
import '../models/spin_result_model.dart';

class SpinRepositoryImpl implements SpinRepository {
  final ApiClient _apiClient;

  SpinRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, SpinDataEntity>> getSpinData(String spinType) async {
    try {
      if (spinType.isEmpty) {
        return const Left(ValidationFailure(message: 'Spin type is required'));
      }

      final response = await _apiClient.get(
        '${ApiConstants.getSpinAndEarnData}$spinType',
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final spinDataModel = GetSpinDataModel.fromJson(responseData);

        if (spinDataModel.success == true) {
          return Right(spinDataModel.toEntity());
        } else {
          return Left(
            ServerFailure(
              message: spinDataModel.message ?? 'Failed to load spin data',
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load spin data',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getSpinData: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getSpinData: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getSpinData',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        UnknownFailure(message: 'Failed to load spin data: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, SpinResultEntity>> executeSpin(String optionId) async {
    try {
      if (optionId.isEmpty) {
        return const Left(ValidationFailure(message: 'Option ID is required'));
      }

      final body = {"spinOptionId": optionId};

      final response = await _apiClient.post(
        ApiConstants.userDialySpin,
        body: body,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final spinResultModel = SpinResultModel.fromJson(responseData);
        return Right(spinResultModel.toEntity());
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to execute spin',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in executeSpin: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in executeSpin: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } on ValidationException catch (e) {
      dev.log('Validation exception in executeSpin: ${e.message}');
      return Left(ValidationFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in executeSpin',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        UnknownFailure(message: 'Failed to execute spin: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<SpinHistoryEntity>>> getSpinHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (page < 1) {
        return const Left(
          ValidationFailure(message: 'Page must be greater than 0'),
        );
      }

      if (limit < 1 || limit > 100) {
        return const Left(
          ValidationFailure(message: 'Limit must be between 1 and 100'),
        );
      }

      final response = await _apiClient.get(
        '${ApiConstants.getSpinAndEarnHistory}?page=$page&limit=$limit',
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final historyResponse = SpinHistoryResponseModel.fromJson(responseData);

        if (historyResponse.success == true && historyResponse.data != null) {
          final historyEntities = historyResponse.data!
              .map((item) => item.toEntity())
              .toList();

          return Right(historyEntities);
        } else {
          return Left(ServerFailure(message: 'Failed to load spin history'));
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load spin history',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getSpinHistory: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getSpinHistory: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } on ValidationException catch (e) {
      dev.log('Validation exception in getSpinHistory: ${e.message}');
      return Left(ValidationFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getSpinHistory',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        UnknownFailure(message: 'Failed to load spin history: ${e.toString()}'),
      );
    }
  }
}
