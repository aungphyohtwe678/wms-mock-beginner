// 搬送まで
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu1.dart';

class KinkyuMotoASNScreen extends StatefulWidget {
  final int currentStep;

  const KinkyuMotoASNScreen({super.key, this.currentStep = 1});

  @override
  State<KinkyuMotoASNScreen> createState() => _KinkyuMotoASNScreenState();
}

class _KinkyuMotoASNScreenState extends State<KinkyuMotoASNScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false, false, false];
  bool _showModal = false;
  bool _isStep4Error = false;
  final TextEditingController _step1Controller = TextEditingController();
  final TextEditingController _step2Controller = TextEditingController();
  final TextEditingController _step3Controller = TextEditingController();
  final TextEditingController _step4Controller = TextEditingController();
  bool _showHimodukeModal = false;
  int _repeatIndex = 0;
  bool _step2CountdownStarted = false;

  final FocusNode _step1Focus = FocusNode();
  final FocusNode _step2Focus = FocusNode();
  final FocusNode _step3Focus = FocusNode();
  final FocusNode _step4Focus = FocusNode();
  final FocusNode _step5Focus = FocusNode();

  final List<String> _locations = ['02-001-04', '02-001-05', '02-001-06'];
  final List<String> _maps = ['images/map5.png', 'images/map6.png', 'images/map7.png'];
  final List<String> _startSounds = ['sounds/pic-loc1.ogg', 'sounds/pic-loc2.ogg', 'sounds/pic-loc3.ogg'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource(_startSounds[_repeatIndex]));
      _requestFocusForExpandedStep();
    });
  }

  @override
  void didUpdateWidget(covariant KinkyuMotoASNScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestFocusForExpandedStep();
    });
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
        case 4:
          FocusScope.of(context).requestFocus(_step4Focus);
          break;
        case 5:
          FocusScope.of(context).requestFocus(_step5Focus);
          break;
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _step1Focus.dispose();
    _step2Focus.dispose();
    _step3Focus.dispose();
    _step4Focus.dispose();
    _step5Focus.dispose();
    _step1Controller.dispose();
    _step2Controller.dispose();
    _step3Controller.dispose();
    _step4Controller.dispose();
    super.dispose();
  }

  Future<void> _playStepSound(int stepIndex) async {
    final soundMap = {
      1: 'sounds/syohin-scan.ogg',
      2: 'sounds/label-harituke.ogg',
      3: 'sounds/hanso.ogg',
      4: 'sounds/hozyu-kanryo.ogg',
      5: 'sounds/asn-scan.ogg',
      6: 'sounds/pl-himoduke.ogg'
    };
    if (soundMap.containsKey(stepIndex)) {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(soundMap[stepIndex]!));
    }
  }

  Future<void> _startCountdownStep2() async {
    for (int i = 3; i >= 1; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
    }
    await _playStepSound(3);
    setState(() {
      _stepCompleted[3] = true;
      _expandedStep = 4;
    });
    _requestFocusForExpandedStep();
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
          if (expanded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _requestFocusForExpandedStep();
            });
          }
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
  void _resetRepeatStep() {
    setState(() {
      _stepCompleted = [false, false, false, false, false, false];
      _step1Controller.clear();
      _step2Controller.clear();
      _step3Controller.clear();
      _step4Controller.clear();
      _expandedStep = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (_expandedStep == 3 && !_stepCompleted[3] && !_step2CountdownStarted) {
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
                          '緊急補充（CS→PCS）',
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
                                        visible: _repeatIndex == 0 && !_stepCompleted[0], // 1週目かつ1工程目が未完了のときだけ表示
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
                                _buildStep(
                                  stepIndex: 0,
                                  title: 'ピックロケーション確認・スキャン',
                                  children: [
                                    const SizedBox(height: 8),
                                   Text(
                                      _locations[_repeatIndex],
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontFamily: 'Helvetica Neue',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: TextField(
                                        controller: _step1Controller,
                                        focusNode: _step1Focus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _playStepSound(1);
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
                                          _maps[_repeatIndex],
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
                                  title: '商品確認・スキャン',
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
                                        controller: _step2Controller,
                                        focusNode: _step2Focus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _audioPlayer.play(AssetSource('sounds/asn-scan.ogg'));
                                          setState(() {
                                            _stepCompleted[1] = true;
                                            _expandedStep = 2;
                                          });
                                          _requestFocusForExpandedStep();
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
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 2,
                                  title: 'ASNラベルスキャン',
                                  children: [
                                    const SizedBox(height: 5),
                                    Image.asset('assets/images/asn-qr2.png'),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: TextField(
                                        controller: _step3Controller,
                                        focusNode: _step3Focus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _audioPlayer.play(AssetSource('sounds/pl-himoduke.ogg'));

                                          setState(() {
                                            _showHimodukeModal = true;
                                          });

                                          await Future.delayed(const Duration(seconds: 2));
                                          if (!mounted) return;

                                          if (_repeatIndex < 2) {
                                            // 再生前に index をインクリメントしない
                                            final nextIndex = _repeatIndex + 1;

                                            setState(() {
                                              _repeatIndex = nextIndex;
                                              _showHimodukeModal = false;
                                            });

                                            await _audioPlayer.play(AssetSource(_startSounds[nextIndex]));
                                            _resetRepeatStep();
                                            _requestFocusForExpandedStep();
                                          } else {
                                            // 3回目終了
                                            await _playStepSound(2); // label-harituke
                                            setState(() {
                                              _showHimodukeModal = false;
                                              _stepCompleted[0] = true;
                                              _stepCompleted[1] = true;
                                              _stepCompleted[2] = true;
                                              _expandedStep = 3;
                                            });
                                            _requestFocusForExpandedStep();
                                          }
                                        },
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
                                        onPressed: () async {
                                          await _playStepSound(5);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('ASNラベルを発行する'),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 3,
                                  title: '補充指示ラベル貼付',
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text(
                                      '出力されたラベルを全CSに貼り付けてください。',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Helvetica Neue',
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 4,
                                  title: '搬送先確認',
                                  children: [
                                    const Text(
                                      '昇降機A-①',
                                      style: TextStyle(
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
                                        controller: _step4Controller,
                                        focusNode: _step4Focus,
                                        onSubmitted: (_) async {
                                          final input = _step4Controller.text.trim();

                                          if (input.toUpperCase() == 'NG') {
                                            await Future.delayed(const Duration(seconds: 1));
                                            setState(() {
                                              _showModal = true;
                                              _isStep4Error = true;
                                            });
                                            await Future.delayed(const Duration(seconds: 2));
                                            await _audioPlayer.play(AssetSource('sounds/error.ogg'));
                                            setState(() {
                                              _showModal = false;
                                              _step4Controller.clear();
                                            });
                                            return;
                                          }

                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));

                                          setState(() {
                                            _showModal = true;
                                            _isStep4Error = false;
                                          });

                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _playStepSound(4);
                                          await Future.delayed(const Duration(seconds: 2));

                                          if (!mounted) return;
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) => const MenuScreen(),
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
                                        },
                                        decoration: InputDecoration(
                                          hintText: '昇降機のQRコードをスキャン',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _isStep4Error ? Colors.red : Colors.black,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _isStep4Error ? Colors.red : Colors.black,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _isStep4Error ? Colors.red : Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: GestureDetector(
                                        child: Container(
                                          width: double.infinity,
                                          height: 400,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Image.asset(
                                            'assets/images/hanso-qr.png',
                                            fit: BoxFit.cover,
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _isStep4Error ? '緊急補充失敗' : '緊急補充完了',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                  const CircularProgressIndicator(),
                                ],
                              ),
                            ),
                          if (_showHimodukeModal)
                          Container(
                            color: Colors.white.withOpacity(0.9),
                            alignment: Alignment.center,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '紐付け完了',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}