import 'package:flutter/foundation.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/recently_viewed_ad_entity.dart';
import '../../domain/usecases/clear_recently_viewed_cache_usecase.dart';
import '../../domain/usecases/clear_recently_viewed_usecase.dart';
import '../../domain/usecases/get_recently_viewed_ads_usecase.dart';
import '../../domain/usecases/toggle_recently_viewed_favorite_usecase.dart';

enum RecentlyViewedStatus { initial, loading, success, error }

class RecentlyViewedProvider with ChangeNotifier {
  final GetRecentlyViewedAdsUseCase getRecentlyViewedAdsUseCase;
  final ToggleRecentlyViewedFavoriteUseCase toggleFavoriteUseCase;
  final ClearRecentlyViewedUseCase clearRecentlyViewedUseCase;
  final ClearRecentlyViewedCacheUseCase clearCacheUseCase;

  RecentlyViewedProvider({
    required this.getRecentlyViewedAdsUseCase,
    required this.toggleFavoriteUseCase,
    required this.clearRecentlyViewedUseCase,
    required this.clearCacheUseCase,
  });

  // State management
  RecentlyViewedStatus _status = RecentlyViewedStatus.initial;
  List<RecentlyViewedAdEntity> _recentlyViewedAds = [];
  String? _errorMessage;
  String? _toggleFavoriteId;
  bool _isClearing = false;

  // Getters
  RecentlyViewedStatus get status => _status;
  List<RecentlyViewedAdEntity> get recentlyViewedAds => _recentlyViewedAds;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == RecentlyViewedStatus.loading;
  bool get hasError => _status == RecentlyViewedStatus.error;
  bool get isEmpty =>
      _recentlyViewedAds.isEmpty && _status == RecentlyViewedStatus.success;
  int get recentlyViewedCount => _recentlyViewedAds.length;
  bool get isToggling => _toggleFavoriteId != null;
  bool get isClearing => _isClearing;

  bool isAdToggling(String adId) => _toggleFavoriteId == adId;

  // Methods
  Future<void> loadRecentlyViewedAds({bool showLoading = true}) async {
    if (showLoading) {
      _status = RecentlyViewedStatus.loading;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await getRecentlyViewedAdsUseCase(NoParams());

    result.fold(
      (failure) {
        _status = RecentlyViewedStatus.error;
        _errorMessage = _getFailureMessage(failure);
        debugPrint('Error loading recently viewed ads: $_errorMessage');
      },
      (ads) {
        _status = RecentlyViewedStatus.success;
        _recentlyViewedAds = ads;
        _errorMessage = null;
      },
    );

    notifyListeners();
  }

  Future<bool> toggleFavorite(String adId) async {
    if (_toggleFavoriteId != null) return false; // Prevent multiple requests

    _toggleFavoriteId = adId;
    notifyListeners();

    final result = await toggleFavoriteUseCase(
      ToggleRecentlyViewedFavoriteParams(adId: adId),
    );

    _toggleFavoriteId = null;

    return result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Update the ad's favorite status in the list
        final adIndex = _recentlyViewedAds.indexWhere((ad) => ad.id == adId);
        if (adIndex != -1) {
          final updatedAd = RecentlyViewedAdEntity(
            id: _recentlyViewedAds[adIndex].id,
            title: _recentlyViewedAds[adIndex].title,
            price: _recentlyViewedAds[adIndex].price,
            currencyCode: _recentlyViewedAds[adIndex].currencyCode,
            district: _recentlyViewedAds[adIndex].district,
            brand: _recentlyViewedAds[adIndex].brand,
            model: _recentlyViewedAds[adIndex].model,
            images: _recentlyViewedAds[adIndex].images,
            isSaved: !_recentlyViewedAds[adIndex].isSaved,
            viewedAt: _recentlyViewedAds[adIndex].viewedAt,
            year: _recentlyViewedAds[adIndex].year,
            kilometers: _recentlyViewedAds[adIndex].kilometers,
            address: _recentlyViewedAds[adIndex].address,
            latitude: _recentlyViewedAds[adIndex].latitude,
            longitude: _recentlyViewedAds[adIndex].longitude,
            shareLink: _recentlyViewedAds[adIndex].shareLink,
          );
          _recentlyViewedAds[adIndex] = updatedAd;
        }
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> clearAllRecentlyViewed() async {
    if (_isClearing) return false;

    _isClearing = true;
    notifyListeners();

    final result = await clearRecentlyViewedUseCase(NoParams());

    _isClearing = false;

    return result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        _recentlyViewedAds.clear();
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> refreshRecentlyViewedAds() async {
    await clearCache();
    await loadRecentlyViewedAds();
  }

  Future<void> clearCache() async {
    await clearCacheUseCase(NoParams());
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (NetworkFailure):
        return 'No internet connection. Please check your network.';
      case const (ServerFailure):
        return failure.message.isNotEmpty
            ? failure.message
            : 'Server error. Please try again later.';
      case const (CacheFailure):
        return 'Cache error. Please refresh the app.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
