import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:livera/core/services/cloudinary_service.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/apply_job_entity.dart';
import '../../domain/entities/job_details_entity.dart';
import '../../domain/usecases/apply_job_usecase.dart';
import '../../domain/usecases/get_job_details_usecase.dart';
import '../../domain/usecases/save_job_usecase.dart';

enum JobDetailsStatus { initial, loading, loaded, error }

enum ApplyJobStatus { initial, loading, success, error }

class JobDetailsProvider extends ChangeNotifier {
  final GetJobDetailsUseCase _getJobDetailsUseCase;
  final ApplyJobUseCase _applyJobUseCase;
  final SaveJobUseCase _saveJobUseCase;

  JobDetailsProvider({
    required GetJobDetailsUseCase getJobDetailsUseCase,
    required ApplyJobUseCase applyJobUseCase,
    required SaveJobUseCase saveJobUseCase,
    required CloudinaryService fileUploadService,
  }) : _getJobDetailsUseCase = getJobDetailsUseCase,
       _applyJobUseCase = applyJobUseCase,
       _saveJobUseCase = saveJobUseCase;

  // State
  JobDetailsStatus _status = JobDetailsStatus.initial;
  ApplyJobStatus _applyStatus = ApplyJobStatus.initial;
  JobDetailsEntity? _jobDetails;
  String _errorMessage = '';
  String _applyErrorMessage = '';
  int _tabIndex = 0;

  // Resume state
  String _resumeUrl = '';
  String _resumeName = '';
  io.File? _selectedResumeFile;

  // Getters
  JobDetailsStatus get status => _status;
  ApplyJobStatus get applyStatus => _applyStatus;
  JobDetailsEntity? get jobDetails => _jobDetails;
  String get errorMessage => _errorMessage;
  String get applyErrorMessage => _applyErrorMessage;
  int get tabIndex => _tabIndex;
  String get resumeUrl => _resumeUrl;
  String get resumeName => _resumeName;
  bool get hasResumeSelected => _resumeName.isNotEmpty;
  bool get isLoading => _status == JobDetailsStatus.loading;
  bool get isApplyLoading => _applyStatus == ApplyJobStatus.loading;

  // Methods
  Future<void> getJobDetails(String jobId) async {
    try {
      _status = JobDetailsStatus.loading;
      _errorMessage = '';
      notifyListeners();

      final result = await _getJobDetailsUseCase(
        GetJobDetailsParams(jobId: jobId),
      );

      result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = JobDetailsStatus.error;
        },
        (jobDetails) {
          _jobDetails = jobDetails;
          _status = JobDetailsStatus.loaded;
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = JobDetailsStatus.error;
    }

    notifyListeners();
  }

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  Future<void> pickResume() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        _selectedResumeFile = io.File(file.path!);
        _resumeName = file.name;
        notifyListeners();

        // Upload the file
        await _uploadResume();
      }
    } catch (e) {
      debugPrint('Error picking resume: $e');
    }
  }

  Future<void> _uploadResume() async {
    if (_selectedResumeFile == null) return;
    try {
      String? url = await CloudinaryService.uploadDoc(
        file: _selectedResumeFile!,
        folder: 'resumes',
      );
      _resumeUrl = url ?? "";
      notifyListeners();
    } catch (e) {
      debugPrint('Error uploading resume: $e');
    }
  }

  void removeResume() {
    _resumeUrl = '';
    _resumeName = '';
    _selectedResumeFile = null;
    notifyListeners();
  }

  Future<Result<ApplyJobEntity>> applyJob() async {
    if (_resumeUrl.isEmpty || _jobDetails == null) {
      return const Error(message: 'Please select a resume file');
    }

    try {
      _applyStatus = ApplyJobStatus.loading;
      _applyErrorMessage = '';
      notifyListeners();

      final result = await _applyJobUseCase(
        ApplyJobParams(jobId: _jobDetails!.id, resumeUrl: _resumeUrl),
      );

      return result.fold(
        (failure) {
          _applyErrorMessage = _getFailureMessage(failure);
          _applyStatus = ApplyJobStatus.error;
          notifyListeners();
          return Error(message: _applyErrorMessage);
        },
        (applyResult) {
          _applyStatus = ApplyJobStatus.success;
          // Update job details to reflect applied status
          if (_jobDetails != null) {
            _jobDetails = _jobDetails!.copyWith(isApplied: true);
          }
          notifyListeners();
          return Success(applyResult);
        },
      );
    } catch (e) {
      _applyErrorMessage = 'An unexpected error occurred: $e';
      _applyStatus = ApplyJobStatus.error;
      notifyListeners();
      return Error(message: _applyErrorMessage);
    }
  }

  Future<Result<bool>> saveJob() async {
    if (_jobDetails == null) {
      return const Error(message: 'No job details available');
    }

    try {
      final result = await _saveJobUseCase(
        SaveJobParams(jobId: _jobDetails!.id),
      );

      return result.fold(
        (failure) => Error(message: _getFailureMessage(failure)),
        (success) {
          if (success && _jobDetails != null) {
            _jobDetails = _jobDetails!.copyWith(isSaved: !_jobDetails!.isSaved);
            notifyListeners();
          }
          return Success(success);
        },
      );
    } catch (e) {
      return Error(message: 'An unexpected error occurred: $e');
    }
  }

  void reset() {
    _status = JobDetailsStatus.initial;
    _applyStatus = ApplyJobStatus.initial;
    _jobDetails = null;
    _errorMessage = '';
    _applyErrorMessage = '';
    _tabIndex = 0;
    _resumeUrl = '';
    _resumeName = '';
    _selectedResumeFile = null;
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
