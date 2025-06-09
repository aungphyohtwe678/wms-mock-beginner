import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu1.dart';

class TanaoroshiScreen extends StatefulWidget {
  final int currentStep;

  const TanaoroshiScreen({super.key, this.currentStep = 1});

  @override
  State<TanaoroshiScreen> createState() => _TanaoroshiScreenState();
}

class _TanaoroshiScreenState extends State<TanaoroshiScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  final FocusNode _step1Focus = FocusNode();
  final FocusNode _step2Focus = FocusNode();
  final FocusNode _step3Focus = FocusNode();
  final TextEditingController _step1Controller = TextEditingController();
  final TextEditingController _step2Controller = TextEditingController();
  final TextEditingController _step3Controller = TextEditingController();
  final TextEditingController _shohinController2 = TextEditingController();

  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false, false, false];
  bool _showModal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/kakuno.ogg'));
      FocusScope.of(context).requestFocus(_step1Focus);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _step1Focus.dispose();
    _step2Focus.dispose();
    _step2Controller.dispose();
    super.dispose();
  }

  Future<void> _playStepSound(int stepIndex) async {
    final soundMap = {
      1: 'sounds/tanaoroshi-syohin.ogg',
      2: 'sounds/suryo-nyuryoku.ogg',
      3: 'sounds/tanaoroshi-kanryo.ogg',
    };
    if (soundMap.containsKey(stepIndex)) {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(soundMap[stepIndex]!));
    }
  }

  int _currentCycle = 1;

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
                          '棚卸',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Helvetica Neue',
                          ),
                        ),
                        centerTitle: true,
                        actions: [PopupMenuButton<int>(
    icon: const Icon(Icons.notifications, color: Colors.white),
    offset: const Offset(0, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    itemBuilder: (context) => [
      PopupMenuItem(
        enabled: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              ' 通知',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Helvetica Neue',
              ),
            ),
            SizedBox(height: 10),
            Text(
              '2025/6/XX 16:00 XXXXXXX',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '2025/6/XX 15:00 YYYYYYY',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '2025/6/XX 14:00 ZZZZZZZ',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ],
  ),
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
                                        visible: widget.currentStep == 1 && !_stepCompleted[0] && (_currentCycle == 1 || _stepCompleted.every((e) => !e)),
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) => const MenuScreen(
                                                  initialSelectedIndex: 3,
                                                ),
                                                transitionDuration: Duration.zero,
                                              ),
                                            );
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
                                      OutlinedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _currentCycle = 2;
                                            _stepCompleted = [false, false, false, false, false, false];
                                            _expandedStep = 0;
                                            _step1Controller.clear();
                                            _step2Controller.clear();
                                            _step3Controller.text = '5';
                                          });
                                          await Future.delayed(const Duration(milliseconds: 300));
                                          FocusScope.of(context).requestFocus(_step1Focus);
                                          await _audioPlayer.play(AssetSource('sounds/kakuno2.ogg'));
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
                                          'スキップ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Helvetica Neue',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '棚卸件数：$_currentCycle/2',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Helvetica Neue',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _buildStep(
                                  stepIndex: 0,
                                  title: '棚卸対象ロケーション確認・スキャン',
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      _currentCycle == 1 ? '03-003-1' : '03-003-2',
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
                                        controller: _step1Controller,
                                        focusNode: _step1Focus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          setState(() {
                                            _stepCompleted[0] = true;
                                            _expandedStep = 1;
                                          });
                                          await _playStepSound(1);
                                          await Future.delayed(const Duration(milliseconds: 300));
                                          FocusScope.of(context).requestFocus(_step2Focus);
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
                                _buildStep(
                                  stepIndex: 1,
                                  title: '商品スキャン・数量確認',
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: 
                                      Text(
                                        _currentCycle == 1 ? 'ビーフリード輸液 500mL × 20袋' : 'エルネオパNF2号輸液 1000mL × 10袋',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Helvetica Neue',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: TextField(
                                        controller: _step2Controller,
                                        focusNode: _step2Focus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _playStepSound(2);
                                          if (_currentCycle == 1) {
                                            _shohinController2.text = 'MMY2025M5D00XX';
                                            _step3Controller.text = '3';
                                          } else if (_currentCycle == 2) {
                                            _shohinController2.text = 'ZZY2025M5D01YY';
                                            _step3Controller.text = '5';
                                          }                                
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'バーコードをスキャン',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                      Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                      child: TextField(
                                        controller: _shohinController2,
                                        readOnly: true, // ← 非活性にする
                                        decoration: const InputDecoration(
                                          hintText: 'ロット',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 132, vertical: 8),
                                      child: TextField(
                                        controller: _step3Controller,
                                        focusNode: _step3Focus,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
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
                                    SizedBox(
                                      width: 344,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _stepCompleted[2] = true;
                                            _expandedStep = -1;
                                          });

                                          if (_currentCycle == 1) {
                                            setState(() => _showModal = true);
                                            await Future.delayed(const Duration(seconds: 1));
                                            await _playStepSound(3);
                                            await Future.delayed(const Duration(seconds: 2));
                                            setState(() => _showModal = false);
                                            setState(() {
                                              _currentCycle = 2;
                                              _stepCompleted = [false, false, false, false, false, false];
                                              _expandedStep = 0;
                                              _step1Controller.clear();
                                              _step2Controller.clear();
                                              _step3Controller.clear();
                                              _shohinController2.clear();
                                            });
                                            await Future.delayed(const Duration(milliseconds: 300));
                                            FocusScope.of(context).requestFocus(_step1Focus);
                                            await _audioPlayer.play(AssetSource('sounds/kakuno2.ogg'));
                                          } else {
                                            setState(() => _showModal = true);
                                            await Future.delayed(const Duration(seconds: 1));
                                            await _playStepSound(3);
                                            await Future.delayed(const Duration(seconds: 2));
                                            setState(() => _showModal = false);
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) => const MenuScreen(
                                                  initialSelectedIndex: 3,
                                                ),
                                                transitionDuration: Duration.zero,
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('数量確定'),
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
                                  Text('棚卸完了', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
