import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/candidate_entity.dart';
import '../../domain/entities/company_job_entity.dart';
import '../../domain/usecases/get_job_candidates_usecase.dart';
import '../../domain/usecases/mark_job_as_closed_usecase.dart';
import '../../domain/usecases/reapply_job_usecase.dart';

enum CompanyJobStatus { initial, loading, loaded, error, loadingMore }

class CompanyJobProvider extends ChangeNotifier {
  final GetJobCandidatesUseCase _getJobCandidatesUseCase;
  final MarkJobAsClosedUseCase _markJobAsClosedUseCase;
  final ReapplyJobUseCase _reapplyJobUseCase;

  CompanyJobProvider({
    required GetJobCandidatesUseCase getJobCandidatesUseCase,
    required MarkJobAsClosedUseCase markJobAsClosedUseCase,
    required ReapplyJobUseCase reapplyJobUseCase,
  }) : _getJobCandidatesUseCase = getJobCandidatesUseCase,
       _markJobAsClosedUseCase = markJobAsClosedUseCase,
       _reapplyJobUseCase = reapplyJobUseCase;

  // State
  CompanyJobStatus _status = CompanyJobStatus.initial;
  CompanyJobEntity? _currentJob;
  final List<CandidateEntity> _candidates = [];
  String _errorMessage = '';
  bool _hasMoreCandidates = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  String _currentJobId = '';

  // Getters
  CompanyJobStatus get status => _status;
  CompanyJobEntity? get currentJob => _currentJob;
  List<CandidateEntity> get candidates => _candidates;
  String get errorMessage => _errorMessage;
  bool get hasMoreCandidates => _hasMoreCandidates;
  bool get isLoading => _status == CompanyJobStatus.loading;
  bool get isLoadingMore => _status == CompanyJobStatus.loadingMore;
  bool get isEmpty => _candidates.isEmpty && _status == CompanyJobStatus.loaded;
  String get currentJobId => _currentJobId;

  // Methods
  void initializeWithJob(CompanyJobEntity job) {
    _currentJob = job;
    _currentJobId = job.id;
    _resetCandidatesList();
    getCandidates(job.id);
  }

  Future<void> getCandidates(String jobId, {bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        _currentJobId = jobId;
        _currentPage = 1;
        _candidates.clear();
        _hasMoreCandidates = true;
        _status = CompanyJobStatus.loading;
      } else {
        if (!_hasMoreCandidates || _status == CompanyJobStatus.loadingMore) {
          return;
        }
        _status = CompanyJobStatus.loadingMore;
      }

      notifyListeners();

      final result = await _getJobCandidatesUseCase(
        GetJobCandidatesParams(
          jobId: jobId,
          page: _currentPage,
          limit: _itemsPerPage,
        ),
      );

      result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = CompanyJobStatus.error;
        },
        (newCandidates) {
          if (newCandidates.isEmpty) {
            _hasMoreCandidates = false;
          } else {
            _candidates.addAll(newCandidates);
            _currentPage++;
            if (newCandidates.length < _itemsPerPage) {
              _hasMoreCandidates = false;
            }
          }
          _status = CompanyJobStatus.loaded;
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = CompanyJobStatus.error;
    }

    notifyListeners();
  }

  Future<Result<bool>> markJobAsClosed(String jobId) async {
    try {
      final result = await _markJobAsClosedUseCase(
        MarkJobAsClosedParams(jobId: jobId),
      );

      return result.fold(
        (failure) => Error(message: _getFailureMessage(failure)),
        (success) {
          if (success && _currentJob != null) {
            // Update the current job status locally if needed
            // This depends on your job entity structure
          }
          return Success(success);
        },
      );
    } catch (e) {
      return Error(message: 'An unexpected error occurred: $e');
    }
  }

  Future<Result<bool>> reapplyJob(String jobId) async {
    try {
      final result = await _reapplyJobUseCase(ReapplyJobParams(jobId: jobId));

      return result.fold(
        (failure) => Error(message: _getFailureMessage(failure)),
        (success) {
          if (success && _currentJob != null) {
            // Update the current job status locally
            _currentJob = _currentJob!.copyWith(isRejected: false);
            notifyListeners();
          }
          return Success(success);
        },
      );
    } catch (e) {
      return Error(message: 'An unexpected error occurred: $e');
    }
  }

  void updateCurrentJob(CompanyJobEntity job) {
    _currentJob = job;
    notifyListeners();
  }

  void _resetCandidatesList() {
    _candidates.clear();
    _currentPage = 1;
    _hasMoreCandidates = true;
    _status = CompanyJobStatus.initial;
  }

  void reset() {
    _status = CompanyJobStatus.initial;
    _currentJob = null;
    _candidates.clear();
    _errorMessage = '';
    _hasMoreCandidates = true;
    _currentPage = 1;
    _currentJobId = '';
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
