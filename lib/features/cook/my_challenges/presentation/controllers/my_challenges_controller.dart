import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/my_challenge.dart';
import '../../domain/usecases/get_my_challenges_usecase.dart';

class MyChallengesController extends GetxController {
  final GetMyChallengesUseCase getMyChallengesUseCase;

  MyChallengesController({required this.getMyChallengesUseCase});

  // State
  final _activeChallenges = <MyChallenge>[].obs;
  final _completedChallenges = <MyChallenge>[].obs;
  final _isLoading = false.obs;
  final _hasError = false.obs;
  final _errorMessage = ''.obs;
  final _isLoadingMore = false.obs;

  // Pagination
  final _activePage = 1.obs;
  final _completedPage = 1.obs;
  final _hasMoreActiveData = true.obs;
  final _hasMoreCompletedData = true.obs;

  // Getters
  List<MyChallenge> get activeChallenges => _activeChallenges;
  List<MyChallenge> get completedChallenges => _completedChallenges;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMoreActiveData => _hasMoreActiveData.value;
  bool get hasMoreCompletedData => _hasMoreCompletedData.value;

  Future<void> loadChallenges({required String status}) async {
    try {
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
          _hasError.value = true;
          _errorMessage.value = failure.message;
        },
        (challenges) {
          if (status == 'active') {
            _activeChallenges.value = challenges;
            _hasMoreActiveData.value = challenges.length >= 10;
          } else {
            _completedChallenges.value = challenges;
            _hasMoreCompletedData.value = challenges.length >= 10;
          }
        },
      );
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = e.toString();
      debugPrint('Error loading challenges: $e');
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
          // Revert page increment on error
          if (status == 'active') {
            _activePage.value--;
          } else {
            _completedPage.value--;
          }
        },
        (newChallenges) {
          if (status == 'active') {
            _activeChallenges.addAll(newChallenges);
            _hasMoreActiveData.value = newChallenges.length >= 10;
          } else {
            _completedChallenges.addAll(newChallenges);
            _hasMoreCompletedData.value = newChallenges.length >= 10;
          }
        },
      );
    } catch (e) {
      debugPrint('Error loading more challenges: $e');
    } finally {
      _isLoadingMore.value = false;
    }
  }

  void resetPagination(String status) {
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
    resetPagination(status);
  }
}
