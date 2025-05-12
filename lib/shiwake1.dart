import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu.dart';

class ShiwakeStartScreen extends StatefulWidget {
  final int currentStep;

  const ShiwakeStartScreen({super.key, this.currentStep = 1});

  @override
  State<ShiwakeStartScreen> createState() => _ShiwakeStartScreenState();
}

class _ShiwakeStartScreenState extends State<ShiwakeStartScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final FocusNode _motoFocus = FocusNode();
  final FocusNode _sakiFocus = FocusNode();
  final FocusNode _shohinFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _saki2Focus = FocusNode();

  final TextEditingController _quantityController = TextEditingController(text: '1');

  int _step = 1;
  bool _showItemScan = false;
  bool _showQuantityAndSecondScan = false;
  bool _showModal = false;

  int _shohinCount = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/shiwake-moto.ogg'));
      FocusScope.of(context).requestFocus(_motoFocus);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _motoFocus.dispose();
    _sakiFocus.dispose();
    _shohinFocus.dispose();
    _quantityFocus.dispose();
    _saki2Focus.dispose();
    _quantityController.dispose();
    super.dispose();
  }

Future<void> _handleStepProgress() async {
  switch (_step) {
    case 1:
      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
      await Future.delayed(const Duration(milliseconds: 500));
      await _audioPlayer.play(AssetSource('sounds/shiwake-saki.ogg'));
      FocusScope.of(context).requestFocus(_sakiFocus);
      break;

    case 2:
      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
      await Future.delayed(const Duration(milliseconds: 500));
      await _audioPlayer.play(AssetSource('sounds/shiwake-zenpin.ogg'));
      setState(() {
        _showItemScan = true;
      });
      FocusScope.of(context).requestFocus(_shohinFocus);
      break;
    case 4:
      // 数量カウント終了後、再スキャンへ
      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
      await Future.delayed(const Duration(milliseconds: 500));
      await _audioPlayer.play(AssetSource('sounds/shiwake-saki2.ogg'));
      FocusScope.of(context).requestFocus(_saki2Focus);
      break;

    case 5:
      setState(() {
        _showModal = true;
      });
      await _audioPlayer.play(AssetSource('sounds/shiwake-kanryo.ogg'));
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MenuScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      break;
  }
  _step++;
}
  @override
  Widget build(BuildContext context) {
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
                          '仕分け',
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
                      body: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      widget.currentStep == 1
                                          ? OutlinedButton(
                                              onPressed: () {
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
                                              child: const Text(
                                                '戻る',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Helvetica Neue',
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: TextField(
                                    focusNode: _motoFocus,
                                    onSubmitted: (_) => _handleStepProgress(),
                                    decoration: const InputDecoration(
                                      hintText: '載せ替え元のASNラベルをスキャン',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: TextField(
                                    focusNode: _sakiFocus,
                                    onSubmitted: (_) => _handleStepProgress(),
                                    decoration: const InputDecoration(
                                      hintText: '載せ替え先のASNラベルをスキャン',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/images/asn-qr2.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (!_showItemScan) ...[
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 344,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'ASNラベルを発行する',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Helvetica Neue',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                if (_showItemScan) ...[
                                  const SizedBox(height: 10),
                                  FractionallySizedBox(
                                    widthFactor: 0.8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.asset(
                                        'assets/images/syohin.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32),
                                    child: TextField(
                                      focusNode: _shohinFocus,
                                      onSubmitted: (_)  async {
                                        await _audioPlayer.play(AssetSource('sounds/pi.ogg')); // 音を鳴らす
                                        setState(() {
                                          _showQuantityAndSecondScan = true;
                                          _shohinCount = 1;
                                          _quantityController.text = '1';
                                        });
                                        Future.delayed(const Duration(milliseconds: 100), () {
                                          FocusScope.of(context).requestFocus(_quantityFocus);
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        hintText: '商品をスキャン',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                                if (_showQuantityAndSecondScan) ...[
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 122),
                                    child: Row(
                                      children: [
                                        const Text(
                                          '数量：',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextField(
                                            controller: _quantityController,
                                            focusNode: _quantityFocus,
                                            readOnly: true,
                                            onEditingComplete: () async {
                                              await _audioPlayer.play(AssetSource('sounds/pi.ogg')); // 音を鳴らす

                                              if (_shohinCount < 12) {
                                                setState(() {
                                                  _shohinCount++;
                                                  _quantityController.text = _shohinCount.toString();
                                                });

                                                // フォーカスを保持
                                                Future.delayed(const Duration(milliseconds: 100), () {
                                                  FocusScope.of(context).requestFocus(_quantityFocus);
                                                });
                                              }

                                              if (_shohinCount >= 12) {
                                                // 数量完了 → 次のステップへ
                                                setState(() {
                                                  _step = 4;
                                                });
                                                Future.delayed(const Duration(milliseconds: 100), () {
                                                  _handleStepProgress();
                                                });
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Helvetica Neue',
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          ' / 12',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Helvetica Neue',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32),
                                    child: TextField(
                                      focusNode: _saki2Focus,
                                      onSubmitted: (_) => _handleStepProgress(),
                                      decoration: const InputDecoration(
                                        hintText: 'もう一度、載せ替え先のASNラベルをスキャン',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ],
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
                                    '仕分け完了',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
