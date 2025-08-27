import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// SoundManager handles localized sound playback
/// 
/// This class automatically plays sounds from different directories based on the current locale:
/// - When locale is 'en': plays from sounds/en/
/// - For other locales: plays from sounds/
/// 
/// Example usage:
/// ```dart
/// // Play a sound with automatic locale detection
/// await SoundManager.playSound('kara-pl.ogg', context);
/// 
/// // Play a sound with explicit locale
/// await SoundManager.playSoundWithLocale('pi.ogg', 'en');
/// 
/// // Stop current sound
/// await SoundManager.stopSound();
/// ```
class SoundManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  
  /// Get the localized sound path based on the current locale
  static String getLocalizedSoundPath(String soundFileName, BuildContext context) {
    final locale = Localizations.localeOf(context);
    
    if (locale.languageCode == 'en') {
      return 'sounds/en/$soundFileName';
    } else {
      return 'sounds/$soundFileName';
    }
  }
  
  /// Play a sound with automatic locale detection
  static Future<void> playSound(String soundFileName, BuildContext context) async {
    try {
      final soundPath = getLocalizedSoundPath(soundFileName, context);
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      // Fallback to default sound path if localized version doesn't exist
      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('sounds/$soundFileName'));
      } catch (fallbackError) {
        print('Error playing sound $soundFileName: $fallbackError');
      }
    }
  }
  
  /// Play a sound with explicit locale
  static Future<void> playSoundWithLocale(String soundFileName, String locale) async {
    try {
      final soundPath = locale == 'en' ? 'sounds/en/$soundFileName' : 'sounds/$soundFileName';
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      // Fallback to default sound path if localized version doesn't exist
      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('sounds/$soundFileName'));
      } catch (fallbackError) {
        print('Error playing sound $soundFileName: $fallbackError');
      }
    }
  }
  
  /// Stop current sound
  static Future<void> stopSound() async {
    await _audioPlayer.stop();
  }
  
  /// Dispose the audio player (call this in your app's dispose method)
  static void dispose() {
    _audioPlayer.dispose();
  }
}
