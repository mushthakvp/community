import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioService {
  static final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();

  static Future<void> playSound(String assetPath) async {
    try {
      await _audioPlayer.startPlayer(
        fromURI: "assets/$assetPath",
        codec: Codec.mp3,
        whenFinished: () {
          _audioPlayer.stopPlayer();
        },
      );
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

  static Future<void> playSpinSound() async {
    await playSound('sounds/spinner_sound.mp3');
    await HapticFeedback.mediumImpact();
  }

  static Future<void> stopSpinSound() async {
    await _audioPlayer.stopPlayer();
  }

  static Future<void> playWinSound() async {
    await playSound('sounds/winning_sound.mp3');
    await HapticFeedback.mediumImpact();
  }

  static void dispose() {
    _audioPlayer.stopPlayer();
  }
}
