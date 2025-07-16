import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/my_job_entity.dart';
import '../../domain/usecases/get_my_jobs_usecase.dart';
import '../../domain/usecases/update_job_status_usecase.dart';

/// Status enum for My Jobs provider
enum MyJobsStatus { initial, loading, loaded, error, loadingMore }

/// Provider for managing My Jobs state and business logic
class MyJobsProvider extends ChangeNotifier {
  final GetMyJobsUseCase _getMyJobsUseCase;
  final UpdateJobStatusUseCase _updateJobStatusUseCase;

  MyJobsProvider({
    required GetMyJobsUseCase getMyJobsUseCase,
    required UpdateJobStatusUseCase updateJobStatusUseCase,
  }) : _getMyJobsUseCase = getMyJobsUseCase,
       _updateJobStatusUseCase = updateJobStatusUseCase;

  // Private state variables
  MyJobsStatus _status = MyJobsStatus.initial;
  final List<MyJobEntity> _jobs = [];
  String _errorMessage = '';
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  MyJobStatus _currentTabStatus = MyJobStatus.applied;
  bool _isFirstTimeLoading = true;

  // Public getters
  MyJobsStatus get status => _status;
  List<MyJobEntity> get jobs => _jobs;
  String get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  bool get isLoading => _status == MyJobsStatus.loading;
  bool get isLoadingMore => _status == MyJobsStatus.loadingMore;
  bool get isEmpty => _jobs.isEmpty && _status == MyJobsStatus.loaded;
  bool get isFirstTimeLoading => _isFirstTimeLoading;
  MyJobStatus get currentTabStatus => _currentTabStatus;
  int get jobsCount => _jobs.length;

  Future<void> getJobs({MyJobStatus? status, bool isLoadMore = false}) async {
    try {
      final targetStatus = status ?? _currentTabStatus;
      if (!isLoadMore) {
        _currentPage = 1;
        _jobs.clear();
        _hasMoreData = true;
        _status = MyJobsStatus.loading;
        _isFirstTimeLoading = true;
      } else {
        if (!_hasMoreData || _status == MyJobsStatus.loadingMore) {
          return;
        }
        _status = MyJobsStatus.loadingMore;
      }
      notifyListeners();
      final result = await _getMyJobsUseCase(
        GetMyJobsParams(
          status: targetStatus,
          page: _currentPage,
          limit: _itemsPerPage,
        ),
      );
      result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = MyJobsStatus.error;
        },
        (jobsResult) {
          if (jobsResult.jobs.isEmpty && _currentPage == 1) {
            _hasMoreData = false;
          } else {
            _jobs.addAll(jobsResult.jobs);
            _currentPage++;
            _hasMoreData = jobsResult.hasMoreData;
          }
          _status = MyJobsStatus.loaded;
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = MyJobsStatus.error;
    } finally {
      _isFirstTimeLoading = false;
      notifyListeners();
    }
  }

  Future<void> setTabStatus(MyJobStatus status) async {
    if (_currentTabStatus == status) return;
    _currentTabStatus = status;
    await clearAndRefresh();
  }

  Future<Result<bool>> removeJob(String jobId, int index) async {
    try {
      if (index >= 0 && index < _jobs.length) {
        final removedJob = _jobs.removeAt(index);
        notifyListeners();
        final result = await _updateJobStatusUseCase(
          UpdateJobStatusParams.remove(jobId),
        );
        return result.fold(
          (failure) {
            _jobs.insert(index, removedJob);
            notifyListeners();
            return Error(message: _getFailureMessage(failure));
          },
          (success) {
            return Success(success);
          },
        );
      } else {
        return const Error(message: 'Invalid job index');
      }
    } catch (e) {
      return Error(message: 'An unexpected error occurred: $e');
    }
  }

  Future<Result<bool>> updateJobStatus({
    required String jobId,
    required MyJobStatus newStatus,
    required int index,
  }) async {
    try {
      if (index >= 0 && index < _jobs.length) {
        final originalJob = _jobs[index];
        final updatedJob = originalJob.copyWith(status: newStatus);
        _jobs[index] = updatedJob;
        notifyListeners();
        final result = await _updateJobStatusUseCase(
          UpdateJobStatusParams.updateStatus(
            jobId: jobId,
            newStatus: newStatus,
          ),
        );
        return result.fold(
          (failure) {
            _jobs[index] = originalJob;
            notifyListeners();
            return Error(message: _getFailureMessage(failure));
          },
          (success) {
            return Success(success);
          },
        );
      } else {
        return const Error(message: 'Invalid job index');
      }
    } catch (e) {
      return Error(message: 'An unexpected error occurred: $e');
    }
  }

  /// Refresh current tab
  Future<void> refresh() async {
    await getJobs(status: _currentTabStatus);
  }

  /// Clear all data and refresh
  Future<void> clearAndRefresh() async {
    _clearState();
    await getJobs(status: _currentTabStatus);
  }

  /// Reset provider to initial state
  void reset() {
    _clearState();
    _currentTabStatus = MyJobStatus.applied;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!_hasMoreData || _status == MyJobsStatus.loadingMore) {
      return;
    }
    await getJobs(isLoadMore: true);
  }

  /// Private method to clear state
  void _clearState() {
    _status = MyJobsStatus.initial;
    _jobs.clear();
    _errorMessage = '';
    _hasMoreData = true;
    _currentPage = 1;
    _isFirstTimeLoading = true;
  }

  String _getFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return failure.message.isNotEmpty
            ? failure.message
            : 'Server error occurred';
      case NetworkFailure _:
        return 'No internet connection';
      case CacheFailure _:
        return 'Cache error occurred';
      case ValidationFailure _:
        return failure.message;
      default:
        return failure.message.isNotEmpty
            ? failure.message
            : 'An unexpected error occurred';
    }
  }
}
