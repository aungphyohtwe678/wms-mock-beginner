import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../utils/sound_manager.dart';

class AudioSettingsScreen extends StatefulWidget {
  const AudioSettingsScreen({super.key});

  @override
  State<AudioSettingsScreen> createState() => _AudioSettingsScreenState();
}

class _AudioSettingsScreenState extends State<AudioSettingsScreen> {
  bool _isMuted = false;
  double _playbackSpeed = 1.0;
  
  @override
  void initState() {
    super.initState();
    _loadAudioSettings();
  }

  void _loadAudioSettings() {
    setState(() {
      _isMuted = SoundManager.isMuted;
      _playbackSpeed = SoundManager.playbackSpeed;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    SoundManager.setMuted(_isMuted);
    print('Mute toggled to: $_isMuted');
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isMuted ? 'Sounds muted' : 'Sounds enabled'),
        backgroundColor: _isMuted ? Colors.red : Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _updatePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    SoundManager.setPlaybackSpeed(speed);
    print('Playback speed updated to: $speed');
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playback speed set to ${_getSpeedLabel(speed)}'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _testSound() {
    print('Testing sound with current settings - Muted: $_isMuted, Speed: $_playbackSpeed');
    SoundManager.playSound('pi.ogg', context);
  }

  String _getSpeedLabel(double speed) {
    if (speed == 0.5) return '0.5x (Slow)';
    if (speed == 0.75) return '0.75x';
    if (speed == 1.0) return '1.0x (Normal)';
    if (speed == 1.25) return '1.25x';
    if (speed == 1.5) return '1.5x';
    if (speed == 2.0) return '2.0x (Fast)';
    return '${speed}x';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
        title: Text(
          'Audio Settings',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Helvetica Neue',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mute/Unmute Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sound Control',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mute Sounds',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Switch(
                          value: _isMuted,
                          onChanged: (value) => _toggleMute(),
                          activeColor: Colors.red,
                          inactiveThumbColor: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isMuted 
                        ? 'All sounds are muted'
                        : 'Sounds are enabled',
                      style: TextStyle(
                        fontSize: 14,
                        color: _isMuted ? Colors.red : Colors.green,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Playback Speed Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Playback Speed',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Current Speed: ${_getSpeedLabel(_playbackSpeed)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: _playbackSpeed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 6,
                      label: _getSpeedLabel(_playbackSpeed),
                      onChanged: _updatePlaybackSpeed,
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0.5x',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '1.0x',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '2.0x',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Test Sound Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Sound',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Play a test sound to check your audio settings',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _testSound,
                        icon: const Icon(Icons.play_arrow),
                        label: Text('Play Test Sound'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          print('Testing basic sound without SoundManager');
                          // Test direct AudioPlayer
                          final player = AudioPlayer();
                          player.play(AssetSource('sounds/pi.ogg'));
                        },
                        icon: const Icon(Icons.music_note),
                        label: Text('Test Direct Audio'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Reset to Default Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isMuted = false;
                    _playbackSpeed = 1.0;
                    SoundManager.setMuted(false);
                    SoundManager.setPlaybackSpeed(1.0);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Audio settings reset to default'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Reset to Default'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
