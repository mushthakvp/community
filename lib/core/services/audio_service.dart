import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playSound(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath.replaceAll('assets/', '')));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  static Future<void> playLogoutSound() async {
    await playSound('sounds/logout_sound.mp3');
    await HapticFeedback.mediumImpact();
  }

  static Future<void> playAppLaunchSound() async {
    await playSound('sounds/app_launch.mp3');
    await HapticFeedback.lightImpact();
  }

  static Future<void> playClickSound() async {
    await playSound('sounds/click_sound.mp3');
    await HapticFeedback.selectionClick();
  }

  static void dispose() {
    _audioPlayer.dispose();
  }
}
