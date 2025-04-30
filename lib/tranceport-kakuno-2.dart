import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class KakunoLocatinoScreen extends StatefulWidget {
  final int currentStep;

  const KakunoLocatinoScreen({super.key, required this.currentStep});

  @override
  State<KakunoLocatinoScreen> createState() => _KakunoLocatinoScreenState();
}

class _KakunoLocatinoScreenState extends State<KakunoLocatinoScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _liftScanFocusNode = FocusNode();
  late String _destination;

  final List<String> _destinations = List.generate(9, (i) {
    final block = (i + 1).toString().padLeft(3, '0');
    return List.generate(9, (j) {
      final number = (j + 1).toString().padLeft(2, '0');
      return '03-$block-$number';
    });
  }).expand((list) => list).toList();

  @override
  void initState() {
    super.initState();
    final random = Random();
    _destination = _destinations[random.nextInt(_destinations.length)];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/kakuno.ogg'));
      FocusScope.of(context).requestFocus(_liftScanFocusNode);
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
    Navigator.pop(context, 'clear');
  }

  @override
  Widget build(BuildContext context) {
    // 末尾の「-01」〜「-09」を抽出
    final mapNumber = int.tryParse(_destination.split('-').last) ?? 1;
    final mapAsset = 'assets/images/map$mapNumber.png';

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
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.5),
                title: const Text(
                  '格納',
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
                  const SizedBox(height: 24),
                  const Text(
                    '格納ロケーション',
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
                    widthFactor: 0.8,
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
                            Image.asset(
                              'assets/images/location-code.png',
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
    );
  }
}
