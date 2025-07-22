import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/challenge.dart';
import '../../domain/entities/cooking_home.dart';
import '../../domain/usecases/get_cooking_home_usecase.dart';
import '../../domain/usecases/search_challenges_usecase.dart';

class CookHomeController extends GetxController {
  final GetCookingHomeUseCase getCookingHomeUseCase;
  final SearchChallengesUseCase searchChallengesUseCase;

  CookHomeController({
    required this.getCookingHomeUseCase,
    required this.searchChallengesUseCase,
  });

  // Observables
  final _isLoading = true.obs;
  final _isError = false.obs;
  final _errorMessage = ''.obs;
  final _isSearching = false.obs;
  final _noSearchResults = false.obs;
  final _searchQuery = ''.obs;
  final _currentIndex = 0.obs;
  final _upcomingPage = 1.obs;
  final _isLoadingMore = false.obs;
  final _hasMoreUpcomingChallenges = true.obs;

  // Data
  final Rx<CookingHome?> _cookingHome = Rx<CookingHome?>(null);

  // Search debouncer
  Timer? _searchDebouncer;
  final TextEditingController searchController = TextEditingController();

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  String get errorMessage => _errorMessage.value;
  bool get isSearching => _isSearching.value;
  bool get noSearchResults => _noSearchResults.value;
  String get searchQuery => _searchQuery.value;
  int get currentIndex => _currentIndex.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMoreUpcomingChallenges => _hasMoreUpcomingChallenges.value;
  CookingHome? get cookingHome => _cookingHome.value;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    _searchDebouncer?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    _searchQuery.value = searchController.text;

    if (searchController.text.isEmpty) {
      clearSearch();
    } else {
      _isSearching.value = true;
      _searchDebouncer?.cancel();
      _searchDebouncer = Timer(const Duration(milliseconds: 500), () {
        _performSearch(searchController.text);
      });
    }
  }

  Future<void> initializeData() async {
    await _loadCookingHome();
  }

  Future<void> _loadCookingHome({
    String? search,
    bool isInitialLoad = true,
  }) async {
    try {
      if (isInitialLoad) {
        if (search != null && search.isNotEmpty) {
          _isSearching.value = true;
        } else {
          _isLoading.value = true;
          _isSearching.value = false;
        }
        _isError.value = false;
        _errorMessage.value = '';
        _upcomingPage.value = 1;
      } else {
        _isLoadingMore.value = true;
      }

      final params = GetCookingHomeParams(
        search: search,
        upcomingPage: _upcomingPage.value,
      );

      final result = search != null && search.isNotEmpty
          ? await searchChallengesUseCase(params)
          : await getCookingHomeUseCase(params);

      result.fold(
        (failure) {
          _isError.value = true;
          _errorMessage.value = failure.message;
        },
        (data) {
          if (isInitialLoad) {
            _cookingHome.value = data;
            _checkSearchResults(search, data);
          } else {
            final currentData = _cookingHome.value;
            if (currentData != null) {
              final updatedUpcoming = List<Challenge>.from(
                currentData.upcomingChallenges,
              )..addAll(data.upcomingChallenges);
              _cookingHome.value = CookingHome(
                message: data.message,
                currentChallenges: currentData.currentChallenges,
                upcomingChallenges: updatedUpcoming,
                totalCurrentPages: data.totalCurrentPages,
                totalUpcomingPages: data.totalUpcomingPages,
                totalCurrentChallenges: data.totalCurrentChallenges,
                totalUpcomingChallenges: data.totalUpcomingChallenges,
              );
              _hasMoreUpcomingChallenges.value =
                  data.upcomingChallenges.isNotEmpty;
            }
          }
        },
      );
    } catch (e) {
      _isError.value = true;
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
      _isSearching.value = false;
      _isLoadingMore.value = false;
    }
  }

  void _checkSearchResults(String? search, CookingHome data) {
    if (search != null && search.isNotEmpty) {
      final hasResults =
          data.currentChallenges.isNotEmpty ||
          data.upcomingChallenges.isNotEmpty;
      _noSearchResults.value = !hasResults;
    } else {
      _noSearchResults.value = false;
    }
  }

  Future<void> _performSearch(String query) async {
    await _loadCookingHome(search: query);
  }

  void clearSearch() {
    if (_searchQuery.value.isNotEmpty) {
      _searchQuery.value = '';
      _isSearching.value = false;
      _noSearchResults.value = false;
      _upcomingPage.value = 1;
      _loadCookingHome();
    }
  }

  void clearChallenge() {
    searchController.clear();
    _searchQuery.value = '';
    _isSearching.value = false;
    _noSearchResults.value = false;
    _upcomingPage.value = 1;
    _loadCookingHome();
  }

  void onPageChanged(int index) {
    _currentIndex.value = index;
  }

  void loadMoreUpcomingChallenges() {
    if (!_isLoadingMore.value && _hasMoreUpcomingChallenges.value) {
      _upcomingPage.value++;
      _loadCookingHome(
        isInitialLoad: false,
        search: _searchQuery.value.isNotEmpty ? _searchQuery.value : null,
      );
    }
  }

  void retryLoading() {
    final search = _searchQuery.value.isNotEmpty ? _searchQuery.value : null;
    _loadCookingHome(search: search);
  }
}
