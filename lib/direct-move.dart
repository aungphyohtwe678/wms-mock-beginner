//PL→CS
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu1.dart';

class DirectMoveScreen extends StatefulWidget {
  final int currentStep;

  const DirectMoveScreen({super.key, this.currentStep = 1});

  @override
  State<DirectMoveScreen> createState() => _DirectMoveScreenState();
}

class _DirectMoveScreenState extends State<DirectMoveScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false, false, false];
  bool _showModal = false;
  bool _step2CountdownStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/pic-loc.ogg'));
      FocusScope.of(context).requestFocus(_step1Focus);
    });
  }
  final FocusNode _step1Focus = FocusNode();
  final FocusNode _step2Focus = FocusNode();
  final FocusNode _step3Focus = FocusNode();
  final FocusNode _step4Focus = FocusNode();
  final FocusNode _step5Focus = FocusNode();
  @override
  void dispose() {
    _audioPlayer.dispose();
    _step1Focus.dispose();
    _step2Focus.dispose();
    _step3Focus.dispose();
    _step4Focus.dispose();
    _step5Focus.dispose();
    super.dispose();
  }

  Future<void> _playStepSound(int stepIndex) async {
    final soundMap = {
      1: 'sounds/syohin-scan.ogg',
      2: 'sounds/suryo2.ogg',
      3: 'sounds/aki-loc.ogg', 
      4: 'sounds/ido-kanryo.ogg',
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
    if (_expandedStep == 3 && !_stepCompleted[3] && !_step2CountdownStarted) {
      _step2CountdownStarted = true;
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
                          'ダイレクト移動',
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
                                        visible: widget.currentStep == 1 && !_stepCompleted[0],
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) => const MenuScreen(
                                                  initialSelectedIndex: 2,
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
                                    ],
                                  ),
                                ),
                                Text(
                                  '1/1',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Helvetica Neue',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                 _buildStep(
                                  stepIndex: 0,
                                  title: 'ピックロケーション確認',
                                  children: [
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                        child: TextField(
                                        focusNode: _step1Focus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _playStepSound(1);
                                          setState(() {
                                            _stepCompleted[0] = true;
                                            _expandedStep = 1;
                                          });
                                          Future.delayed(const Duration(milliseconds: 200), () {
                                            FocusScope.of(context).requestFocus(_step2Focus);
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
                                  title: '商品確認',
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
                                          'assets/images/syohin.jpg',
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
                                          await _playStepSound(2);
                                          setState(() {
                                            _stepCompleted[1] = true;
                                            _expandedStep = 2;
                                          });
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            FocusScope.of(context).requestFocus(_step3Focus);
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
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 2,
                                  title: '数量入力',
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 122),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'ケース数：',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: TextField(
                                              focusNode: _step3Focus,
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                              style: const TextStyle(fontSize: 20, fontFamily: 'Helvetica Neue'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 122),
                                      child: Row(
                                        children: [
                                          const Text(
                                            '　バラ数：',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: TextField(
                                              focusNode: _step3Focus,
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                              style: const TextStyle(fontSize: 20, fontFamily: 'Helvetica Neue'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                        width: 344,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              _stepCompleted[2] = true;
                                              _expandedStep = 3;
                                            });
                                            await _playStepSound(3);
                                            Future.delayed(const Duration(milliseconds: 300), () {
                                              FocusScope.of(context).requestFocus(_step4Focus);
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: const Text(
                                            '数量を確定する',
                                            style: TextStyle(fontSize: 18, fontFamily: 'Helvetica Neue'),
                                          ),
                                        )
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 3,
                                  title: '格納ロケーション確認',
                                  children: [
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: TextField(
                                        focusNode: _step4Focus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          setState(() {
                                            _showModal = true;
                                          });

                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _playStepSound(4);
                                          await Future.delayed(const Duration(seconds: 2));

                                          if (!mounted) return;
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) => const MenuScreen(
                                                initialSelectedIndex: 2,
                                              ),
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'ロケーションバーコードをスキャン',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    FractionallySizedBox(
                                      widthFactor: 0.9,
                                      child: GestureDetector(
                                        child: Container(
                                          height: 800,
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
                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                      ),
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
                                  Text('移動完了', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
