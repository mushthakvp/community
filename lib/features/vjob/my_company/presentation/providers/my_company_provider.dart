import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/created_job_entity.dart';
import '../../domain/usecases/get_company_usecase.dart';
import '../../domain/usecases/get_created_jobs_usecase.dart';
import '../../domain/usecases/mark_job_closed_usecase.dart';
import '../../domain/usecases/reapply_job_usecase.dart';

enum MyCompanyStatus { initial, loading, loaded, error, empty }

enum CreatedJobsStatus { initial, loading, loaded, error, loadingMore }

class MyCompanyProvider extends ChangeNotifier {
  final GetCompanyUseCase _getCompanyUseCase;
  final GetCreatedJobsUseCase _getCreatedJobsUseCase;
  final ReapplyJobUseCase _reapplyJobUseCase;
  final MarkJobClosedUseCase _markJobClosedUseCase;

  MyCompanyProvider({
    required GetCompanyUseCase getCompanyUseCase,
    required GetCreatedJobsUseCase getCreatedJobsUseCase,
    required ReapplyJobUseCase reapplyJobUseCase,
    required MarkJobClosedUseCase markJobClosedUseCase,
  }) : _getCompanyUseCase = getCompanyUseCase,
       _getCreatedJobsUseCase = getCreatedJobsUseCase,
       _reapplyJobUseCase = reapplyJobUseCase,
       _markJobClosedUseCase = markJobClosedUseCase;

  // Company State
  MyCompanyStatus _companyStatus = MyCompanyStatus.initial;
  CompanyEntity? _company;
  String _companyErrorMessage = '';
  String? _placeName;

  // Created Jobs State
  CreatedJobsStatus _jobsStatus = CreatedJobsStatus.initial;
  final List<CreatedJobEntity> _createdJobs = [];
  String _jobsErrorMessage = '';
  String _selectedStatus = 'All';
  bool _hasMoreJobs = true;
  int _currentJobsPage = 1;
  final int _jobsPerPage = 10;

  // Getters
  MyCompanyStatus get companyStatus => _companyStatus;
  CompanyEntity? get company => _company;
  String get companyErrorMessage => _companyErrorMessage;
  String? get placeName => _placeName;

  CreatedJobsStatus get jobsStatus => _jobsStatus;
  List<CreatedJobEntity> get createdJobs => _createdJobs;
  String get jobsErrorMessage => _jobsErrorMessage;
  String get selectedStatus => _selectedStatus;
  bool get hasMoreJobs => _hasMoreJobs;
  bool get isJobsLoading => _jobsStatus == CreatedJobsStatus.loading;
  bool get isJobsLoadingMore => _jobsStatus == CreatedJobsStatus.loadingMore;
  bool get isJobsEmpty =>
      _createdJobs.isEmpty && _jobsStatus == CreatedJobsStatus.loaded;

  final List<String> statusList = ['All', 'Accepted', 'Requested', 'Rejected'];

  Future<void> getMyCompany() async {
    _companyStatus = MyCompanyStatus.loading;
    notifyListeners();

    final result = await _getCompanyUseCase(NoParams());

    result.fold(
      (failure) {
        _companyErrorMessage = _getFailureMessage(failure);
        _companyStatus =
            failure is ServerFailure &&
                failure.message.contains('No company found')
            ? MyCompanyStatus.empty
            : MyCompanyStatus.error;
      },
      (company) {
        _company = company;
        _companyStatus = MyCompanyStatus.loaded;
        _getPlaceNameFromLatLng();
        // Auto-fetch jobs when company is loaded
        if (company.id.isNotEmpty) {
          getCreatedJobs();
        }
      },
    );

    notifyListeners();
  }

  Future<void> getCreatedJobs({bool isLoadMore = false}) async {
    if (_company == null) return;

    if (!isLoadMore) {
      _currentJobsPage = 1;
      _createdJobs.clear();
      _hasMoreJobs = true;
      _jobsStatus = CreatedJobsStatus.loading;
    } else {
      if (!_hasMoreJobs || _jobsStatus == CreatedJobsStatus.loadingMore) return;
      _jobsStatus = CreatedJobsStatus.loadingMore;
    }

    notifyListeners();

    final result = await _getCreatedJobsUseCase(
      GetCreatedJobsParams(
        companyId: _company!.id,
        status: _selectedStatus,
        page: _currentJobsPage,
        limit: _jobsPerPage,
      ),
    );

    result.fold(
      (failure) {
        _jobsErrorMessage = _getFailureMessage(failure);
        _jobsStatus = CreatedJobsStatus.error;
      },
      (jobs) {
        if (jobs.isEmpty) {
          _hasMoreJobs = false;
        } else {
          _createdJobs.addAll(jobs);
          _currentJobsPage++;
          if (jobs.length < _jobsPerPage) {
            _hasMoreJobs = false;
          }
        }
        _jobsStatus = CreatedJobsStatus.loaded;
      },
    );

    notifyListeners();
  }

  Future<Result<bool>> reapplyJob(String jobId) async {
    final result = await _reapplyJobUseCase(ReapplyJobParams(jobId: jobId));

    return result.fold(
      (failure) => Error(message: _getFailureMessage(failure)),
      (success) {
        if (success) {
          // Refresh the jobs list
          getCreatedJobs();
        }
        return Success(success);
      },
    );
  }

  Future<Result<bool>> markJobAsClosed(String jobId) async {
    final result = await _markJobClosedUseCase(
      MarkJobClosedParams(jobId: jobId),
    );

    return result.fold(
      (failure) => Error(message: _getFailureMessage(failure)),
      (success) {
        if (success) {
          // Refresh the jobs list
          getCreatedJobs();
        }
        return Success(success);
      },
    );
  }

  void setStatus(String status) {
    if (_selectedStatus == status) return;

    _selectedStatus = status;
    _createdJobs.clear();
    _hasMoreJobs = true;
    _currentJobsPage = 1;
    _jobsStatus = CreatedJobsStatus.initial;
    notifyListeners();

    getCreatedJobs();
  }

  Future<void> _getPlaceNameFromLatLng() async {
    if (_company?.location == null) return;

    try {
      final latitude = double.tryParse(_company!.location!.latitude) ?? 0.0;
      final longitude = double.tryParse(_company!.location!.longitude) ?? 0.0;

      if (latitude == 0.0 && longitude == 0.0) return;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _placeName = place.locality ?? "Location not found";
        notifyListeners();
      }
    } catch (e) {
      _placeName = "Location not found";
      notifyListeners();
    }
  }

  void reset() {
    _companyStatus = MyCompanyStatus.initial;
    _company = null;
    _companyErrorMessage = '';
    _placeName = null;

    _jobsStatus = CreatedJobsStatus.initial;
    _createdJobs.clear();
    _jobsErrorMessage = '';
    _selectedStatus = 'All';
    _hasMoreJobs = true;
    _currentJobsPage = 1;

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
