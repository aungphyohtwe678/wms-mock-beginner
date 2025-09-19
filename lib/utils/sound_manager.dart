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
  static bool _isSafari = false;
  
  // Getters for accessing current settings
  static bool get isMuted => _isMuted;
  static double get playbackSpeed => _playbackSpeed;
  static bool get isSafari => _isSafari;
  
  /// Initialize the SoundManager and load saved settings
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Detect Safari/iOS for special handling
      _isSafari = _detectSafari();
      
      final prefs = await SharedPreferences.getInstance();
      _isMuted = prefs.getBool('sound_muted') ?? false;
      _playbackSpeed = prefs.getDouble('sound_playback_speed') ?? 1.0;
      _isInitialized = true;
      print('SoundManager initialized - Muted: $_isMuted, Speed: $_playbackSpeed, Safari: $_isSafari');
    } catch (e) {
      print('Error initializing SoundManager: $e');
      _isMuted = false;
      _playbackSpeed = 1.0;
      _isInitialized = true;
    }
  }
  
  /// Detect if running on Safari/iOS
  static bool _detectSafari() {
    // This is a simplified detection - in a real app you might use 
    // platform detection or user agent checking
    try {
      // For now, assume Safari if we're on iOS or web
      return true; // You can implement more sophisticated detection here
    } catch (e) {
      return false;
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
  
  /// Set playback rate with Safari-specific handling
  static Future<void> _setPlaybackRateWithSafariSupport(double speed) async {
    if (_isSafari) {
      // Safari needs special handling for playback rate
      try {
        // Add delay before setting rate on Safari
        await Future.delayed(const Duration(milliseconds: 200));
        await _audioPlayer.setPlaybackRate(speed);
        print('Safari playback rate set to: $speed');
        
        // Additional delay to let Safari process the rate change
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        print('Error setting Safari playback rate: $e');
        // Try alternative approach for Safari
        try {
          await Future.delayed(const Duration(milliseconds: 300));
          await _audioPlayer.setPlaybackRate(speed);
        } catch (retryError) {
          print('Safari playback rate retry failed: $retryError');
        }
      }
    } else {
      // Standard playback rate setting for other browsers
      try {
        await _audioPlayer.setPlaybackRate(speed);
        print('Playback rate set to: $speed');
      } catch (e) {
        print('Error setting playback rate: $e');
      }
    }
  }

  /// Get Safari-optimized playback speed for specific sound files
  static double _getSafariOptimizedSpeed(String soundFileName) {
    if (!_isSafari) return _playbackSpeed;
    
    // Specific optimizations for problematic Safari sounds
    final Map<String, double> safariSpeedMap = {
      '8c.ogg': 0.8, // Slower for better Safari compatibility
      '4c.ogg': 0.8, // Slower for better Safari compatibility
      'kara-pl.ogg': 0.9, // Slightly slower
      'pic-start5.ogg': 0.9,
      'pic-start6.ogg': 0.9,
    };
    
    if (safariSpeedMap.containsKey(soundFileName)) {
      final optimizedSpeed = safariSpeedMap[soundFileName]! * _playbackSpeed;
      print('Safari optimized speed for $soundFileName: $optimizedSpeed');
      return optimizedSpeed.clamp(0.5, 2.0);
    }
    
    return _playbackSpeed;
  }
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
      if (_playbackSpeed != 1.0 || _isSafari) {
        final optimizedSpeed = _getSafariOptimizedSpeed(soundFileName);
        await _setPlaybackRateWithSafariSupport(optimizedSpeed);
      }
      
    } catch (e) {
      print('Error playing localized sound: $e');
      // Fallback to default sound path if localized version doesn't exist
      try {
        await _audioPlayer.stop();
        
        print('Playing fallback sound: sounds/$soundFileName at speed: $_playbackSpeed');
        await _audioPlayer.play(AssetSource('sounds/$soundFileName'));
        
        // Set playback rate for fallback too
        if (_playbackSpeed != 1.0 || _isSafari) {
          final optimizedSpeed = _getSafariOptimizedSpeed(soundFileName);
          await _setPlaybackRateWithSafariSupport(optimizedSpeed);
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
      if (_playbackSpeed != 1.0 || _isSafari) {
        final optimizedSpeed = _getSafariOptimizedSpeed(soundFileName);
        await _setPlaybackRateWithSafariSupport(optimizedSpeed);
      }
      
    } catch (e) {
      print('Error playing localized sound: $e');
      // Fallback to default sound path if localized version doesn't exist
      try {
        await _audioPlayer.stop();
        
        print('Playing fallback sound: sounds/$soundFileName at speed: $_playbackSpeed');
        await _audioPlayer.play(AssetSource('sounds/$soundFileName'));
        
        // Set playback rate for fallback too
        if (_playbackSpeed != 1.0 || _isSafari) {
          final optimizedSpeed = _getSafariOptimizedSpeed(soundFileName);
          await _setPlaybackRateWithSafariSupport(optimizedSpeed);
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
