import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/pickking7.dart';

class PickkingStart6Screen extends StatefulWidget {
  final int currentStep;

  const PickkingStart6Screen({super.key, this.currentStep = 1});

  @override
  State<PickkingStart6Screen> createState() => _PickkingStart6ScreenState();
}

class _PickkingStart6ScreenState extends State<PickkingStart6Screen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _liftScanFocusNode = FocusNode();
  late String _destination;

  final List<String> _destinations = List.generate(9, (i) {
    return List.generate(9, (j) {
      return '04-002-02';
    });
  }).expand((list) => list).toList();

  @override
  void initState() {
    super.initState();
    final random = Random();
    _destination = _destinations[random.nextInt(_destinations.length)];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/pic-start3.ogg'));
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
        pageBuilder: (context, animation, secondaryAnimation) => const Pickking7Screen(),
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
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(40),
                ),
                clipBehavior: Clip.antiAlias,
                child: SafeArea(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.black,
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.5),
                      title: const Text(
                        'ピッキング',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                      centerTitle: true,
                      actions: [
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
                                  const Text(
                                    ' 一般作業者：山田 太郎',
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
                                      child: const Text('ログアウト'),
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
                                      child: const Text('アクシデント報告'),
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
                            '2/2',
                            style: const TextStyle(
                              fontSize: 25,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        const Text(
                          'ピックロケーション',
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
                            decoration: const InputDecoration(
                              hintText: 'ロケーションバーコードをスキャン',
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
                                    'assets/images/kakuno.png',
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
      ),
    );
  }
}

