import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu.dart';
import 'package:otk_wms_mock/pickking4.dart';

class Pickking8Screen extends StatefulWidget {
  final int currentStep;

  const Pickking8Screen({super.key, this.currentStep = 1});

  @override
  State<Pickking8Screen> createState() => _Pickking8ScreenState();
}

class _Pickking8ScreenState extends State<Pickking8Screen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _liftScanFocusNode = FocusNode();
  bool _showModal = false;
  bool _showTsumitsuke = false;
  final productList = [
    '生食注シリンジ「オーツカ」20mL',
    '生食注シリンジ「オーツカ」10mL',
    '生食注シリンジ「オーツカ」5mL',
    'ヘパリンNaロック用シリンジ10mL'
  ];

  final quantityList = ['４個', '６個', '５個', '２個'];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).requestFocus(_liftScanFocusNode);
      await _audioPlayer.play(AssetSource('sounds/pic-syohin.ogg'));
    });

    _liftScanFocusNode.addListener(() async {
      if (!_liftScanFocusNode.hasFocus && !_showTsumitsuke) {
        setState(() {
          _showTsumitsuke = true;
        });
        await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
        await Future.delayed(const Duration(milliseconds: 500));
        await _audioPlayer.play(AssetSource('sounds/pic-next.ogg'));
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
    if (widget.currentStep >= 4) {
      setState(() {
        _showModal = true;
      });
      await _audioPlayer.play(AssetSource('sounds/pic-kanryo.ogg'));
      await Future.delayed(const Duration(milliseconds: 2000));

      if (mounted) {
        setState(() {
          _showModal = false;
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MenuScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => PickkingStart4Screen(currentStep: widget.currentStep + 1),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepText = '${widget.currentStep}/4';
    final productName = productList[widget.currentStep - 1];
    final quantityText = quantityList[widget.currentStep - 1];
    final hakodumeImage = 'assets/images/hakodume${widget.currentStep}.png';

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
                            stepText,
                            style: const TextStyle(
                              fontSize: 25,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Helvetica Neue',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            quantityText,
                            style: const TextStyle(
                              fontSize: 25,
                              fontFamily: 'Helvetica Neue',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: TextField(
                              focusNode: _liftScanFocusNode,
                              decoration: const InputDecoration(
                                hintText: '商品のバーコードをスキャン',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          if (!_showTsumitsuke) ...[
                            const SizedBox(height: 10),
                            FractionallySizedBox(
                              widthFactor: 0.9,
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/syohin.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (_showTsumitsuke) ...[
                            const SizedBox(height: 10),
                            const Text(
                              '図のように積みつけ',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Helvetica Neue',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.8,
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        hakodumeImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 344,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  _onImageTapped();
                               },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  '次へ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Helvetica Neue',
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                        'ピック完了',
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
