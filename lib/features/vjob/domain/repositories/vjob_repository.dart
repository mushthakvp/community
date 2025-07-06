import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/application_entity.dart';
import '../entities/company_entity.dart';
import '../entities/job_entity.dart';
import '../entities/post_entity.dart';

abstract class VJobRepository {
  // Job Management
  Future<Either<Failure, List<JobEntity>>> getJobs({
    int page = 1,
    int limit = 10,
    String? search,
    String? location,
    String? workStyle,
  });

  Future<Either<Failure, JobEntity>> getJobDetails(String jobId);

  Future<Either<Failure, JobEntity>> createJob(CreateJobParams params);

  Future<Either<Failure, JobEntity>> updateJob(
    String jobId,
    CreateJobParams params,
  );

  Future<Either<Failure, bool>> deleteJob(String jobId);

  // Application Management
  Future<Either<Failure, bool>> applyForJob(String jobId, String? resumeUrl);

  Future<Either<Failure, bool>> saveJob(String jobId);

  Future<Either<Failure, List<ApplicationEntity>>> getMyApplications({
    String status = 'all',
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<JobEntity>>> getSavedJobs({
    int page = 1,
    int limit = 10,
  });

  // Company Management
  Future<Either<Failure, CompanyEntity>> createCompany(
    CreateCompanyParams params,
  );

  Future<Either<Failure, CompanyEntity>> updateCompany(
    String companyId,
    CreateCompanyParams params,
  );

  Future<Either<Failure, List<CompanyEntity>>> getMyCompanies();

  // Post Management
  Future<Either<Failure, List<PostEntity>>> getPosts({
    String type = 'all',
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, PostEntity>> createPost(CreatePostParams params);

  Future<Either<Failure, PostEntity>> updatePost(
    String postId,
    CreatePostParams params,
  );

  Future<Either<Failure, bool>> deletePost(String postId);

  Future<Either<Failure, bool>> likePost(String postId);
}

// Parameter classes
class CreateJobParams {
  final String title;
  final String description;
  final String companyId;
  final String city;
  final String state;
  final String workStyle;
  final List<String> position;
  final List<String> schedule;
  final List<String> benefits;
  final int minimumSalary;
  final String education;
  final List<String> skills;
  final List<String> languages;
  final List<String> responsibilities;

  CreateJobParams({
    required this.title,
    required this.description,
    required this.companyId,
    required this.city,
    required this.state,
    required this.workStyle,
    required this.position,
    required this.schedule,
    required this.benefits,
    required this.minimumSalary,
    required this.education,
    required this.skills,
    required this.languages,
    required this.responsibilities,
  });
}

class CreateCompanyParams {
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String? website;
  final String? description;
  final String? latitude;
  final String? longitude;

  CreateCompanyParams({
    required this.name,
    required this.email,
    this.phone,
    this.image,
    this.website,
    this.description,
    this.latitude,
    this.longitude,
  });
}

class CreatePostParams {
  final String title;
  final String description;
  final String image;

  CreatePostParams({
    required this.title,
    required this.description,
    required this.image,
  });
}
