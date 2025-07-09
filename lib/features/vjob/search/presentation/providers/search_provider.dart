import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/recent_search_entity.dart';
import '../../domain/entities/search_job_entity.dart';
import '../../domain/usecases/get_recent_searches_usecase.dart';
import '../../domain/usecases/search_jobs_usecase.dart';

enum SearchStatus { initial, loading, loaded, error, loadingMore }

class SearchProvider extends ChangeNotifier {
  final GetRecentSearchesUseCase _getRecentSearchesUseCase;
  final SearchJobsUseCase _searchJobsUseCase;

  SearchProvider({
    required GetRecentSearchesUseCase getRecentSearchesUseCase,
    required SearchJobsUseCase searchJobsUseCase,
  }) : _getRecentSearchesUseCase = getRecentSearchesUseCase,
       _searchJobsUseCase = searchJobsUseCase;

  final TextEditingController searchController = TextEditingController();

  // State
  SearchStatus _status = SearchStatus.initial;
  List<RecentSearchEntity> _recentSearches = [];
  final List<SearchJobEntity> _searchResults = [];
  String _errorMessage = '';
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  String _currentQuery = '';
  Timer? _debounceTimer;

  // Getters
  SearchStatus get status => _status;
  List<RecentSearchEntity> get recentSearches => _recentSearches;
  List<SearchJobEntity> get searchResults => _searchResults;
  String get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  bool get isLoading => _status == SearchStatus.loading;
  bool get isLoadingMore => _status == SearchStatus.loadingMore;
  bool get isEmpty => _searchResults.isEmpty && _status == SearchStatus.loaded;
  bool get isSearching => _currentQuery.isNotEmpty;

  // Methods
  Future<void> getRecentSearches() async {
    try {
      final result = await _getRecentSearchesUseCase(NoParams());

      result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
        },
        (response) {
          _recentSearches = response.recentSearches;
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
    }

    notifyListeners();
  }

  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty && query != _currentQuery) {
        searchJobs(query.trim());
      } else if (query.trim().isEmpty) {
        clearSearch();
      }
    });
  }

  Future<void> searchJobs(String query, {bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        _currentPage = 1;
        _searchResults.clear();
        _hasMoreData = true;
        _currentQuery = query;
        _status = SearchStatus.loading;
        searchController.text = query;
      } else {
        if (!_hasMoreData || _status == SearchStatus.loadingMore) return;
        _status = SearchStatus.loadingMore;
      }

      notifyListeners();

      final result = await _searchJobsUseCase(
        SearchJobsParams(
          query: query,
          page: _currentPage,
          limit: _itemsPerPage,
        ),
      );

      result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = SearchStatus.error;
        },
        (response) {
          if (response.jobs.isEmpty) {
            _hasMoreData = false;
          } else {
            _searchResults.addAll(response.jobs);
            _currentPage++;
            if (response.jobs.length < _itemsPerPage ||
                _currentPage > response.totalPage) {
              _hasMoreData = false;
            }
          }
          _status = SearchStatus.loaded;
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = SearchStatus.error;
    }

    notifyListeners();
  }

  void clearSearch() {
    _currentQuery = '';
    _searchResults.clear();
    _hasMoreData = true;
    _currentPage = 1;
    _status = SearchStatus.initial;
    searchController.clear();
    notifyListeners();
  }

  void selectRecentSearch(String searchTerm) {
    searchJobs(searchTerm);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.dispose();
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
