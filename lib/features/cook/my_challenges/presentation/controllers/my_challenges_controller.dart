import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/my_challenge.dart';
import '../../domain/usecases/get_my_challenges_usecase.dart';

class MyChallengesController extends GetxController {
  final GetMyChallengesUseCase getMyChallengesUseCase;

  MyChallengesController({required this.getMyChallengesUseCase});

  // State - Using RxList for proper reactivity
  final RxList<MyChallenge> _activeChallenges = <MyChallenge>[].obs;
  final RxList<MyChallenge> _completedChallenges = <MyChallenge>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isLoadingMore = false.obs;

  // Pagination
  final RxInt _activePage = 1.obs;
  final RxInt _completedPage = 1.obs;
  final RxBool _hasMoreActiveData = true.obs;
  final RxBool _hasMoreCompletedData = true.obs;

  // Getters
  List<MyChallenge> get activeChallenges => _activeChallenges;
  List<MyChallenge> get completedChallenges => _completedChallenges;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMoreActiveData => _hasMoreActiveData.value;
  bool get hasMoreCompletedData => _hasMoreCompletedData.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint('MyChallengesController initialized');
  }

  @override
  void onClose() {
    debugPrint('MyChallengesController disposed');
    super.onClose();
  }

  Future<void> loadChallenges({required String status}) async {
    try {
      debugPrint('Loading challenges for status: $status');
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';

      final page = status == 'active'
          ? _activePage.value
          : _completedPage.value;

      final params = GetMyChallengesParams(status: status, page: page);

      final result = await getMyChallengesUseCase(params);

      result.fold(
        (failure) {
          debugPrint('Error loading challenges: ${failure.message}');
          _hasError.value = true;
          _errorMessage.value = failure.message;
        },
        (challenges) {
          debugPrint('Loaded ${challenges.length} challenges for $status');
          if (status == 'active') {
            _activeChallenges.value = challenges;
            _hasMoreActiveData.value = challenges.length >= 10;
          } else {
            _completedChallenges.value = challenges;
            _hasMoreCompletedData.value = challenges.length >= 10;
          }
          // Force UI update
          update();
        },
      );
    } catch (e) {
      debugPrint('Exception loading challenges: $e');
      _hasError.value = true;
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadMoreChallenges({required String status}) async {
    final hasMoreData = status == 'active'
        ? _hasMoreActiveData.value
        : _hasMoreCompletedData.value;

    if (_isLoadingMore.value || !hasMoreData) return;

    try {
      debugPrint('Loading more challenges for status: $status');
      _isLoadingMore.value = true;

      if (status == 'active') {
        _activePage.value++;
      } else {
        _completedPage.value++;
      }

      final page = status == 'active'
          ? _activePage.value
          : _completedPage.value;

      final params = GetMyChallengesParams(status: status, page: page);

      final result = await getMyChallengesUseCase(params);

      result.fold(
        (failure) {
          debugPrint('Error loading more challenges: ${failure.message}');
          // Revert page increment on error
          if (status == 'active') {
            _activePage.value--;
          } else {
            _completedPage.value--;
          }
        },
        (newChallenges) {
          debugPrint(
            'Loaded ${newChallenges.length} more challenges for $status',
          );
          if (status == 'active') {
            _activeChallenges.addAll(newChallenges);
            _hasMoreActiveData.value = newChallenges.length >= 10;
          } else {
            _completedChallenges.addAll(newChallenges);
            _hasMoreCompletedData.value = newChallenges.length >= 10;
          }
          // Force UI update
          update();
        },
      );
    } catch (e) {
      debugPrint('Exception loading more challenges: $e');
      // Revert page increment on error
      if (status == 'active') {
        _activePage.value--;
      } else {
        _completedPage.value--;
      }
    } finally {
      _isLoadingMore.value = false;
    }
  }

  void resetPagination(String status) {
    debugPrint('Resetting pagination for status: $status');
    if (status == 'active') {
      _activePage.value = 1;
      _activeChallenges.clear();
      _hasMoreActiveData.value = true;
    } else {
      _completedPage.value = 1;
      _completedChallenges.clear();
      _hasMoreCompletedData.value = true;
    }
    loadChallenges(status: status);
  }

  void refreshChallenges(String status) {
    debugPrint('Refreshing challenges for status: $status');
    resetPagination(status);
  }

  // Force UI update method
  void forceUpdate() {
    update();
  }

  // Clear all data
  void clearAllData() {
    _activeChallenges.clear();
    _completedChallenges.clear();
    _hasError.value = false;
    _errorMessage.value = '';
    _isLoading.value = false;
    _isLoadingMore.value = false;
    _activePage.value = 1;
    _completedPage.value = 1;
    _hasMoreActiveData.value = true;
    _hasMoreCompletedData.value = true;
    update();
  }
}
