import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SafeAudioManager {
  SafeAudioManager._internal();
  static final SafeAudioManager instance = SafeAudioManager._internal();

  bool _isUnlocked = false;

  /// Pools of players per asset
  final Map<String, List<AudioPlayer>> _playerPools = {};
  final Set<String> _preloaded = {};

  Future<void> unlock(String assetPath) async {
    if (_isUnlocked) return;
    try {
      final temp = AudioPlayer();
      await temp.play(AssetSource(assetPath));
      await temp.stop();
      _isUnlocked = true;
      print("🔊 Audio unlocked on iOS Safari");
    } catch (e) {
      print("⚠️ Unlock failed: $e");
    }
  }

  Future<void> preload(String assetPath) async {
    if (!_isUnlocked) {
      print("⚠️ Call unlock() inside a user gesture first!");
      return;
    }
    if (_preloaded.contains(assetPath)) return;

    _preloaded.add(assetPath);
    _playerPools[assetPath] = [];
    print("✅ Preloaded: $assetPath");
  }

  bool isPreloaded(String assetPath) {
    return _preloaded.contains(assetPath);
  }

  Future<void> play(String assetPath) async {
    if (!_isUnlocked) {
      print("⚠️ Must unlock first!");
      return;
    }

    if (!isPreloaded(assetPath)) {
      print("⚠️ $assetPath not preloaded, adding now...");
      await preload(assetPath);
    }

    // Look for an idle player
    final pool = _playerPools[assetPath]!;
    AudioPlayer? player = pool.firstWhere(
      (p) => p.state != PlayerState.playing,
      orElse: () => AudioPlayer(),
    );

    // If new player, add it to the pool
    if (!pool.contains(player)) {
      pool.add(player);
    }

    await player.stop(); // reset state
    await player.play(AssetSource(assetPath));
  }
}
