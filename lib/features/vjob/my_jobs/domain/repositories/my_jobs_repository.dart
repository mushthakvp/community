import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/my_job_entity.dart';

/// Abstract repository defining the contract for My Jobs data operations
abstract class MyJobsRepository {
  /// Get jobs by status with pagination support
  ///
  /// [status] - The job status ('Applied' or 'Saved')
  /// [page] - Current page number (starts from 1)
  /// [limit] - Number of items per page
  ///
  /// the list of jobs and pagination metadata
  Future<Either<Failure, MyJobsResult>> getMyJobs({
    required MyJobStatus status,
    int page = 1,
    int limit = 10,
  });

  /// Update job status (save/unsave a job)
  ///
  /// [jobId] - The ID of the job record to update
  /// [status] - New status to set
  ///
  Future<Either<Failure, bool>> updateJobStatus({
    required String jobId,
    required MyJobStatus status,
  });

  /// Remove a job from user's list (unsave/withdraw application)
  ///
  /// [jobId] - The ID of the job record to remove
  ///
  Future<Either<Failure, bool>> removeJob(String jobId);

  /// Clear local cache for fresh data
  Future<Either<Failure, void>> clearCache();
}

/// Result wrapper for paginated job data
class MyJobsResult {
  final List<MyJobEntity> jobs;
  final int total;
  final int totalPages;
  final int currentPage;
  final bool hasMoreData;

  const MyJobsResult({
    required this.jobs,
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.hasMoreData,
  });

  MyJobsResult copyWith({
    List<MyJobEntity>? jobs,
    int? total,
    int? totalPages,
    int? currentPage,
    bool? hasMoreData,
  }) {
    return MyJobsResult(
      jobs: jobs ?? this.jobs,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}
