import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/vjob_repository.dart';

enum VJobStatus { initial, loading, loaded, error, refreshing }

class VJobProvider extends ChangeNotifier {
  final VJobRepository _repository;

  VJobProvider({required VJobRepository repository}) : _repository = repository;

  // State
  VJobStatus _status = VJobStatus.initial;
  List<JobEntity> _jobs = [];
  List<JobEntity> _filteredJobs = [];
  List<JobEntity> _savedJobs = [];
  String? _errorMessage;

  // Pagination
  int _currentPage = 1;
  bool _hasMoreData = true;
  static const int _pageSize = 10;

  // Filters
  String _searchQuery = '';
  String _selectedLocation = '';
  String _selectedWorkStyle = '';

  // Controllers
  final searchController = TextEditingController();
  Timer? _searchDebounce;

  // Getters
  VJobStatus get status => _status;
  List<JobEntity> get jobs => _filteredJobs;
  List<JobEntity> get savedJobs => _savedJobs;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedLocation => _selectedLocation;
  String get selectedWorkStyle => _selectedWorkStyle;
  bool get isLoading => _status == VJobStatus.loading;
  bool get hasError => _status == VJobStatus.error;
  bool get isEmpty => _filteredJobs.isEmpty;
  bool get hasData => _filteredJobs.isNotEmpty;
  bool get hasMoreData => _hasMoreData;
  int get currentPage => _currentPage;

  @override
  void dispose() {
    searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  // Public Methods
  Future<void> initializeJobs() async {
    await loadJobs();
  }

  Future<void> loadJobs({bool forceRefresh = false}) async {
    if (_status == VJobStatus.loading) return;

    if (forceRefresh) {
      _currentPage = 1;
      _jobs.clear();
      _hasMoreData = true;
    }

    _setLoading();
    await _fetchJobs();
  }

  Future<void> loadMoreJobs() async {
    if (!_hasMoreData || _status == VJobStatus.loading) return;

    _currentPage++;
    await _fetchJobs(isLoadMore: true);
  }

  Future<void> refreshJobs() async {
    _setRefreshing();
    _currentPage = 1;
    _jobs.clear();
    _hasMoreData = true;
    await _fetchJobs();
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void selectLocation(String location) {
    if (_selectedLocation != location) {
      _selectedLocation = location;
      _applyFilters();
    }
  }

  void selectWorkStyle(String workStyle) {
    if (_selectedWorkStyle != workStyle) {
      _selectedWorkStyle = workStyle;
      _applyFilters();
    }
  }

  void clearFilters() {
    _selectedLocation = '';
    _selectedWorkStyle = '';
    _searchQuery = '';
    searchController.clear();
    _applyFilters();
  }

  Future<void> saveJob(String jobId) async {
    try {
      final result = await _repository.saveJob(jobId);
      result.fold((failure) => _showError(failure.message), (success) {
        if (success) {
          _updateJobInList(jobId, (job) => job.copyWith(isSaved: !job.isSaved));
          _showSuccess(
            'Job ${_getJobById(jobId)?.isSaved == true ? 'unsaved' : 'saved'} successfully',
          );
        }
      });
    } catch (e) {
      dev.log('Error saving job: $e');
      _showError('Failed to save job. Please try again.');
    }
  }

  Future<void> applyForJob(String jobId, String? resumeUrl) async {
    try {
      final result = await _repository.applyForJob(jobId, resumeUrl);
      result.fold((failure) => _showError(failure.message), (success) async {
        if (success) {
          _showSuccess('Application submitted successfully');
          await refreshJobs();
        }
      });
    } catch (e) {
      dev.log('Error applying for job: $e');
      _showError('Failed to apply for job. Please try again.');
    }
  }

  Future<void> loadSavedJobs() async {
    try {
      final result = await _repository.getSavedJobs();
      result.fold(
        (failure) => dev.log('Failed to load saved jobs: ${failure.message}'),
        (jobs) {
          _savedJobs = jobs;
          notifyListeners();
        },
      );
    } catch (e) {
      dev.log('Error loading saved jobs: $e');
    }
  }

  // Private Methods
  Future<void> _fetchJobs({bool isLoadMore = false}) async {
    try {
      final result = await _repository.getJobs(
        page: _currentPage,
        limit: _pageSize,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        location: _selectedLocation.isNotEmpty ? _selectedLocation : null,
        workStyle: _selectedWorkStyle.isNotEmpty ? _selectedWorkStyle : null,
      );

      result.fold((failure) => _setError(_getErrorMessage(failure)), (jobs) {
        if (isLoadMore) {
          _jobs.addAll(jobs);
        } else {
          _jobs = jobs;
        }

        _hasMoreData = jobs.length >= _pageSize;
        _applyFilters();
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error fetching jobs: $e');
      _setError('Failed to load jobs. Please try again.');
    }
  }

  void _setLoading() {
    _status = VJobStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setRefreshing() {
    _status = VJobStatus.refreshing;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = VJobStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = VJobStatus.error;
    _errorMessage = message;
    dev.log('VJob provider error: $message');
    notifyListeners();
  }

  void _showError(String message) {
    _errorMessage = message;
    notifyListeners();

    // Clear error after some time
    Timer(const Duration(seconds: 3), () {
      if (_errorMessage == message) {
        _errorMessage = null;
        notifyListeners();
      }
    });
  }

  void _showSuccess(String message) {
    // You can implement success message display here
    dev.log('Success: $message');
  }

  void _applyFilters() {
    _filteredJobs = _jobs.where((job) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final title = job.title.toLowerCase();
        final company = job.company.name.toLowerCase();
        final location = job.location.toLowerCase();

        if (!title.contains(searchLower) &&
            !company.contains(searchLower) &&
            !location.contains(searchLower)) {
          return false;
        }
      }

      // Location filter
      if (_selectedLocation.isNotEmpty &&
          !job.location.toLowerCase().contains(
            _selectedLocation.toLowerCase(),
          )) {
        return false;
      }

      // Work style filter
      if (_selectedWorkStyle.isNotEmpty &&
          job.workStyle != _selectedWorkStyle) {
        return false;
      }

      return true;
    }).toList();

    // Sort jobs (newest first, then by relevance)
    _filteredJobs.sort((a, b) {
      final dateComparison = b.createdAt.compareTo(a.createdAt);
      if (dateComparison != 0) return dateComparison;
      return b.totalApplications.compareTo(a.totalApplications);
    });

    notifyListeners();
  }

  void _updateJobInList(String jobId, JobEntity Function(JobEntity) updater) {
    final index = _jobs.indexWhere((job) => job.id == jobId);
    if (index != -1) {
      _jobs[index] = updater(_jobs[index]);
      _applyFilters();
    }
  }

  JobEntity? _getJobById(String jobId) {
    try {
      return _jobs.firstWhere((job) => job.id == jobId);
    } catch (e) {
      return null;
    }
  }

  String _getErrorMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }

  // Debug methods
  void debugPrintJobs() {
    dev.log('Total jobs: ${_jobs.length}');
    dev.log('Filtered jobs: ${_filteredJobs.length}');
    dev.log('Current page: $_currentPage');
    dev.log('Has more data: $_hasMoreData');
  }
}
