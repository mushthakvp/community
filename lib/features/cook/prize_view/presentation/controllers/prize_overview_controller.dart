import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/prize_overview.dart';
import '../../domain/usecases/get_prize_overview_usecase.dart';

class PrizeOverviewController extends GetxController
    with GetTickerProviderStateMixin {
  final GetPrizeOverviewUseCase getPrizeOverviewUseCase;

  PrizeOverviewController({required this.getPrizeOverviewUseCase});

  // State
  final _isLoading = false.obs;
  final _hasError = false.obs;
  final _errorMessage = ''.obs;
  final _prizeOverview = Rx<PrizeOverview?>(null);
  late AnimationController _confettiController;
  late AnimationController _fadeInController;
  late Animation<double> _fadeInAnimation;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  PrizeOverview? get prizeOverview => _prizeOverview.value;
  AnimationController get confettiController => _confettiController;
  Animation<double> get fadeInAnimation => _fadeInAnimation;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
  }

  @override
  void onClose() {
    _confettiController.dispose();
    _fadeInController.dispose();
    super.onClose();
  }

  void _initializeAnimations() {
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeIn,
    );
  }

  Future<void> loadPrizeOverview(String challengeId) async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';
      await Future.delayed(const Duration(milliseconds: 500));
      final params = GetPrizeOverviewParams(challengeId: challengeId);
      final result = await getPrizeOverviewUseCase(params);

      result.fold(
        (failure) {
          _hasError.value = true;
          _errorMessage.value = failure.message;
        },
        (prizeOverview) {
          _prizeOverview.value = prizeOverview;
          _startAnimations(prizeOverview);
        },
      );
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'An unexpected error occurred';
      debugPrint('Error loading prize overview: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _startAnimations(PrizeOverview prizeOverview) {
    _fadeInController.forward();
    if (prizeOverview.isUserWinner) {
      _confettiController.forward();
    }
  }

  void retryLoading(String challengeId) {
    loadPrizeOverview(challengeId);
  }

  void resetState() {
    _isLoading.value = false;
    _hasError.value = false;
    _errorMessage.value = '';
    _prizeOverview.value = null;
    _confettiController.reset();
    _fadeInController.reset();
  }

  void navigateToRecipeView(dynamic position) {
    Get.toNamed('/cook/recipe-view', arguments: {'position': position});
  }

  void navigateBack() {
    Get.back();
  }
}
