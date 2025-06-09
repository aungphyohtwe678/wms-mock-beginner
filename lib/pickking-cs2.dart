import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/sub-menu5.dart';

class PickkingCS2Screen extends StatefulWidget {
  final int currentStep;

  const PickkingCS2Screen({super.key, this.currentStep = 1});

  @override
  State<PickkingCS2Screen> createState() => _PickkingCS2ScreenState();
}

class _PickkingCS2ScreenState extends State<PickkingCS2Screen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false, false];
  bool _showModal = false;
  int _completedCount = 1; // ← 表示用（最初は1/2）
  bool _isSecondRound = false;

  final FocusNode _step1Focus = FocusNode();
  final FocusNode _step3Focus = FocusNode();  
  final FocusNode _step4Focus = FocusNode();
  final TextEditingController _step3Controller = TextEditingController(); 
  final TextEditingController _shohinController2 = TextEditingController();
  int _requiredScanCount = 8;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/kara-pl.ogg'));
    });
  }

  Future<void> _playStepSound(int stepIndex) async {
    final soundMap = {
      1: 'sounds/pic-start5.ogg',
      2: 'sounds/8c.ogg',
      3: 'sounds/4c.ogg',
      4: 'sounds/tumituke.ogg',
      5: 'sounds/syohin-scan.ogg',
      6: 'sounds/pic-asn.ogg',
      7: 'sounds/label-harituke.ogg',
      8: 'sounds/pic-kanryo.ogg',
      9: 'sounds/pic-start6.ogg'
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

          if (expanded) {
            _requestFocusForExpandedStep(); // ← 追加
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

  void _requestFocusForExpandedStep() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      switch (_expandedStep) {
        case 1:
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 50));
          FocusScope.of(context).requestFocus(_step1Focus);
          break;
        case 3:
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 50));
          FocusScope.of(context).requestFocus(_step3Focus);
          break;
        case 4:
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 50));
          FocusScope.of(context).requestFocus(_step4Focus);
          break;
      }
    });
  }

  void _onImageTapped() async {
    await _audioPlayer.play(AssetSource('sounds/pl-himoduke.ogg'));
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _showModal = true;
    });

    if (_completedCount == 1) {
      await _audioPlayer.play(AssetSource('sounds/8c.ogg'));
      await Future.delayed(const Duration(milliseconds: 1000));
      await _audioPlayer.play(AssetSource('sounds/pic-kanryo.ogg'));
      await Future.delayed(const Duration(milliseconds: 2000));
      setState(() {
        _stepCompleted[3] = true;
        
          _completedCount = 2;
          _isSecondRound = true;
          _stepCompleted = [true, false, false, false]; // ← 2周目へリセット
          _expandedStep = 1; // ← ここが **ないとstep4のまま** になる
        
        _showModal = false;
        _requiredScanCount = 4;
        _step3Controller.clear();
        _shohinController2.clear();
      });
      await _playStepSound(9); // 'pic-start3.ogg' に対応させる
      await Future.delayed(const Duration(milliseconds: 50));
      FocusScope.of(context).requestFocus(_step1Focus);
    } else {
      await _audioPlayer.play(AssetSource('sounds/4c.ogg'));
      await Future.delayed(const Duration(milliseconds: 1000));
      await _audioPlayer.play(AssetSource('sounds/pic-kanryo.ogg'));
      await Future.delayed(const Duration(milliseconds: 2000));
      if (mounted) {
        setState(() {
          _showModal = false;
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SubMenu5Screen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    }
  }
  
  Future<void> _startCountdownAndCompleteStep(int stepIndex, int nextStepIndex, int soundStepIndex) async {
    for (int i = 3; i >= 1; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
    }
    await _playStepSound(soundStepIndex);
    setState(() {
      _stepCompleted[stepIndex] = true;
      _expandedStep = nextStepIndex;
    });
    _requestFocusForExpandedStep();
  }


  @override
  Widget build(BuildContext context) {
    final mapAsset = 'assets/images/map3.png';
if (_expandedStep == 0 && !_stepCompleted[0] && !_isSecondRound) {
  _startCountdownAndCompleteStep(0, 1, 1);
}

    if (_completedCount == 2 && !_stepCompleted[1] && _expandedStep == 0) {
  setState(() {
    _expandedStep = 1;
  });
  _requestFocusForExpandedStep();
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
                      automaticallyImplyLeading: true,
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
                    body: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: !_isSecondRound && !_stepCompleted[1], // 1週目かつ1工程目のみ表示
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (_, __, ___) => const SubMenu5Screen(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero,
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
                            const SizedBox(height: 10),
                            Text(
                              'ピック件数：$_completedCount/2',
                              style: const TextStyle(
                                fontSize: 25,
                                fontFamily: 'Helvetica Neue',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            _buildStep(
                              stepIndex: 0,
                              title: '空パレット用意',
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  '1枚',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Helvetica Neue',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ]
                            ),
                            _buildStep(
                              stepIndex: 1,
                              title: 'ピックロケーション確認・スキャン',
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  _isSecondRound
                                  ? '04-004-13'
                                  : '04-004-12',
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

                                      if (_isSecondRound) {
                                        await _playStepSound(3); // ← 2周目なら 4c.ogg
                                      } else {
                                        await _playStepSound(2); // ← 1周目なら 8c.ogg
                                      }

                                      setState(() {
                                        _stepCompleted[1] = true;
                                        _expandedStep = 2;
                                      });
                                      await Future.delayed(const Duration(milliseconds: 1500));
                                      await _playStepSound(4);
                                      await Future.delayed(const Duration(milliseconds: 2500));
                                      _playStepSound(5);
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
                              stepIndex: 2,
                              title: '数量確認・積みつけ',
                              children: [
                                Text(
                                  _isSecondRound ? 'ビーフリード輸液1000ml' : 'ビーフリード輸液500ml',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Helvetica Neue',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),   
                                Text(
                                  '$_requiredScanCount ケース',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Helvetica Neue',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
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
                                      child: SizedBox( // ← 画像を包んで高さ制限
                                        height: 150,
                                        child: Image.asset(
                                          _isSecondRound
                                              ? 'assets/images/tumituke2.png'
                                              : 'assets/images/tumituke.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: TextField(
                                    controller: _step3Controller,
                                    focusNode: _step3Focus,
                                    onSubmitted: (value) async {
                                      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 300));
                                      if (_completedCount == 1) {
                                                _shohinController2.text = 'MMY2025M5D00XX';
                                              } else if (_completedCount == 2) {
                                                _shohinController2.text = 'ZZY2025M5D01YY';
                                              }

                                      if (value.trim().toLowerCase() == 'gs1-128') {
                                        await _audioPlayer.play(AssetSource('sounds/label-harituke.ogg'));
                                        await Future.delayed(const Duration(milliseconds: 3500));
                                        setState(() {
                                          _stepCompleted[2] = true;
                                          _stepCompleted[3] = true;
                                          _expandedStep = 4;
                                        });
                                        await _playStepSound(6);
                                      } else {
                                        await _audioPlayer.play(AssetSource('sounds/label-harituke.ogg'));
                                        await Future.delayed(const Duration(milliseconds: 3500));
                                        setState(() {
                                          _stepCompleted[2] = true;
                                          _expandedStep = 3;
                                        });
                                        await _playStepSound(6);
                                        FocusScope.of(context).requestFocus(_step4Focus);
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
                                const SizedBox(height: 8),
                                FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SizedBox( // ← 画像を包んで高さ制限
                                        height: 150,
                                        child: Image.asset(
                                          'assets/images/syohin.jpg',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
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
                                    onSubmitted: (_) async {
                                      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      _onImageTapped();
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