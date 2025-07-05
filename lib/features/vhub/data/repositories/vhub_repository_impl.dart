import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/idea_entity.dart';
import '../../domain/repositories/vhub_repository.dart';
import '../models/idea_model.dart';

class VHubRepositoryImpl implements VHubRepository {
  final ApiClient _apiClient;

  VHubRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, List<IdeaEntity>>> getIdeas({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status;
      }

      final response = await _apiClient.get(
        'user/get-my-ideas',
        queryParameters: queryParams,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final ideas =
            (responseData['projects'] as List<dynamic>?)
                ?.map((e) => IdeaModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        return Right(ideas);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load ideas',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getIdeas: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getIdeas: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log('Unexpected error in getIdeas', error: e, stackTrace: stackTrace);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, IdeaEntity>> getIdeaDetails(String ideaId) async {
    try {
      final response = await _apiClient.get('user/get-ideas-detail?id=$ideaId');
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final idea = IdeaModel.fromJson(responseData['project']);
        return Right(idea);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load idea details',
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
  Future<Either<Failure, IdeaEntity>> createIdea(
    CreateIdeaParams params,
  ) async {
    try {
      final body = {
        'projectName': params.projectName,
        'founders': params.founders
            .map(
              (f) => {
                'name': f.name,
                'email': f.email,
                'contact': f.contact,
                'affiliation': f.affiliation,
              },
            )
            .toList(),
        'summaryOfIdea': params.summaryOfIdea,
        'longOfDevelopmentProgress': params.longOfDevelopmentProgress,
        'helpNeed': params.helpNeed,
        'aboutProject': params.aboutProject,
        'reasonForDoingProject': params.reasonForDoingProject,
        'whoWillBuy': params.whoWillBuy,
        'isConnectedWithFoundersWork': params.isConnectedWithFoundersWork,
        'foundersSignature': params.foundersSignature
            .map((s) => {'name': s.name, 'signature': s.signature})
            .toList(),
      };

      final response = await _apiClient.post('user/create-idea', body: body);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final idea = IdeaModel.fromJson(responseData['project']);
        return Right(idea);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to create idea',
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
  Future<Either<Failure, IdeaEntity>> updateIdea(
    UpdateIdeaParams params,
  ) async {
    try {
      final body = {
        'id': params.id,
        'projectName': params.projectName,
        'founders': params.founders
            .map(
              (f) => {
                'name': f.name,
                'email': f.email,
                'contact': f.contact,
                'affiliation': f.affiliation,
              },
            )
            .toList(),
        'summaryOfIdea': params.summaryOfIdea,
        'longOfDevelopmentProgress': params.longOfDevelopmentProgress,
        'helpNeed': params.helpNeed,
        'aboutProject': params.aboutProject,
        'reasonForDoingProject': params.reasonForDoingProject,
        'whoWillBuy': params.whoWillBuy,
        'isConnectedWithFoundersWork': params.isConnectedWithFoundersWork,
        'foundersSignature': params.foundersSignature
            .map((s) => {'name': s.name, 'signature': s.signature})
            .toList(),
      };

      final response = await _apiClient.post('user/create-idea', body: body);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final idea = IdeaModel.fromJson(responseData['project']);
        return Right(idea);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to update idea',
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
  Future<Either<Failure, bool>> deleteIdea(String ideaId) async {
    try {
      final response = await _apiClient.delete('user/delete-idea?id=$ideaId');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(true);
      } else {
        final responseData = json.decode(response.body);
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to delete idea',
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
  Future<Either<Failure, List<FaqEntity>>> getFaqs({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiClient.get(
        'user/get-vHub-faqs',
        queryParameters: queryParams,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final faqs =
            (responseData['faqs'] as List<dynamic>?)
                ?.map((e) => FaqModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        return Right(faqs);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load FAQs',
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
}
