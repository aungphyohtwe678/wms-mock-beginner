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
  final TextEditingController _shohinController = TextEditingController();


  int _step = 1;
  bool _showItemScan = false;
  bool _showQuantityAndSecondScan = false;
  bool _showModal = false;

  int _shohinCount = 0;

    int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false];

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
    _shohinController.dispose();
    super.dispose();
  }

  Widget _buildStep({
    required int stepIndex,
    required String title,
    required List<Widget> children,
  }) {
    // 表示条件：直前までのステップが完了している
    if (!_stepCompleted.sublist(0, stepIndex).every((e) => e)) return const SizedBox.shrink();

    // 完了していない現在のステップのみ展開、それ以外は閉じる
    final bool isExpanded = !_stepCompleted[stepIndex] && _expandedStep == stepIndex;

    return ExpansionTile(
      key: ValueKey('step_$stepIndex-$_expandedStep'), // これが重要
      initiallyExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        if (!_stepCompleted[stepIndex]) {
          setState(() {
            _expandedStep = expanded ? stepIndex : -1;
          });
        }
      },
      leading: Icon(
        _stepCompleted[stepIndex] ? Icons.check_circle : Icons.radio_button_unchecked,
        color: _stepCompleted[stepIndex] ? Colors.lightBlue : Colors.grey,
      ),
      title: Text(title),
      children: children,
    );
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
                                      OutlinedButton(
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
                                    ],
                                  ),
                                ),
                                _buildStep(
                                  stepIndex: 0,
                                  title: 'ASN（載せ替え元）スキャン',
                                  children: [
                                   Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                    child: TextField(
                                      focusNode: _motoFocus,
                                      onSubmitted: (_) async {
                                        await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                        setState(() {
                                          _stepCompleted[0] = true;
                                          _expandedStep = 1;
                                        });
                                        await Future.delayed(const Duration(milliseconds: 500));
                                        await _audioPlayer.play(AssetSource('sounds/shiwake-saki.ogg'));
                                        FocusScope.of(context).requestFocus(_sakiFocus);
                                      },
                                      decoration: const InputDecoration(
                                        hintText: '載せ替え元のASNラベルをスキャン',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 450,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.asset(
                                        'assets/images/asn-qr.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 1,
                                  title: 'ASN（載せ替え先）スキャン',
                                  children: [
                                    Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                    child: TextField( 
                                        focusNode: _sakiFocus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          setState(() {
                                            _stepCompleted[1] = true;
                                            _expandedStep = 2;
                                            _showItemScan = true;
                                          });
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _audioPlayer.play(AssetSource('sounds/shiwake-zenpin.ogg'));
                                          FocusScope.of(context).requestFocus(_shohinFocus);
                                        },
                                        decoration: const InputDecoration(
                                        hintText: '載せ替え先のASNラベルをスキャン',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white,
                                      )
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 450,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.asset(
                                        'assets/images/asn-qr.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 2,
                                  title: '商品・数量確認',
                                  children: [
                                    if (_showItemScan) 
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                              child: TextField( 
                                                controller: _shohinController,
                                                focusNode: _shohinFocus,
                                                onSubmitted: (_) async {
                                                  await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                                  if (!_showQuantityAndSecondScan) {
                                                    setState(() => _showQuantityAndSecondScan = true);
                                                  }
                                                  setState(() {
                                                    _shohinCount++;
                                                    _quantityController.text = _shohinCount.toString();
                                                  });
                                                  if (_shohinCount >= 12) {
                                                    setState(() {
                                                      _showModal = true;
                                                      _stepCompleted[2] = true;
                                                      _expandedStep = 3;
                                                    });
                                                    await Future.delayed(const Duration(milliseconds: 500));
                                                    await _audioPlayer.play(AssetSource('sounds/shiwake-kanryo.ogg'));
                                                    await Future.delayed(const Duration(seconds: 2));
                                                    if (!mounted) return;
                                                    Navigator.pushReplacement(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (_, __, ___) => const MenuScreen(),
                                                        transitionDuration: Duration.zero,
                                                      ),
                                                    );
                                                  } else {
                                                    _shohinController.clear();
                                                    FocusScope.of(context).requestFocus(_shohinFocus);
                                                  }
                                                },
                                                decoration: const InputDecoration(
                                                  hintText: '商品をスキャン',
                                                  border: OutlineInputBorder(),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              ),
                                            ),
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
                                            if (_showQuantityAndSecondScan)
                                            Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(width: 62), // 左側余白調整（任意）
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                  child: TextField(
                                                    controller: _quantityController,
                                                    focusNode: _quantityFocus,
                                                    readOnly: true,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(fontSize: 25),
                                                    decoration: const InputDecoration(
                                                      hintText: '数量',
                                                      border: OutlineInputBorder(),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(' / 12', style: TextStyle(fontSize: 25)),
                                              const SizedBox(width: 62), // 右側余白調整（任意）
                                            ],
                                            )
                                          ],
                                        ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (_showModal)
                            Container(
                              color: Colors.white.withOpacity(0.9),
                              alignment: Alignment.center,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('仕分け完了', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  CircularProgressIndicator(),
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
