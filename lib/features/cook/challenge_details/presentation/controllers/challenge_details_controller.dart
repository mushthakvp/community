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

  // State
  final _isLoading = true.obs;
  final _isJoinLoading = false.obs;
  final _hasError = false.obs;
  final _errorMessage = ''.obs;
  final Rx<ChallengeDetails?> _challengeDetails = Rx<ChallengeDetails?>(null);

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isJoinLoading => _isJoinLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  ChallengeDetails? get challengeDetails => _challengeDetails.value;

  Future<void> getChallengeDetails(String challengeId) async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';

      final params = GetChallengeDetailsParams(challengeId: challengeId);
      final result = await getChallengeDetailsUseCase(params);

      result.fold(
        (failure) {
          _hasError.value = true;
          _errorMessage.value = failure.message;
        },
        (challengeDetails) {
          _challengeDetails.value = challengeDetails;
        },
      );
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'An unexpected error occurred';
      debugPrint('Error getting challenge details: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> joinChallenge(String challengeId) async {
    try {
      _isJoinLoading.value = true;

      final params = JoinChallengeParams(challengeId: challengeId);
      final result = await joinChallengeUseCase(params);

      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (success) async {
          await _showSuccessDialog();
          await getChallengeDetails(challengeId);
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to join challenge. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Error joining challenge: $e');
    } finally {
      _isJoinLoading.value = false;
    }
  }

  Future<void> _showSuccessDialog() async {
    Get.snackbar(
      'Success',
      'You joined the challenge successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void retryLoading(String challengeId) {
    getChallengeDetails(challengeId);
  }
}
