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
  String _modalText = '撮影中...';  
  bool _showTsumitsuke = false;
  final productList = [
    '生食注シリンジ「オーツカ」20mL',
    '生食注シリンジ「オーツカ」10mL',
    '生食注シリンジ「オーツカ」5mL',
    'ヘパリンNaロック用シリンジ10mL'
  ];

  final quantityList = ['４個', '６個 / Y2025M05D00', '５個', '２個'];

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
          _scannedCount = 1;
        });
        await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
        await Future.delayed(const Duration(milliseconds: 500));

        final oggFiles = ['4.ogg', '6.ogg', '5.ogg', '2.ogg'];
        final fileName = oggFiles[widget.currentStep - 1];
        await _audioPlayer.play(AssetSource('sounds/$fileName'));
        await Future.delayed(const Duration(milliseconds: 800));

        if (widget.currentStep == 2) {
          await _audioPlayer.play(AssetSource('sounds/rotto.ogg'));
          await Future.delayed(const Duration(milliseconds: 1500));
        }

        await _audioPlayer.play(AssetSource('sounds/zensu.ogg'));
        FocusScope.of(context).requestFocus(_liftScanFocusNode);
      }
    });
  }

  int _scannedCount = 0;
  int get _targetCount {
    final counts = [4, 6, 5, 2];
    return counts[widget.currentStep - 1];
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _liftScanFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stepText = '${widget.currentStep}/4';
    final productName = productList[widget.currentStep - 1];
    final hakodumeImage = 'assets/images/hakodume${widget.currentStep}.png';
    final cameraImage = 'assets/images/camera-${widget.currentStep}.png';

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
                      body: SingleChildScrollView(child: 
                       Column(
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
                              fontSize: 20,
                              fontFamily: 'Helvetica Neue',
                              color: Colors.black,
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
                              onSubmitted: (_) async {
                                if (!_showTsumitsuke) return;

                                // 毎回のスキャンで音を鳴らす
                                await _audioPlayer.play(AssetSource('sounds/pi.ogg'));

                                setState(() {
                                  _scannedCount++;
                                });

                                if (_scannedCount < _targetCount) {
                                  // 🔑 フォーカスを維持（再フォーカス）
                                  FocusScope.of(context).requestFocus(_liftScanFocusNode);
                                  return;
                                }

                                setState(() {
                                  _showModal = true;
                                });

                                if (_scannedCount >= _targetCount) {
                                  await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                  setState(() {
                                    _showModal = true;
                                    _modalText = '3';
                                  });
                                  await Future.delayed(const Duration(seconds: 1));

                                  setState(() {
                                    _modalText = '2';
                                  });
                                  await Future.delayed(const Duration(seconds: 1));

                                  setState(() {
                                    _modalText = '1';
                                  });
                                  await Future.delayed(const Duration(seconds: 1));

                                  // 「撮影中...」と音声を同時に開始
                                  setState(() {
                                    _modalText = '撮影中...';
                                  });
                                  await Future.wait([
                                    _audioPlayer.play(AssetSource('sounds/satuei.ogg')),
                                    Future.delayed(const Duration(seconds: 1)),
                                  ]);

                                  // 表示が4画面目（4ステップ目）のときだけ再生
                                  if (widget.currentStep == 4) {
                                    await _audioPlayer.play(AssetSource('sounds/label-harituke.ogg'));
                                    await Future.delayed(const Duration(milliseconds: 3500));
                                  }

                                  setState(() {
                                    _modalText = 'ピック完了';
                                  });

                                  await Future.delayed(const Duration(milliseconds: 1000));

                                  await _audioPlayer.play(AssetSource('sounds/pic-kanryo.ogg'));

                                  await Future.delayed(const Duration(milliseconds: 2000));

                                  if (!mounted) return;
                                  setState(() {
                                    _showModal = false;
                                  });

                                  if (widget.currentStep >= 4) {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => const MenuScreen(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            PickkingStart4Screen(currentStep: widget.currentStep + 1),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
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
                                        'assets/images/syohin2.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '$_scannedCount / $_targetCount 個',
                              style: const TextStyle(
                                fontSize: 25,
                                fontFamily: 'Helvetica Neue',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (widget.currentStep == 2) ...[
                              const SizedBox(height: 4),
                              const Text(
                                'Y2025M05D00',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Helvetica Neue',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            const Text(
                              '図のように箱詰め',
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
                            FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Container(
                                height: 600,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // 背景の縦長黒長方形
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),

                                    // カメラビュー テキストを topCenter に配置
                                    Positioned(
                                      top: 8,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Text(
                                          'カメラビュー',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 18,
                                            fontFamily: 'Helvetica Neue',
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 画像（中央に配置）
                                    Container(
                                      width: double.infinity,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(cameraImage),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.2),
                                            BlendMode.darken,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
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
                    children: [
                      Text(
                        _modalText,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica Neue',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(
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
