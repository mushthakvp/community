import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/utils/result.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/usecases/search_ads_usecase.dart';

class SearchProvider extends ChangeNotifier {
  final SearchAdsUseCase searchAdsUseCase;

  SearchProvider({required this.searchAdsUseCase});

  Result<SearchResult>? _searchResult;
  bool _isLoading = false;
  Timer? _debounceTimer;

  Result<SearchResult>? get searchResult => _searchResult;
  bool get isLoading => _isLoading;
  SearchResult? get searchData => _searchResult?.data;

  Future<void> searchAds(String keyword) async {
    // Cancel previous timer
    _debounceTimer?.cancel();

    if (keyword.trim().isEmpty) {
      _searchResult = null;
      notifyListeners();
      return;
    }

    // Debounce search
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      _isLoading = true;
      notifyListeners();

      final result = await searchAdsUseCase(keyword.trim());

      result.fold(
        (failure) => _searchResult = Error(message: failure.message),
        (searchResult) => _searchResult = Success(searchResult),
      );

      _isLoading = false;
      notifyListeners();
    });
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _searchResult = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
