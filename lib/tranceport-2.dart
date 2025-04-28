import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class LiftScanScreen extends StatefulWidget {
  final int currentStep;

  const LiftScanScreen({super.key, required this.currentStep});

  @override
  State<LiftScanScreen> createState() => _LiftScanScreenState();
}

class _LiftScanScreenState extends State<LiftScanScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _liftScanFocusNode = FocusNode(); // ★追加
  late String _destination;

  final List<String> _destinations = [
    'A昇降機①', 'A昇降機②', 'A昇降機③', 'A昇降機④', 'A昇降機⑤',
    'B昇降機①', 'B昇降機②', 'B昇降機③', 'B昇降機④', 'B昇降機⑤',
    'C昇降機①', 'C昇降機②', 'C昇降機③', 'C昇降機④', 'C昇降機⑤',
    'D昇降機①', 'D昇降機②', 'D昇降機③', 'D昇降機④', 'D昇降機⑤',
    'E昇降機①', 'E昇降機②', 'E昇降機③', 'E昇降機④', 'E昇降機⑤',
  ];

  @override
  void initState() {
    super.initState();
    final random = Random();
    _destination = _destinations[random.nextInt(_destinations.length)];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/hanso.ogg'));
      FocusScope.of(context).requestFocus(_liftScanFocusNode); // ★ここでフォーカス
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _liftScanFocusNode.dispose(); // ★必ずdispose
    super.dispose();
  }

  void _onImageTapped() {
    Navigator.pop(context, 'clear'); // ★戻るときもアニメーションなし
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: const Text(
                  '搬送',
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
                    itemBuilder: (context) => [],
                  ),
                ],
              ),
              body: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 80), // 戻るボタンなし、スペースだけ確保
                        Text(
                          '${widget.currentStep}/5',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontFamily: 'Helvetica Neue',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Colors.black),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            '搬送先',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Helvetica Neue',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _destination,
                            style: const TextStyle(
                              fontSize: 50,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            child: TextField(
                              focusNode: _liftScanFocusNode, // ★ここ
                              decoration: const InputDecoration(
                                hintText: '昇降機のQRコードをスキャン',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: _onImageTapped,
                            child: Container(
                              width: double.infinity,
                              height: 400,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                'assets/images/syokoki.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
