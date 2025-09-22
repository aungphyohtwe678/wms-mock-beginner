import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
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
/// - Latest just_audio 0.9.39 API implementation
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
  static bool _isIOS = false;
  
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
      
      // Detect iOS platform for web
      _isIOS = kIsWeb && (
        defaultTargetPlatform == TargetPlatform.iOS ||
        _detectIOSBrowser()
      );
      
      // Prepare audio player for iOS Safari
      if (_isIOS) {
        await _prepareIOSAudio();
      }
      
      _isInitialized = true;
      print('SoundManager initialized - iOS: $_isIOS, Muted: $_isMuted, Speed: $_playbackSpeed');
    } catch (e) {
      print('Error initializing SoundManager: $e');
      _isMuted = false;
      _playbackSpeed = 1.0;
      _isInitialized = true;
    }
  }
  
  /// Detect if running on iOS browser
  static bool _detectIOSBrowser() {
    if (!kIsWeb) return false;
    
    // In web environment, we need to check the user agent
    // This is a simplified check - in a real app you might want to use a more robust detection
    return defaultTargetPlatform == TargetPlatform.iOS;
  }
  
  /// Prepare audio for iOS Safari by preloading and setting up the player
  static Future<void> _prepareIOSAudio() async {
    try {
      // Set audio session for iOS
      await _audioPlayer.setVolume(0.0);
      await _audioPlayer.setAsset('assets/sounds/1.ogg'); // Small test sound
      await _audioPlayer.setVolume(1.0);
      print('iOS audio prepared successfully');
    } catch (e) {
      print('Error preparing iOS audio: $e');
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
    
    // For iOS Safari, prefer MP3 files when available
    if (_isIOS && soundFileName.endsWith('.ogg')) {
      final mp3FileName = soundFileName.replaceAll('.ogg', '.mp3');
      if (locale.languageCode == 'en') {
        return 'assets/sounds/en/$mp3FileName';
      } else {
        return 'assets/sounds/$mp3FileName';
      }
    }
    
    if (locale.languageCode == 'en') {
      return 'assets/sounds/en/$soundFileName';
    } else {
      return 'assets/sounds/$soundFileName';
    }
  }
  
  /// Get optimized sound file name for current platform
  static String getOptimizedSoundFileName(String soundFileName) {
    // For iOS Safari, prefer MP3 over OGG
    if (_isIOS && soundFileName.endsWith('.ogg')) {
      return soundFileName.replaceAll('.ogg', '.mp3');
    }
    return soundFileName;
  }
  
  /// Play a sound with automatic locale detection using just_audio API
  static Future<void> playSound(String soundFileName, BuildContext context) async {
    await initialize();
    
    if (_isMuted) {
      print('Sound is muted, not playing: $soundFileName');
      return; // Don't play sound if muted
    }
    
    try {
      final soundPath = getLocalizedSoundPath(soundFileName, context);
      
      // For iOS Safari, ensure audio is stopped and reset properly
      if (_isIOS) {
        await _audioPlayer.stop();
        await _audioPlayer.seek(Duration.zero);
      } else {
        await _audioPlayer.stop();
      }
      
      print('Playing sound: $soundPath at speed: $_playbackSpeed');
      
      // Use just_audio API to set asset source
      await _audioPlayer.setAsset(soundPath);
      
      // Set playback speed before playing
      if (_playbackSpeed != 1.0) {
        try {
          await _audioPlayer.setSpeed(_playbackSpeed);
          print('Playback speed set to: $_playbackSpeed');
        } catch (e) {
          print('Error setting playback speed: $e');
        }
      }
      
      // For iOS Safari, add a small delay before playing
      if (_isIOS) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      
      // Start playing
      await _audioPlayer.play();
      
    } catch (e) {
      print('Error playing localized sound: $e');
      // Fallback to default sound path if localized version doesn't exist
      try {
        if (_isIOS) {
          await _audioPlayer.stop();
          await _audioPlayer.seek(Duration.zero);
        } else {
          await _audioPlayer.stop();
        }
        
        final fallbackPath = 'assets/sounds/$soundFileName';
        print('Playing fallback sound: $fallbackPath at speed: $_playbackSpeed');
        await _audioPlayer.setAsset(fallbackPath);
        
        // Set playback speed for fallback too
        if (_playbackSpeed != 1.0) {
          try {
            await _audioPlayer.setSpeed(_playbackSpeed);
            print('Fallback playback speed set to: $_playbackSpeed');
          } catch (e) {
            print('Error setting fallback playback speed: $e');
          }
        }
        
        // For iOS Safari, add delay for fallback too
        if (_isIOS) {
          await Future.delayed(Duration(milliseconds: 100));
        }
        
        await _audioPlayer.play();
        
      } catch (fallbackError) {
        print('Error playing sound $soundFileName: $fallbackError');
      }
    }
  }
  
  /// Play a sound with explicit locale using just_audio API
  static Future<void> playSoundWithLocale(String soundFileName, String locale) async {
    await initialize();
    
    if (_isMuted) {
      print('Sound is muted, not playing: $soundFileName');
      return; // Don't play sound if muted
    }
    
    try {
      final soundPath = locale == 'en' ? 'assets/sounds/en/$soundFileName' : 'assets/sounds/$soundFileName';
      
      // For iOS Safari, ensure audio is stopped and reset properly
      if (_isIOS) {
        await _audioPlayer.stop();
        await _audioPlayer.seek(Duration.zero);
      } else {
        await _audioPlayer.stop();
      }
      
      print('Playing sound with locale: $soundPath at speed: $_playbackSpeed');
      
      // Use just_audio API to set asset source
      await _audioPlayer.setAsset(soundPath);
      
      // Set playback speed before playing
      if (_playbackSpeed != 1.0) {
        try {
          await _audioPlayer.setSpeed(_playbackSpeed);
          print('Playback speed set to: $_playbackSpeed');
        } catch (e) {
          print('Error setting playback speed: $e');
        }
      }
      
      // For iOS Safari, add a small delay before playing
      if (_isIOS) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      
      // Start playing
      await _audioPlayer.play();
      
    } catch (e) {
      print('Error playing localized sound: $e');
      // Fallback to default sound path if localized version doesn't exist
      try {
        if (_isIOS) {
          await _audioPlayer.stop();
          await _audioPlayer.seek(Duration.zero);
        } else {
          await _audioPlayer.stop();
        }
        
        final fallbackPath = 'assets/sounds/$soundFileName';
        print('Playing fallback sound: $fallbackPath at speed: $_playbackSpeed');
        await _audioPlayer.setAsset(fallbackPath);
        
        // Set playback speed for fallback too
        if (_playbackSpeed != 1.0) {
          try {
            await _audioPlayer.setSpeed(_playbackSpeed);
            print('Fallback playback speed set to: $_playbackSpeed');
          } catch (e) {
            print('Error setting fallback playback speed: $e');
          }
        }
        
        // For iOS Safari, add delay for fallback too
        if (_isIOS) {
          await Future.delayed(Duration(milliseconds: 100));
        }
        
        await _audioPlayer.play();
        
      } catch (fallbackError) {
        print('Error playing sound $soundFileName: $fallbackError');
      }
    }
  }
  
  /// Initialize audio context for iOS Safari (must be called from user gesture)
  static Future<void> initializeAudioContext() async {
    if (!_isIOS) return;
    
    try {
      // Play a silent sound to unlock audio context on iOS Safari
      await _audioPlayer.setVolume(0.0);
      await _audioPlayer.setAsset('assets/sounds/1.ogg');
      await _audioPlayer.play();
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(1.0);
      print('iOS Safari audio context initialized');
    } catch (e) {
      print('Error initializing iOS Safari audio context: $e');
    }
  }
  
  /// Stop current sound with error handling
  static Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }
  
  /// Dispose the audio player with proper cleanup (just_audio)
  static Future<void> dispose() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
      _isInitialized = false;
    } catch (e) {
      print('Error disposing SoundManager: $e');
    }
  }
}
