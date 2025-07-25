import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/challenge_details.dart';
import '../../domain/usecases/get_challenge_details_usecase.dart';
import '../../domain/usecases/join_challenge_usecase.dart';

class ChallengeDetailsController extends GetxController {
  final GetChallengeDetailsUseCase getChallengeDetailsUseCase;
  final JoinChallengeDetailsUseCase joinChallengeUseCase;

  ChallengeDetailsController({
    required this.getChallengeDetailsUseCase,
    required this.joinChallengeUseCase,
  });

  // State - Using RxBool and Rx for reactive updates
  final RxBool _isLoading = true.obs;
  final RxBool _isJoinLoading = false.obs;
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  final Rx<ChallengeDetails?> _challengeDetails = Rx<ChallengeDetails?>(null);

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isJoinLoading => _isJoinLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  ChallengeDetails? get challengeDetails => _challengeDetails.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint('ChallengeDetailsController initialized');
  }

  @override
  void onClose() {
    debugPrint('ChallengeDetailsController disposed');
    super.onClose();
  }

  Future<void> getChallengeDetails(String challengeId) async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';

      debugPrint('Fetching challenge details for ID: $challengeId');

      final params = GetChallengeDetailsParams(challengeId: challengeId);
      final result = await getChallengeDetailsUseCase(params);

      result.fold(
        (failure) {
          debugPrint('Error fetching challenge details: ${failure.message}');
          _hasError.value = true;
          _errorMessage.value = failure.message;
        },
        (challengeDetails) {
          debugPrint(
            'Challenge details fetched successfully: ${challengeDetails.title}',
          );
          _challengeDetails.value = challengeDetails;
        },
      );
    } catch (e) {
      debugPrint('Exception in getChallengeDetails: $e');
      _hasError.value = true;
      _errorMessage.value = 'An unexpected error occurred';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> joinChallenge(String challengeId) async {
    if (_isJoinLoading.value) return; // Prevent multiple calls

    try {
      _isJoinLoading.value = true;
      debugPrint('Joining challenge: $challengeId');

      final params = JoinChallengeParams(challengeId: challengeId);
      final result = await joinChallengeUseCase(params);

      result.fold(
        (failure) {
          debugPrint('Error joining challenge: ${failure.message}');
          _showErrorSnackbar(failure.message);
        },
        (success) async {
          debugPrint('Successfully joined challenge');
          await _showSuccessSnackbar();
          // Refresh challenge details after joining
          await getChallengeDetails(challengeId);
        },
      );
    } catch (e) {
      debugPrint('Exception in joinChallenge: $e');
      _showErrorSnackbar('Unable to join challenge. Please try again.');
    } finally {
      _isJoinLoading.value = false;
    }
  }

  Future<void> _showSuccessSnackbar() async {
    // Use WidgetsBinding to ensure the widget tree is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null && Get.overlayContext != null) {
        Get.snackbar(
          'Success',
          'You joined the challenge successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
        );
      } else {
        // Fallback - try again after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (Get.context != null) {
            Get.snackbar(
              'Success',
              'You joined the challenge successfully!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              margin: const EdgeInsets.all(16),
              borderRadius: 8,
              isDismissible: true,
            );
          }
        });
      }
    });
  }

  void _showErrorSnackbar(String message) {
    // Use WidgetsBinding to ensure the widget tree is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null && Get.overlayContext != null) {
        Get.snackbar(
          'Error',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
        );
      } else {
        // Fallback - try again after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (Get.context != null) {
            Get.snackbar(
              'Error',
              message,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              margin: const EdgeInsets.all(16),
              borderRadius: 8,
              isDismissible: true,
            );
          }
        });
      }
    });
  }

  void retryLoading(String challengeId) {
    getChallengeDetails(challengeId);
  }

  // Method to reset state when needed
  void resetState() {
    _isLoading.value = true;
    _isJoinLoading.value = false;
    _hasError.value = false;
    _errorMessage.value = '';
    _challengeDetails.value = null;
  }
}
