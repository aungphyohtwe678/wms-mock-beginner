import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SafeAudioManager {
  SafeAudioManager._internal();
  static final SafeAudioManager instance = SafeAudioManager._internal();

  bool _isUnlocked = false;

  /// Pools of players per asset
  final Map<String, List<AudioPlayer>> _playerPools = {};
  final Set<String> _preloaded = {};

  /// Limit number of players per asset
  final int maxPoolSize = 3;

  Future<void> unlock() async {
    if (_isUnlocked) return;
    try {
      final temp = AudioPlayer();
      await temp.play(AssetSource('sounds/suryo.ogg'));
      await temp.stop();
      _isUnlocked = true;
      debugPrint("🔊 Audio unlocked on iOS Safari");
    } catch (e) {
      debugPrint("⚠️ Unlock failed: $e");
    }
  }

  Future<void> preload(String assetPath) async {
    if (!_isUnlocked) {
      debugPrint("⚠️ Call unlock() inside a user gesture first!");
      return;
    }
    if (_preloaded.contains(assetPath)) return;

    _preloaded.add(assetPath);
    _playerPools[assetPath] = [];
    debugPrint("✅ Preloaded: $assetPath");
  }

  bool isPreloaded(String assetPath) {
    return _preloaded.contains(assetPath);
  }

  Future<void> play(String assetPath) async {
    if (!_isUnlocked) {
      debugPrint("⚠️ Must unlock first!");
      return;
    }

    if (!isPreloaded(assetPath)) {
      debugPrint("⚠️ $assetPath not preloaded, adding now...");
      await preload(assetPath);
    }

    final pool = _playerPools[assetPath]!;

    // Try to find idle player
    AudioPlayer? player;
    try {
      player = pool.firstWhere(
        (p) => p.state != PlayerState.playing,
      );
    } catch (e) {
      player = null;
    }

    if (player == null) {
      if (pool.length >= maxPoolSize) {
        // Reached limit → reset pool
        debugPrint("⚠️ Pool limit reached for $assetPath. Resetting pool.");
        for (var p in pool) {
          p.stop();
          p.dispose();
        }
        pool.clear();
      }

      // Create a new player (after reset or if space available)
      player = AudioPlayer();
      pool.add(player);
    }

    await player.stop(); // reset state
    await player.play(AssetSource(assetPath));
  }

  /// Reset all pools manually (optional)
  void resetAll() {
    for (var pool in _playerPools.values) {
      for (var p in pool) {
        p.stop();
        p.dispose();
      }
      pool.clear();
    }
    debugPrint("🔄 All audio pools cleared");
  }
}
