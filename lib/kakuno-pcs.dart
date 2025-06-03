import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/sub-menu2.dart';

class KakunoPCSScreen extends StatefulWidget {
  final int currentStep;

  const KakunoPCSScreen({super.key, this.currentStep = 1});

  @override
  State<KakunoPCSScreen> createState() => _KakunoPCSScreenState();
}

class _KakunoPCSScreenState extends State<KakunoPCSScreen> {
  final TextEditingController _asnController1 = TextEditingController();
  final TextEditingController _asnController2 = TextEditingController();
  final FocusNode _step1Focus = FocusNode();
  final FocusNode _step2Focus = FocusNode();
  final FocusNode _step3Focus = FocusNode();
  final FocusNode _liftFocus = FocusNode();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _shohinController = TextEditingController();

  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false];
  bool _showModal = false;
  int _currentStep = 1;
  int _scanCount = 0;
  final List<int> targetCounts = [4, 2, 5];
  final List<String> kakunoVoices = [
    'sounds/kakuno.ogg',
    'sounds/kakuno2.ogg',
    'sounds/kakuno3.ogg',
  ];
  final List<String> locationList = ['03-003-01', '03-003-02', '03-003-03'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      await _audioPlayer.play(AssetSource('sounds/pl-meisai.ogg'));
      FocusScope.of(context).requestFocus(_step2Focus);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _asnController1.dispose();
    _asnController2.dispose();
    _step1Focus.dispose();
    _step2Focus.dispose();
    _step3Focus.dispose();
    _liftFocus.dispose();
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
                                      Visibility(
                                        visible: _currentStep == 1 && !_stepCompleted[0],
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context, 1);
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '格納件数：$_currentStep/3',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Helvetica Neue',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _buildStep(
                                  stepIndex: 0,
                                  title: 'パレット明細ラベルスキャン',
                                  children: [
                                    const SizedBox(height: 10),
                                    FractionallySizedBox(
                                      widthFactor: 0.8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/images/pl-meisai-label.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: TextField(
                                        focusNode: _step2Focus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          setState(() {
                                            _stepCompleted[0] = true;
                                            _expandedStep = 1;
                                          });
                                          await _audioPlayer.play(AssetSource(kakunoVoices[_currentStep - 1]));
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            FocusScope.of(context).requestFocus(_step2Focus);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'パレット明細ラベルをスキャン',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 1,
                                  title: '格納ロケーション確認',
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      locationList[_currentStep - 1],
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontFamily: 'Helvetica Neue',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: TextField(
                                        focusNode: _step2Focus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          setState(() {
                                            _stepCompleted[1] = true;
                                            _expandedStep = 2;
                                          });
                                          await _audioPlayer.play(AssetSource('sounds/syohin-zensu.ogg'));
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            FocusScope.of(context).requestFocus(_step3Focus);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'ロケーションバーコードをスキャン',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    FractionallySizedBox(
                                      widthFactor: 0.8,
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/images/map3.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    FractionallySizedBox(
                                      widthFactor: 0.9,
                                      child: GestureDetector(
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
                                _buildStep(
                                  stepIndex: 2,
                                  title: '商品バーコード再スキャン',
                                  children: [
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: TextField(
                                        controller: _shohinController,
                                        focusNode: _step3Focus,
                                        onSubmitted: (_) async {
                                          if (_scanCount < targetCounts[_currentStep - 1]) {
                                            await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                            await Future.delayed(const Duration(milliseconds: 500));
                                            await _audioPlayer.play(AssetSource('sounds/kakuno-zansu.ogg'));
                                            setState(() {
                                              _scanCount++;
                                              _shohinController.clear();
                                            });

                                            // 再フォーカス
                                            await Future.delayed(const Duration(milliseconds: 100));
                                            FocusScope.of(context).requestFocus(_step3Focus);

                                            if (_scanCount >= targetCounts[_currentStep - 1]) {
                                              if (_currentStep >= 3) {
                                                await Future.delayed(const Duration(milliseconds: 500));
                                                setState(() => _showModal = true);
                                                await Future.delayed(const Duration(milliseconds: 500));
                                                await _audioPlayer.play(AssetSource('sounds/kakuno-kanryo.ogg'));
                                                await Future.delayed(const Duration(seconds: 2));
                                                if (!mounted) return;
                                                setState(() => _showModal = false);
                                                Navigator.pushReplacement(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (_, __, ___) => const SubMenu2Screen(),
                                                    transitionDuration: Duration.zero,
                                                  ),
                                                );
                                              } else {
                                                await Future.delayed(const Duration(milliseconds: 500));
                                                setState(() => _showModal = true);
                                                await Future.delayed(const Duration(milliseconds: 500));
                                                await _audioPlayer.play(AssetSource('sounds/kakuno-kanryo.ogg'));
                                                await Future.delayed(const Duration(seconds: 2));
                                                final next = _currentStep + 1;
                                                setState(() {
                                                  _currentStep = next;
                                                  _scanCount = 0;
                                                  _stepCompleted = [false, false, false, false];
                                                  _expandedStep = 0;
                                                  _showModal = false;
                                                });
                                                await _audioPlayer.play(AssetSource('sounds/pl-meisai.ogg'));
                                                await Future.delayed(const Duration(milliseconds: 300));
                                                FocusScope.of(context).requestFocus(_step2Focus);
                                              }
                                            }
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'バーコードをスキャン',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$_scanCount / ${targetCounts[_currentStep - 1]} 個',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'Helvetica Neue',
                                        fontWeight: FontWeight.bold,
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
                                          'assets/images/syohin2.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
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
                                  Text('格納完了', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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