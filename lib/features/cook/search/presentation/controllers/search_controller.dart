import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/search_result.dart';
import '../../domain/usecases/search_challenges_usecase.dart';

class CookSearchController extends GetxController {
  final SearchChallengesUseCase searchChallengesUseCase;

  CookSearchController({required this.searchChallengesUseCase});

  final _isLoading = false.obs;
  final _isError = false.obs;
  final _errorMessage = ''.obs;
  final _searchResults = Rx<SearchResult?>(null);
  final _searchQuery = ''.obs;
  final _recentSearches = <String>[].obs;
  final _showSuggestions = false.obs;

  final TextEditingController searchTextController = TextEditingController();

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  String get errorMessage => _errorMessage.value;
  SearchResult? get searchResults => _searchResults.value;
  String get searchQuery => _searchQuery.value;
  List<String> get recentSearches => _recentSearches;
  bool get showSuggestions => _showSuggestions.value;

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> _loadRecentSearches() async {
    // This would typically call a use case to get recent searches
    // For now, we'll use an empty list
    _recentSearches.value = [];
  }

  Future<void> searchChallenges(String query) async {
    if (query.trim().isEmpty) {
      _searchResults.value = null;
      _searchQuery.value = '';
      return;
    }

    try {
      _isLoading.value = true;
      _isError.value = false;
      _errorMessage.value = '';
      _searchQuery.value = query;
      _showSuggestions.value = false;

      final params = SearchChallengesParams(query: query);
      final result = await searchChallengesUseCase(params);

      result.fold(
        (failure) {
          _isError.value = true;
          _errorMessage.value = failure.message;
        },
        (data) {
          _searchResults.value = data;
          // Add to recent searches if not already there
          if (!_recentSearches.contains(query)) {
            _recentSearches.insert(0, query);
            if (_recentSearches.length > 10) {
              _recentSearches.removeRange(10, _recentSearches.length);
            }
          }
        },
      );
    } catch (e) {
      _isError.value = true;
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void clearSearch() {
    _searchResults.value = null;
    _searchQuery.value = '';
    _isError.value = false;
    _errorMessage.value = '';
    searchTextController.clear();
  }

  void selectRecentSearch(String query) {
    searchTextController.text = query;
    searchChallenges(query);
  }

  void showSearchSuggestions() {
    _showSuggestions.value = true;
  }

  void hideSuggestions() {
    _showSuggestions.value = false;
  }

  void clearRecentSearches() {
    _recentSearches.clear();
  }
}
