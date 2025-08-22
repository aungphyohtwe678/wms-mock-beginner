import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/archive/pickking8.dart';

import '../l10n/app_localizations.dart';

class PickkingStart4Screen extends StatefulWidget {
  final int currentStep;

  const PickkingStart4Screen({super.key, this.currentStep = 1});

  @override
  State<PickkingStart4Screen> createState() => _PickkingStart4ScreenState();
}

class _PickkingStart4ScreenState extends State<PickkingStart4Screen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _liftScanFocusNode = FocusNode();
  late String _destination;

  final List<String> destinations = [
    '04-004-11',
    '04-004-12',
    '04-004-13',
    '04-004-14',
  ];

  final List<String> sounds = [
    'sounds/pic-start4.ogg',
    'sounds/pic-start5.ogg',
    'sounds/pic-start6.ogg',
    'sounds/pic-start7.ogg',
  ];

  @override
  void initState() {
    super.initState();
    _destination = destinations[widget.currentStep - 1];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource(sounds[widget.currentStep - 1]));
      FocusScope.of(context).requestFocus(_liftScanFocusNode);
    });
    _liftScanFocusNode.addListener(() {
      if (!_liftScanFocusNode.hasFocus) {
        _onImageTapped();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _liftScanFocusNode.dispose();
    super.dispose();
  }

  void _onImageTapped() async {
    await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Pickking8Screen(currentStep: widget.currentStep),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapAsset = 'assets/images/map3.png';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.zero,
                ),
                clipBehavior: Clip.antiAlias,
                child: SafeArea(
                  child: ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Colors.black,
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.5),
                        title: Text(
                          AppLocalizations.of(context)!.picking,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Helvetica Neue',
                          ),
                        ),
                        centerTitle: true,
                        actions: [PopupMenuButton<int>(
    icon: const Icon(Icons.notifications, color: Colors.white),
    offset: const Offset(0, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    itemBuilder: (context) => [
      PopupMenuItem(
        enabled: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.notifications,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Helvetica Neue',
              ),
            ),
            SizedBox(height: 10),
            Text(
              '2025/6/XX 16:00 XXXXXXX',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '2025/6/XX 15:00 YYYYYYY',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '2025/6/XX 14:00 ZZZZZZZ',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ],
  ),
                          PopupMenuButton<int>(
                            icon: const Icon(Icons.person, color: Colors.white),
                            offset: const Offset(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                enabled: false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.general_worker("山田 太郎"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Helvetica Neue',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(AppLocalizations.of(context)!.logout),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(AppLocalizations.of(context)!.accident_report),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      body: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            '${widget.currentStep}/4',
                            style: const TextStyle(
                              fontSize: 25,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.box_size("K3"),
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            AppLocalizations.of(context)!.pick_location,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Helvetica Neue',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _destination,
                            style: const TextStyle(
                              fontSize: 48,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: TextField(
                              focusNode: _liftScanFocusNode,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.scan_location_barcode,
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                mapAsset,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FractionallySizedBox(
                            widthFactor: 0.9,
                            child: GestureDetector(
                              onTap: _onImageTapped,
                              child: Container(
                                height: 400,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/tana-location.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
