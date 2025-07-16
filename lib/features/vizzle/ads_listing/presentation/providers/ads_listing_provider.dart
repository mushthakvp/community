import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/ad_entity.dart';
import '../../domain/entities/ads_filter_entity.dart';
import '../../domain/entities/ads_response_entity.dart';
import '../../domain/usecases/get_ads_usecase.dart';
import '../../domain/usecases/get_filter_options_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

enum AdsListingStatus { initial, loading, loaded, error, loadingMore }

class AdsListingProvider extends ChangeNotifier {
  final GetAdsUseCase _getAdsUseCase;
  final GetFilterOptionsUseCase _getFilterOptionsUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  AdsListingProvider({
    required GetAdsUseCase getAdsUseCase,
    required GetFilterOptionsUseCase getFilterOptionsUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
  }) : _getAdsUseCase = getAdsUseCase,
       _getFilterOptionsUseCase = getFilterOptionsUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase;

  // State
  AdsListingStatus _status = AdsListingStatus.initial;
  List<AdEntity> _ads = [];
  AdsFilterEntity _currentFilter = const AdsFilterEntity();
  String? _errorMessage;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;
  int _totalCount = 0;
  static const int _pageSize = 20;

  // Filter options
  Map<String, List<String>> _filterOptions = {};

  // Debouncer for search
  Timer? _searchDebouncer;
  static const Duration _searchDelay = Duration(milliseconds: 500);

  // Cache for performance
  final Map<String, List<AdEntity>> _adsCache = {};
  DateTime? _lastFetchTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // Getters
  AdsListingStatus get status => _status;
  List<AdEntity> get ads => _ads;
  AdsFilterEntity get currentFilter => _currentFilter;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasNextPage => _hasNextPage;
  bool get hasPreviousPage => _hasPreviousPage;
  int get totalCount => _totalCount;
  Map<String, List<String>> get filterOptions => _filterOptions;

  // Status helpers
  bool get isLoading => _status == AdsListingStatus.loading;
  bool get isLoadingMore => _status == AdsListingStatus.loadingMore;
  bool get hasError => _status == AdsListingStatus.error;
  bool get hasData => _ads.isNotEmpty;
  bool get isEmpty => _ads.isEmpty && _status == AdsListingStatus.loaded;
  bool get isInitial => _status == AdsListingStatus.initial;

  // Public methods
  Future<void> loadAds({
    AdsFilterEntity? filter,
    bool forceRefresh = false,
  }) async {
    if (_status == AdsListingStatus.loading) return;

    final newFilter = filter ?? _currentFilter;
    final cacheKey = _generateCacheKey(1, newFilter);

    // Check cache first if not forcing refresh
    if (!forceRefresh && _shouldUseCachedData(cacheKey)) {
      _ads = _adsCache[cacheKey]!;
      _status = AdsListingStatus.loaded;
      notifyListeners();
      return;
    }

    _setLoading();
    _currentFilter = newFilter;
    _currentPage = 1;

    await _fetchAds(page: 1);
  }

  Future<void> loadMoreAds() async {
    if (_status == AdsListingStatus.loadingMore ||
        _status == AdsListingStatus.loading ||
        !_hasNextPage) {
      return;
    }

    _status = AdsListingStatus.loadingMore;
    notifyListeners();

    await _fetchAds(page: _currentPage + 1, isLoadingMore: true);
  }

  Future<void> refreshAds() async {
    await loadAds(forceRefresh: true);
  }

  Future<void> searchAds(String keyword) async {
    _searchDebouncer?.cancel();
    _searchDebouncer = Timer(_searchDelay, () {
      final newFilter = _currentFilter.copyWith(keyword: keyword);
      loadAds(filter: newFilter);
    });
  }

  void updateFilter(AdsFilterEntity filter) {
    _currentFilter = filter;
    loadAds(filter: filter);
  }

  void clearFilter() {
    _currentFilter = const AdsFilterEntity();
    loadAds(filter: _currentFilter);
  }

  Future<void> toggleAdFavorite(String adId) async {
    try {
      final result = await _toggleFavoriteUseCase(adId);

      result.fold(
        (failure) {
          dev.log('Error toggling favorite: ${failure.message}');
          _showErrorMessage('Failed to update favorite');
        },
        (success) {
          if (success) {
            // Update the ad in the current list
            final adIndex = _ads.indexWhere((ad) => ad.id == adId);
            if (adIndex != -1) {
              _ads[adIndex] = _ads[adIndex].copyWith(
                isSaved: !_ads[adIndex].isSaved,
              );
              notifyListeners();
            }
          }
        },
      );
    } catch (e) {
      dev.log('Error toggling favorite: $e');
      _showErrorMessage('Failed to update favorite');
    }
  }

  Future<void> loadFilterOptions() async {
    try {
      final result = await _getFilterOptionsUseCase(NoParams());

      result.fold(
        (failure) {
          dev.log('Error loading filter options: ${failure.message}');
        },
        (options) {
          _filterOptions = options;
          notifyListeners();
        },
      );
    } catch (e) {
      dev.log('Error loading filter options: $e');
    }
  }

  // Private methods
  Future<void> _fetchAds({
    required int page,
    bool isLoadingMore = false,
  }) async {
    try {
      final params = GetAdsParams(
        page: page,
        limit: _pageSize,
        filter: _currentFilter,
      );

      final result = await _getAdsUseCase(params);

      result.fold((failure) => _setError(_getErrorMessage(failure)), (
        adsResponse,
      ) {
        if (isLoadingMore) {
          _ads.addAll(adsResponse.ads);
        } else {
          _ads = List.from(adsResponse.ads);

          // Cache the first page
          final cacheKey = _generateCacheKey(1, _currentFilter);
          _adsCache[cacheKey] = List.from(_ads);
          _lastFetchTime = DateTime.now();
        }

        _updatePaginationInfo(adsResponse);
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error fetching ads: $e');
      _setError('Failed to load ads. Please try again.');
    }
  }

  void _updatePaginationInfo(AdsResponseEntity adsResponse) {
    _currentPage = adsResponse.currentPage;
    _totalPages = adsResponse.totalPages;
    _hasNextPage = adsResponse.hasNextPage;
    _hasPreviousPage = adsResponse.hasPreviousPage;
    _totalCount = adsResponse.totalCount;
  }

  void _setLoading() {
    _status = AdsListingStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = AdsListingStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AdsListingStatus.error;
    _errorMessage = message;
    dev.log('Ads listing provider error: $message');
    notifyListeners();
  }

  void _showErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();

    // Clear error message after some time
    Timer(const Duration(seconds: 3), () {
      if (_errorMessage == message) {
        _errorMessage = null;
        notifyListeners();
      }
    });
  }

  String _getErrorMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }

  String _generateCacheKey(int page, AdsFilterEntity filter) {
    return 'ads_page_${page}_filter_${filter.hashCode}';
  }

  bool _shouldUseCachedData(String cacheKey) {
    return _adsCache.containsKey(cacheKey) &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheValidDuration;
  }

  @override
  void dispose() {
    _searchDebouncer?.cancel();
    super.dispose();
  }
}
