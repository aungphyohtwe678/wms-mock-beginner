import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SafeAudioPlayer {
  SafeAudioPlayer._internal();
  static final SafeAudioPlayer instance = SafeAudioPlayer._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isUnlocked = false;

  final Map<String, bool> _preloaded = {};

  Future<void> unlock(String assetPath) async {
    if (_isUnlocked) return;
    try {
      await _player.play(AssetSource(assetPath));
      await _player.stop();
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
    await _player.setSource(AssetSource(assetPath));
    _preloaded[assetPath] = true;
    debugPrint("✅ Preloaded: $assetPath");
  }

  bool isPreloaded(String assetPath) {
    return _preloaded[assetPath] ?? false;
  }

  Future<void> play() async {
    if (!_isUnlocked) {
      debugPrint("⚠️ Call unlock() first!");
      return;
    }
    await _player.resume(); // plays from preloaded source
  }

  Future<void> playAsset(String assetPath) async {
    if (!_isUnlocked) {
      debugPrint("⚠️ Call unlock() first!");
      return;
    }
    await _player.play(AssetSource(assetPath));
  }
}
