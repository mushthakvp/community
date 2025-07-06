import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../domain/entities/job_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/apply_job_usecase.dart';
import '../../domain/usecases/get_jobs_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/like_post_usecase.dart';
import '../../domain/usecases/save_job_usecase.dart';
import '../../domain/usecases/search_jobs_usecase.dart';

enum VJobHomeStatus { initial, loading, loaded, error, refreshing }

class VJobHomeProvider extends ChangeNotifier {
  final GetJobsUseCase _getJobsUseCase;
  final SaveJobUseCase _saveJobUseCase;
  final ApplyJobUseCase _applyJobUseCase;
  final SearchJobsUseCase _searchJobsUseCase;
  final GetPostsUseCase _getPostsUseCase;
  final LikePostUseCase _likePostUseCase;

  VJobHomeProvider({
    required GetJobsUseCase getJobsUseCase,
    required SaveJobUseCase saveJobUseCase,
    required ApplyJobUseCase applyJobUseCase,
    required SearchJobsUseCase searchJobsUseCase,
    required GetPostsUseCase getPostsUseCase,
    required LikePostUseCase likePostUseCase,
  }) : _getJobsUseCase = getJobsUseCase,
       _saveJobUseCase = saveJobUseCase,
       _applyJobUseCase = applyJobUseCase,
       _searchJobsUseCase = searchJobsUseCase,
       _getPostsUseCase = getPostsUseCase,
       _likePostUseCase = likePostUseCase;

  // State
  VJobHomeStatus _status = VJobHomeStatus.initial;
  List<JobEntity> _jobs = [];
  List<PostEntity> _posts = [];
  String? _errorMessage;
  bool _isPostJob = false;

  // Pagination
  int _currentPage = 1;
  bool _hasMoreJobs = true;
  bool _isLoadingMore = false;

  // Search
  final searchController = TextEditingController();
  Timer? _searchDebounce;
  String _searchQuery = '';

  // Getters
  VJobHomeStatus get status => _status;
  List<JobEntity> get jobs => _jobs;
  List<PostEntity> get posts => _posts;
  String? get errorMessage => _errorMessage;
  bool get isPostJob => _isPostJob;
  bool get isLoading => _status == VJobHomeStatus.loading;
  bool get hasError => _status == VJobHomeStatus.error;
  bool get isEmpty => _jobs.isEmpty && _posts.isEmpty;
  bool get hasMoreJobs => _hasMoreJobs;
  bool get isLoadingMore => _isLoadingMore;
  String get searchQuery => _searchQuery;

  @override
  void dispose() {
    searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  // Public Methods
  Future<void> initializeHome() async {
    await loadJobs();
    await loadPosts();
  }

  Future<void> loadJobs({bool forceRefresh = false}) async {
    if (_status == VJobHomeStatus.loading) return;

    if (forceRefresh) {
      _currentPage = 1;
      _hasMoreJobs = true;
      _jobs.clear();
    }

    _setLoading();
    await _fetchJobs();
  }

  Future<void> loadMoreJobs() async {
    if (_isLoadingMore || !_hasMoreJobs) return;

    _isLoadingMore = true;
    notifyListeners();

    final result = await _getJobsUseCase(
      page: _currentPage + 1,
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
    );

    result.fold((failure) => _showError(failure.userFriendlyMessage), (
      newJobs,
    ) {
      if (newJobs.isNotEmpty) {
        _jobs.addAll(newJobs);
        _currentPage++;
      } else {
        _hasMoreJobs = false;
      }
    });

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> loadPosts() async {
    try {
      final result = await _getPostsUseCase();
      result.fold(
        (failure) => dev.log('Failed to load posts: ${failure.message}'),
        (posts) {
          _posts = posts;
          notifyListeners();
        },
      );
    } catch (e) {
      dev.log('Error loading posts: $e');
    }
  }

  void togglePostJob() {
    _isPostJob = !_isPostJob;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query;
      _performSearch();
    });
  }

  Future<void> saveJob(String jobId, int index) async {
    try {
      final result = await _saveJobUseCase(jobId);
      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        success,
      ) {
        if (success && index < _jobs.length) {
          final currentJob = _jobs[index];
          _jobs[index] = currentJob.copyWith(
            isSaved: !(currentJob.isSaved ?? false),
          );
          notifyListeners();
        }
      });
    } catch (e) {
      dev.log('Error saving job: $e');
      _showError('Failed to save job. Please try again.');
    }
  }

  Future<void> applyJob({required String jobId, required String resume}) async {
    try {
      final result = await _applyJobUseCase(jobId: jobId, resume: resume);
      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        success,
      ) {
        if (success) {
          _showSuccess('Application submitted successfully!');
        }
      });
    } catch (e) {
      dev.log('Error applying for job: $e');
      _showError('Failed to apply for job. Please try again.');
    }
  }

  Future<void> likePost(String postId, int index) async {
    try {
      final result = await _likePostUseCase(postId);
      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        success,
      ) {
        if (success && index < _posts.length) {
          final currentPost = _posts[index];
          final newLikesCount = currentPost.isLiked
              ? currentPost.likesCount - 1
              : currentPost.likesCount + 1;

          _posts[index] = currentPost.copyWith(
            isLiked: !currentPost.isLiked,
            likesCount: newLikesCount,
          );
          notifyListeners();
        }
      });
    } catch (e) {
      dev.log('Error liking post: $e');
      _showError('Failed to like post. Please try again.');
    }
  }

  // Private Methods
  Future<void> _fetchJobs() async {
    try {
      final result = await _getJobsUseCase(
        page: _currentPage,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      result.fold((failure) => _setError(failure.userFriendlyMessage), (jobs) {
        _jobs = jobs;
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error fetching jobs: $e');
      _setError('Failed to load jobs. Please try again.');
    }
  }

  Future<void> _performSearch() async {
    _currentPage = 1;
    _hasMoreJobs = true;
    _jobs.clear();
    await _fetchJobs();
  }

  void _setLoading() {
    _status = VJobHomeStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = VJobHomeStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = VJobHomeStatus.error;
    _errorMessage = message;
    dev.log('VJob home provider error: $message');
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
    // You can implement success message handling here
    dev.log('Success: $message');
  }
}
