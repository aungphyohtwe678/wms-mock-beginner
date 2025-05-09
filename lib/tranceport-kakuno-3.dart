import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu.dart';

class KakunoLocatinoScreen2 extends StatefulWidget {
  final int currentStep;

  const KakunoLocatinoScreen2({super.key, required this.currentStep});

  @override
  State<KakunoLocatinoScreen2> createState() => _KakunoLocatinoScreen2State();
}

class _KakunoLocatinoScreen2State extends State<KakunoLocatinoScreen2> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _liftScanFocusNode = FocusNode();
  late String _destination;
  bool _showModal = false;

  final List<String> _destinations = List.generate(9, (i) {
    return List.generate(9, (j) {
      return '03-003-01';
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
    setState(() => _showModal = true);
    await Future.delayed(const Duration(milliseconds: 500));
    await _audioPlayer.play(AssetSource('sounds/kakuno-kanryo.ogg'));
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MenuScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
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
              if (_showModal)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '格納完了',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica Neue',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}