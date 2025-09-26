import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SafeAudioManager {
  SafeAudioManager._internal();
  static final SafeAudioManager instance = SafeAudioManager._internal();

  bool _isUnlocked = false;
  final Map<String, List<AudioPlayer>> _playerPools = {};
  final Set<String> _registeredSounds = {};
  final int maxPoolSize = 8;

  /// Unlock audio system (must be called inside a user gesture)
   Future<void> unlock(List<String> assetPaths) async {
    if (_isUnlocked) {
      print("🔊 Audio already unlocked");
      return;
    }

    // For each asset, create a player and play/stop it once to unlock
    for (final asset in assetPaths) {
      final player = AudioPlayer();
      _playerPools[asset] = [player]; // keep the unlocked player!

      try {
        await player.play(AssetSource(asset));
        await player.stop(); // stop, but keep the player object alive
      } catch (e) {
        print("❌ Unlock failed for $asset: $e");
      }
    }

    _isUnlocked = true;
    print("✅ Audio unlocked & players initialized");
  }

  /// Register sound for pool (preload bookkeeping)
  Future<void> registerSound(String assetPath) async {
    if (!_isUnlocked) {
      debugPrint("⚠️ Must unlock first!");
      return;
    }
    _registeredSounds.add(assetPath);
    _playerPools[assetPath] ??= [];
    debugPrint("✅ Registered sound: $assetPath");
  }

  bool isRegistered(String assetPath) => _registeredSounds.contains(assetPath);

  /// Play sound safely, supports multiple rapid taps
  Future<void> play(String assetPath) async {
    if (!_isUnlocked) {
      debugPrint("⚠️ Must unlock first!");
      return;
    }
    if (!isRegistered(assetPath)) {
      debugPrint("⚠️ $assetPath not registered, adding now...");
      await registerSound(assetPath);
    }

    final pool = _playerPools[assetPath]!;

    // Find idle player
    AudioPlayer? player;
    try {
      player = pool.firstWhere((p) => p.state != PlayerState.playing);
    } catch (e) {
      print('No idle player found in pool for $assetPath: $e');
      player = null;
    }

    // Create new player if none idle
    if (player == null) {
      print("No idle player, creating new for $assetPath");
      if (pool.length >= maxPoolSize) {
        // Reset pool if max reached
        print("Pool limit reached for $assetPath, resetting pool");
        for (var p in pool) {
          p.stop();
          p.dispose();
        }
        pool.clear();
        print("⚠️ Pool limit reached, reset pool for $assetPath");
      }
      print("Creating new AudioPlayer for $assetPath");
      player = AudioPlayer();
      pool.add(player);
      print(assetPath + " pool size: ${pool.length}");
    }

    // Always call play() for each playback
    print("⏹ Stopping any current playback for $assetPath");
    await player.stop();
    print("▶️ Playing sound: $assetPath");
    try {
      await player.play(AssetSource(assetPath));
    } catch (e) {
      print("❌ Play error for $assetPath: $e");
    }    
    print("✅ Played sound: $assetPath");
  }

  /// Reset all pools manually
  // void resetAll() {
  //   for (var pool in _playerPools.values) {
  //     for (var p in pool) {
  //       p.stop();
  //       p.dispose();
  //     }
  //     pool.clear();
  //   }
  //   debugPrint("🔄 All audio pools cleared");
  // }

  void resetAll() async {
    for (final pool in _playerPools.values) {
      for (final player in pool) {
        await player.stop();
        player.dispose();
      }
    }
    _playerPools.clear();
    _registeredSounds.clear();
    _isUnlocked = false;
    debugPrint("🔄 Complete reset - audio must be unlocked again");
  }
}