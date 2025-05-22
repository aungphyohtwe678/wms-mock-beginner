import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu.dart';

class PickkingPLScreen extends StatefulWidget {
  final int currentStep;

  const PickkingPLScreen({super.key, this.currentStep = 1});

  @override
  State<PickkingPLScreen> createState() => _PickkingPLScreenState();
}

class _PickkingPLScreenState extends State<PickkingPLScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false, false];
  bool _showModal = false;
  bool _step2CountdownStarted = false;
  int _repeatCount = 1;

  final FocusNode _step1Focus = FocusNode();
  final FocusNode _step2Focus = FocusNode();
  final FocusNode _step3Focus = FocusNode();
  final FocusNode _step4Focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/pic-start.ogg'));
      FocusScope.of(context).requestFocus(_step1Focus);
    });
  }

  Future<void> _playStepSound(int stepIndex) async {
    final soundMap = {
      1: 'sounds/pic-syohin.ogg',
      2: 'sounds/pic-kanpare.ogg',
      3: 'sounds/asn-scan.ogg',
    };
    if (soundMap.containsKey(stepIndex)) {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(soundMap[stepIndex]!));
    }
  }

  Widget _buildStep({
    required int stepIndex,
    required String title,
    required List<Widget> children,
  }) {
    if (!_stepCompleted.sublist(0, stepIndex).every((e) => e)) return const SizedBox.shrink();

    final bool isExpanded = !_stepCompleted[stepIndex] && _expandedStep == stepIndex;

    return ExpansionTile(
      key: ValueKey('step_$stepIndex-$_expandedStep'),
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
  void _requestFocusForExpandedStep() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      switch (_expandedStep) {
        case 0:
          FocusScope.of(context).requestFocus(_step1Focus);
          break;
        case 1:
          FocusScope.of(context).requestFocus(_step2Focus);
          break;
        case 2:
          FocusScope.of(context).requestFocus(_step3Focus);
          break;
        case 3:
          FocusScope.of(context).requestFocus(_step4Focus);
          break;
      }
    });
  }

  void _onImageTapped() async {
    await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
    await Future.delayed(const Duration(milliseconds: 500));
    await _audioPlayer.play(AssetSource('sounds/pl-himoduke.ogg'));
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _showModal = true;
    });

    await _audioPlayer.play(AssetSource('sounds/pic-kanryo.ogg'));
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    if (_repeatCount < 2) {
      // 🔁 2回目へ進む
      setState(() {
        _repeatCount++;
        _showModal = false;
        _stepCompleted = [true, false, false, false, false];
        _expandedStep = 1;
        _step2CountdownStarted = false;
      });
      _requestFocusForExpandedStep();
      await _audioPlayer.play(AssetSource('sounds/pic-syohin.ogg')); // 初めに戻る音
    } else {
      // ✅ 完了処理
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
  }

  Future<void> _startCountdownStep2() async {
    for (int i = 2; i >= 1; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
    }
    await _playStepSound(3);
    setState(() {
      _stepCompleted[2] = true;  // step 2 完了
      _expandedStep = 3;         // step 3 を展開
    });
    _requestFocusForExpandedStep();
  }


  @override
  Widget build(BuildContext context) {
    final mapAsset = 'assets/images/map3.png';
    if (_expandedStep == 2 && !_stepCompleted[2] && !_step2CountdownStarted) {
      _step2CountdownStarted = true;
      _startCountdownStep2();
    }

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
                    body: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildStep(
                              stepIndex: 0,
                              title: 'ピックロケーション確認',
                              children: [
                                const SizedBox(height: 24),
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
                                  '02-001-04',
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
                                    focusNode: _step1Focus,
                                    onSubmitted: (_) async {
                                      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      _playStepSound(1);
                                      setState(() {
                                        _stepCompleted[0] = true;
                                        _expandedStep = 1;
                                      });
                                      _requestFocusForExpandedStep();
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'ロケーションバーコードをスキャン',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                                )
                              ],
                            ),
                            _buildStep(
                              stepIndex: 1,
                              title: '商品スキャン',
                              children: [
                                Text(
                                  'ビーフリード輸液500ml',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Helvetica Neue',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: TextField(
                                    focusNode: _step2Focus,
                                    decoration: const InputDecoration(
                                      hintText: '商品のバーコードをスキャン',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    onSubmitted: (_) async {
                                      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      _playStepSound(2);
                                      setState(() {
                                        _stepCompleted[1] = true;
                                        _expandedStep = 2;
                                      });
                                      _requestFocusForExpandedStep();
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
                                            'assets/images/syohin.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ]
                            ),
                            _buildStep(
                              stepIndex: 2,
                              title: '数量確認',
                              children: [
                                const Text(
                                  '32ケース（完パレ）',
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            _buildStep(
                              stepIndex: 3,
                              title: 'ASNラベルスキャン',
                              children: [
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
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: TextField(
                                    focusNode: _step4Focus,
                                    onSubmitted: (_) => _onImageTapped(),
                                    decoration: const InputDecoration(
                                      hintText: 'ASNラベルをスキャン',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
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
                                  )
                                ),
                                const SizedBox(height: 10),
                              ]
                            ),
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
