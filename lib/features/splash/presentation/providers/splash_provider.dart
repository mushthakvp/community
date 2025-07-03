import 'package:flutter/material.dart';

import '../../../../core/services/audio_service.dart';
import '../../../../core/services/storage_service.dart';

class SplashProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String _animationPhase = 'initial';
  VoidCallback? onWalkingComplete;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get animationPhase => _animationPhase;

  Future<void> initializeApp() async {
    try {
      await AudioService.playAppLaunchSound();
      await _runAnimationSequence();
      await _checkAuthStatus();
    } catch (e) {
      debugPrint('Initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _runAnimationSequence() async {
    _animationPhase = 'logo_entrance';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));

    _animationPhase = 'text_animation';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));

    _animationPhase = 'marketplace_particles';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));

    _animationPhase = 'women_walking';
    notifyListeners();
  }

  void completeWalkingAnimation() {
    _animationPhase = 'final_glow';
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 200), () {
      onWalkingComplete?.call();
    });
  }

  Future<void> _checkAuthStatus() async {
    final token = await StorageService.getToken();
    _isAuthenticated = token != null && token.isNotEmpty;
    notifyListeners();
  }
}
