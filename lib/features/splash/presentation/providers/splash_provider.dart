import 'package:flutter/material.dart';

import '../../../../core/services/audio_service.dart';
import '../../../../core/services/storage_service.dart';

class SplashProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String _animationPhase = 'initial';

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get animationPhase => _animationPhase;

  Future<void> initializeApp() async {
    try {
      // Play launch sound
      await AudioService.playAppLaunchSound();

      // Animation phases
      await _runAnimationSequence();

      // Check authentication
      await _checkAuthStatus();
    } catch (e) {
      print('Initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _runAnimationSequence() async {
    // Initial phase
    _animationPhase = 'logo_entrance';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));

    // Livera text animation
    _animationPhase = 'text_animation';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1200));

    // Popper effects
    _animationPhase = 'poppers';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1500));

    // Women walking animation
    _animationPhase = 'women_walking';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 2000));

    // Final glow effect
    _animationPhase = 'final_glow';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _checkAuthStatus() async {
    final token = await StorageService.getToken();
    _isAuthenticated = token != null && token.isNotEmpty;
    notifyListeners();
  }
}
