import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/vjob_repository.dart';
import '../models/application_model.dart';
import '../models/company_model.dart';
import '../models/job_details_response_model.dart';
import '../models/job_model.dart';
import '../models/jobs_response_model.dart';
import '../models/post_model.dart';

class VJobRepositoryImpl implements VJobRepository {
  final ApiClient _apiClient;

  VJobRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, List<JobEntity>>> getJobs({
    int page = 1,
    int limit = 10,
    String? search,
    String? location,
    String? workStyle,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (location != null && location.isNotEmpty) {
        queryParams['location'] = location;
      }
      if (workStyle != null && workStyle.isNotEmpty) {
        queryParams['workStyle'] = workStyle;
      }

      final response = await _apiClient.get(
        ApiConstants.getJobs,
        queryParameters: queryParams,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jobsResponse = JobsResponseModel.fromJson(responseData);

        if (jobsResponse.success) {
          return Right(jobsResponse.jobs);
        } else {
          return Left(ServerFailure(message: jobsResponse.message));
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load jobs',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getJobs: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getJobs: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log('Unexpected error in getJobs', error: e, stackTrace: stackTrace);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, JobEntity>> getJobDetails(String jobId) async {
    try {
      if (jobId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid job ID'));
      }

      final response = await _apiClient.get(
        '${ApiConstants.getJobDetails}$jobId',
      );
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jobDetailsResponse = JobDetailsResponseModel.fromJson(
          responseData,
        );

        if (jobDetailsResponse.success) {
          return Right(jobDetailsResponse.job);
        } else {
          return Left(ServerFailure(message: jobDetailsResponse.message));
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load job details',
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
  Future<Either<Failure, JobEntity>> updateJob(
    String jobId,
    CreateJobParams params,
  ) async {
    try {
      final requestBody = {
        'action': 'update',
        'id': jobId,
        'title': params.title,
        'description': params.description,
        'company': params.companyId,
        'city': params.city,
        'state': params.state,
        'workStyle': params.workStyle,
        'position': params.position,
        'schedule': params.schedule,
        'benefits': params.benefits,
        'minimumSalary': params.minimumSalary,
        'education': params.education,
        'skills': params.skills,
        'languages': params.languages,
        'responsibilities': params.responsibilities,
      };

      final response = await _apiClient.put(
        ApiConstants.updateJob,
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final job = JobModel.fromJson(responseData['job'] ?? {});
        return Right(job);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to update job',
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
  Future<Either<Failure, bool>> deleteJob(String jobId) async {
    try {
      if (jobId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid job ID'));
      }

      final response = await _apiClient.delete(
        '${ApiConstants.deleteJob}$jobId',
      );
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(responseData['success'] ?? false);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to delete job',
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
  Future<Either<Failure, bool>> applyForJob(
    String jobId,
    String? resumeUrl,
  ) async {
    try {
      if (jobId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid job ID'));
      }

      final requestBody = {
        'id': jobId,
        if (resumeUrl != null) 'resume': resumeUrl,
      };

      final response = await _apiClient.post(
        ApiConstants.applyJob,
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(responseData['success'] ?? false);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to apply for job',
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
  Future<Either<Failure, bool>> saveJob(String jobId) async {
    try {
      if (jobId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid job ID'));
      }

      final requestBody = {'id': jobId};

      final response = await _apiClient.post(
        ApiConstants.saveJob,
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(responseData['success'] ?? false);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to save job',
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
  Future<Either<Failure, List<ApplicationEntity>>> getMyApplications({
    String status = 'all',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'status': status,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiClient.get(
        ApiConstants.getMyApplications,
        queryParameters: queryParams,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final applications =
            (responseData['jobs'] as List<dynamic>?)
                ?.map((appJson) => ApplicationModel.fromJson(appJson))
                .toList() ??
            [];

        return Right(applications);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load applications',
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
  Future<Either<Failure, List<JobEntity>>> getSavedJobs({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'status': 'Saved',
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiClient.get(
        ApiConstants.getSavedJobs,
        queryParameters: queryParams,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jobs =
            (responseData['jobs'] as List<dynamic>?)
                ?.map((jobJson) => JobModel.fromJson(jobJson['jobId'] ?? {}))
                .toList() ??
            [];

        return Right(jobs);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load saved jobs',
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
  Future<Either<Failure, CompanyEntity>> createCompany(
    CreateCompanyParams params,
  ) async {
    try {
      final requestBody = {
        'action': 'create',
        'name': params.name,
        'email': params.email,
        if (params.phone != null) 'phone': params.phone,
        if (params.image != null) 'image': params.image,
        if (params.website != null) 'website': params.website,
        if (params.description != null) 'description': params.description,
        if (params.latitude != null) 'lat': params.latitude,
        if (params.longitude != null) 'lng': params.longitude,
      };

      final response = await _apiClient.post(
        ApiConstants.createCompany,
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final company = CompanyModel.fromJson(responseData['company'] ?? {});
        return Right(company);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to create company',
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
  Future<Either<Failure, CompanyEntity>> updateCompany(
    String companyId,
    CreateCompanyParams params,
  ) async {
    try {
      final requestBody = {
        'action': 'update',
        'id': companyId,
        'name': params.name,
        'email': params.email,
        if (params.phone != null) 'phone': params.phone,
        if (params.image != null) 'image': params.image,
        if (params.website != null) 'website': params.website,
        if (params.description != null) 'description': params.description,
        if (params.latitude != null) 'lat': params.latitude,
        if (params.longitude != null) 'lng': params.longitude,
      };

      final response = await _apiClient.put(
        ApiConstants.updateCompany,
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final company = CompanyModel.fromJson(responseData['company'] ?? {});
        return Right(company);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to update company',
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
  Future<Either<Failure, List<CompanyEntity>>> getMyCompanies() async {
    try {
      final response = await _apiClient.get(ApiConstants.getMyCompanies);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final companies =
            (responseData['companies'] as List<dynamic>?)
                ?.map((companyJson) => CompanyModel.fromJson(companyJson))
                .toList() ??
            [];

        return Right(companies);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load companies',
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
  Future<Either<Failure, List<PostEntity>>> getPosts({
    String type = 'all',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get('${ApiConstants.getPosts}$type');
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final posts =
            (responseData['posts'] as List<dynamic>?)
                ?.map((postJson) => PostModel.fromJson(postJson))
                .toList() ??
            [];

        return Right(posts);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load posts',
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
  Future<Either<Failure, PostEntity>> createPost(
    CreatePostParams params,
  ) async {
    try {
      final requestBody = {
        'title': params.title,
        'description': params.description,
        'image': params.image,
      };

      final response = await _apiClient.post(
        ApiConstants.createPost,
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final post = PostModel.fromJson(responseData['post'] ?? {});
        return Right(post);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to create post',
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
  Future<Either<Failure, PostEntity>> updatePost(
    String postId,
    CreatePostParams params,
  ) async {
    try {
      final requestBody = {
        'postId': postId,
        'action': 'update',
        'title': params.title,
        'description': params.description,
        'image': params.image,
      };

      final response = await _apiClient.put(
        ApiConstants.updatePost,
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final post = PostModel.fromJson(responseData['post'] ?? {});
        return Right(post);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to update post',
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
  Future<Either<Failure, bool>> deletePost(String postId) async {
    try {
      final requestBody = {'postId': postId, 'action': 'delete'};

      final response = await _apiClient.delete(
        ApiConstants.deletePost,
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(responseData['success'] ?? false);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to delete post',
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
  Future<Either<Failure, bool>> likePost(String postId) async {
    try {
      final requestBody = {'postId': postId};

      final response = await _apiClient.post(
        ApiConstants.likePost,
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(responseData['success'] ?? false);
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to like post',
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
  Future<Either<Failure, JobEntity>> createJob(CreateJobParams params) {
    // TODO: implement createJob
    throw UnimplementedError();
  }
}
