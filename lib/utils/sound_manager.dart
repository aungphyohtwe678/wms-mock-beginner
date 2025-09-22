import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SoundManager handles localized sound playback with audio settings
/// 
/// This class automatically plays sounds from different directories based on the current locale:
/// - When locale is 'en': plays from sounds/en/
/// - For other locales: plays from sounds/
/// 
/// Features:
/// - Mute/unmute functionality
/// - Playback speed control (0.5x to 2.0x)
/// - Settings persistence using SharedPreferences
/// 
/// Example usage:
/// ```dart
/// // Play a sound with automatic locale detection
/// await SoundManager.playSound('kara-pl.ogg', context);
/// 
/// // Play a sound with explicit locale
/// await SoundManager.playSoundWithLocale('pi.ogg', 'en');
/// 
/// // Mute/unmute sounds
/// SoundManager.setMuted(true);
/// 
/// // Set playback speed
/// SoundManager.setPlaybackSpeed(1.5);
/// 
/// // Stop current sound
/// await SoundManager.stopSound();
/// ```
class SoundManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isMuted = false;
  static double _playbackSpeed = 1.0;
  static bool _isInitialized = false;
  
  // Getters for accessing current settings
  static bool get isMuted => _isMuted;
  static double get playbackSpeed => _playbackSpeed;
  
  /// Initialize the SoundManager and load saved settings
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _isMuted = prefs.getBool('sound_muted') ?? false;
      _playbackSpeed = prefs.getDouble('sound_playback_speed') ?? 1.0;
      _isInitialized = true;
      print('SoundManager initialized - Muted: $_isMuted, Speed: $_playbackSpeed');
    } catch (e) {
      print('Error initializing SoundManager: $e');
      _isMuted = false;
      _playbackSpeed = 1.0;
      _isInitialized = true;
    }
  }
  
  /// Set mute state and save to preferences
  static Future<void> setMuted(bool muted) async {
    _isMuted = muted;
    print('Setting muted to: $muted');
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sound_muted', muted);
    } catch (e) {
      print('Error saving mute setting: $e');
    }
  }
  
  /// Set playback speed and save to preferences
  static Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed.clamp(0.5, 2.0);
    print('Setting playback speed to: $_playbackSpeed');
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('sound_playback_speed', _playbackSpeed);
    } catch (e) {
      print('Error saving playback speed: $e');
    }
  }
  
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
    await initialize();
    
    if (_isMuted) {
      print('Sound is muted, not playing: $soundFileName');
      return; // Don't play sound if muted
    }
    
    try {
      final soundPath = getLocalizedSoundPath(soundFileName, context);
      await _audioPlayer.stop();
      
      print('Playing sound: $soundPath at speed: $_playbackSpeed');
      
      // Start playing the sound
      await _audioPlayer.play(AssetSource(soundPath));
      
      // Set playback rate after starting playback
      if (_playbackSpeed != 1.0) {
        try {
          await _audioPlayer.setPlaybackRate(_playbackSpeed);
          print('Playback rate set to: $_playbackSpeed');
        } catch (e) {
          print('Error setting playback rate: $e');
        }
      }
      
    } catch (e) {
      print('Error playing localized sound: $e');
      // Fallback to default sound path if localized version doesn't exist
      try {
        await _audioPlayer.stop();
        
        print('Playing fallback sound: sounds/$soundFileName at speed: $_playbackSpeed');
        await _audioPlayer.play(AssetSource('sounds/$soundFileName'));
        
        // Set playback rate for fallback too
        if (_playbackSpeed != 1.0) {
          try {
            await _audioPlayer.setPlaybackRate(_playbackSpeed);
            print('Fallback playback rate set to: $_playbackSpeed');
          } catch (e) {
            print('Error setting fallback playback rate: $e');
          }
        }
        
      } catch (fallbackError) {
        print('Error playing sound $soundFileName: $fallbackError');
      }
    }
  }
  
  /// Play a sound with explicit locale
  static Future<void> playSoundWithLocale(String soundFileName, String locale) async {
    await initialize();
    
    if (_isMuted) {
      print('Sound is muted, not playing: $soundFileName');
      return; // Don't play sound if muted
    }
    
    try {
      final soundPath = locale == 'en' ? 'sounds/en/$soundFileName' : 'sounds/$soundFileName';
      await _audioPlayer.stop();
      
      print('Playing sound with locale: $soundPath at speed: $_playbackSpeed');
      
      // Start playing the sound
      await _audioPlayer.play(AssetSource(soundPath));
      
      // Set playback rate after starting playback
      if (_playbackSpeed != 1.0) {
        try {
          await _audioPlayer.setPlaybackRate(_playbackSpeed);
          print('Playback rate set to: $_playbackSpeed');
        } catch (e) {
          print('Error setting playback rate: $e');
        }
      }
      
    } catch (e) {
      print('Error playing localized sound: $e');
      // Fallback to default sound path if localized version doesn't exist
      try {
        await _audioPlayer.stop();
        
        print('Playing fallback sound: sounds/$soundFileName at speed: $_playbackSpeed');
        await _audioPlayer.play(AssetSource('sounds/$soundFileName'));
        
        // Set playback rate for fallback too
        if (_playbackSpeed != 1.0) {
          try {
            await _audioPlayer.setPlaybackRate(_playbackSpeed);
            print('Fallback playback rate set to: $_playbackSpeed');
          } catch (e) {
            print('Error setting fallback playback rate: $e');
          }
        }
        
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
