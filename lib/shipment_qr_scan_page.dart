import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/pickking-cs2.dart';
import 'package:otk_wms_mock/safe_audio_player.dart';
import 'l10n/app_localizations.dart';

class ShipmentQrScanPage extends StatefulWidget {
  const ShipmentQrScanPage({super.key});

  @override
  State<ShipmentQrScanPage> createState() => _ShipmentQrScanPageState();
}

class _ShipmentQrScanPageState extends State<ShipmentQrScanPage> {
  final TextEditingController _qrController = TextEditingController();
  final FocusNode _qrFocusNode = FocusNode();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _playSound('scan_shipping_equipment.ogg');
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _qrController.dispose();
    _qrFocusNode.dispose();
    super.dispose();
  }

  // === Audio Helper Methods ===
  Future<void> _playSound(String soundFileName) async {
    // Get current locale before async operations
    final locale = Localizations.localeOf(context).languageCode;
    
    try {
      await _audioPlayer.stop();
      
      // Determine sound path based on locale
      String soundPath;
      if (locale == 'en') {
        // Play English version if available
        soundPath = 'sounds/en/$soundFileName';
      } else {
        // Default to Japanese sounds
        soundPath = 'sounds/$soundFileName';
      }
      
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      print('Error playing sound $soundFileName: $e');
      // Fallback to default Japanese sound if English version fails
      if (e.toString().contains('FileSystemException') || e.toString().contains('not found')) {
        try {
          await _audioPlayer.play(AssetSource('sounds/$soundFileName'));
        } catch (fallbackError) {
          print('Fallback sound also failed for $soundFileName: $fallbackError');
        }
      }
    }
  }

  Future<void> _stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }

  String _getLocalizedSoundPath(String soundFile) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'en') {
      return 'sounds/en/$soundFile';
    } else {
      // Default to Japanese (sounds/ directory)
      return 'sounds/$soundFile';
    }
  }

  void _onQrCodeEntered() async {
    // Stop the current sound before proceeding
    await _stopSound();

    _qrController.text = "XXX-XXX-XXXX";
    await Future.delayed(const Duration(milliseconds: 1000));
    await SafeAudioPlayer.instance.preload(_getLocalizedSoundPath('pic-start5.ogg'));
    await Future.delayed(const Duration(milliseconds: 2500));


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PickkingCS2Screen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
        title: Text(
          localizations.outbound_equipment_qr_scan,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Helvetica Neue',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () async {
            await _stopSound();
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Container(
                decoration: const BoxDecoration(
                  color: Colors.red, // background color
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.warning_amber_rounded, // warning/error icon
                  color: Colors.white,
                ),
              ),                          
              onPressed: () {
                // Action when pressed
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [            
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          await _stopSound();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(70, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: Text(
                          localizations.back,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Helvetica Neue',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Main content centered in the middle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.forklift, size: 80), // フォークリフト代替アイコン
                      const SizedBox(height: 20),
                      TextField(
                        controller: _qrController,
                        focusNode: _qrFocusNode,
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: localizations.qr_code,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        localizations.scan_outbound_equipment_qr,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.auto_navigate_after_scan,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Add touch area at bottom right of screen
          Positioned(
            bottom: 0,
            right: 0,
            width: 120, // Fixed width for right side only
            height: 100, // Bottom 100px of screen
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _onQrCodeEntered,
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
