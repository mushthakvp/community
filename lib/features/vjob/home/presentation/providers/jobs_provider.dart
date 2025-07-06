import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/home_job_entity.dart';
import '../../domain/usecases/get_jobs_usecase.dart';
import '../../domain/usecases/save_job_usecase.dart';

enum JobsStatus { initial, loading, loaded, error, loadingMore }

class JobsProvider extends ChangeNotifier {
  final GetJobsUseCase _getJobsUseCase;
  final SaveJobUseCase _saveJobUseCase;

  JobsProvider({
    required GetJobsUseCase getJobsUseCase,
    required SaveJobUseCase saveJobUseCase,
  }) : _getJobsUseCase = getJobsUseCase,
       _saveJobUseCase = saveJobUseCase;

  // State
  JobsStatus _status = JobsStatus.initial;
  List<HomeJobEntity> _jobs = [];
  String _errorMessage = '';
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _selectedJobIndex = -1;

  // Getters
  JobsStatus get status => _status;
  List<HomeJobEntity> get jobs => _jobs;
  String get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  bool get isLoading => _status == JobsStatus.loading;
  bool get isLoadingMore => _status == JobsStatus.loadingMore;
  bool get isEmpty => _jobs.isEmpty && _status == JobsStatus.loaded;
  int get selectedJobIndex => _selectedJobIndex;

  // Methods
  Future<void> getJobs({bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        _currentPage = 1;
        _jobs.clear();
        _hasMoreData = true;
        _status = JobsStatus.loading;
      } else {
        if (!_hasMoreData || _status == JobsStatus.loadingMore) return;
        _status = JobsStatus.loadingMore;
      }

      notifyListeners();

      final result = await _getJobsUseCase(
        GetJobsParams(page: _currentPage, limit: _itemsPerPage),
      );

      result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = JobsStatus.error;
        },
        (newJobs) {
          if (newJobs.isEmpty) {
            _hasMoreData = false;
          } else {
            _jobs.addAll(newJobs);
            _currentPage++;
            if (newJobs.length < _itemsPerPage) {
              _hasMoreData = false;
            }
          }
          _status = JobsStatus.loaded;
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = JobsStatus.error;
    }

    notifyListeners();
  }

  Future<Result<bool>> saveJob(String jobId, int index) async {
    try {
      final result = await _saveJobUseCase(SaveJobParams(jobId: jobId));

      return result.fold(
        (failure) => Error(message: _getFailureMessage(failure)),
        (success) {
          if (success) {
            // Update the job's saved status locally
            final updatedJobs = List<HomeJobEntity>.from(_jobs);
            final currentJob = updatedJobs[index];
            updatedJobs[index] = currentJob.copyWith(
              isSaved: !currentJob.isSaved,
            );
            _jobs = updatedJobs;
            notifyListeners();
          }
          return Success(success);
        },
      );
    } catch (e) {
      return Error(message: 'An unexpected error occurred: $e');
    }
  }

  void setSelectedJobIndex(int index) {
    _selectedJobIndex = index;
    notifyListeners();
  }

  void reset() {
    _status = JobsStatus.initial;
    _jobs.clear();
    _errorMessage = '';
    _hasMoreData = true;
    _currentPage = 1;
    _selectedJobIndex = -1;
    notifyListeners();
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
      default:
        return 'An unexpected error occurred';
    }
  }
}
