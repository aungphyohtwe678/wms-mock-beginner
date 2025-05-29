import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/sub-menu5.dart';

class KonpoScreen extends StatefulWidget {
  final int currentStep;

  const KonpoScreen({super.key, this.currentStep = 1});

  @override
  State<KonpoScreen> createState() => _KonpoScreenState();
}

class _KonpoScreenState extends State<KonpoScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false, false];
  bool _showModal = false;
  final FocusNode _step1Focus = FocusNode();
  final FocusNode _step2Focus = FocusNode();  
  final FocusNode _step3Focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/hukan.ogg'));
      await Future.delayed(const Duration(milliseconds: 3000));
      setState(() {
        _stepCompleted[0] = true;
        _expandedStep = 1;
      });
      await _playStepSound(1);
      await Future.delayed(const Duration(milliseconds: 200));
      FocusScope.of(context).requestFocus(_step1Focus);
    });
  }

  Future<void> _playStepSound(int stepIndex) async {
    final soundMap = {
      1: 'sounds/ikisaki.ogg',
      2: 'sounds/konpo.ogg',
      3: 'sounds/konpo-kanryo.ogg',
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
        case 2:
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 50));
          FocusScope.of(context).requestFocus(_step2Focus);
          break;
        case 3:
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 50));
          FocusScope.of(context).requestFocus(_step3Focus);
          break;
      }
    });
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
                        '梱包',
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
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: !_stepCompleted[1], // 1週目かつ1工程目のみ表示
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
                              title: '緩衝材セット・封緘',
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  '緩衝材を詰め、封緘してください。',
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
                              title: '行き先ラベル確認',
                              children: [
                                const SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 32),
                                  child: TextField(
                                    focusNode: _step1Focus,
                                    onSubmitted: (_)  async {
                                      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      await _playStepSound(2);
                                      setState(() {
                                        _stepCompleted[1] = true;
                                        _expandedStep = 2;
                                      });
                                      await Future.delayed(const Duration(milliseconds: 200));
                                      FocusScope.of(context).requestFocus(_step2Focus);
                                    },
                                    decoration: InputDecoration(
                                      hintText: '行き先ラベルをスキャン',
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
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset('assets/images/ikisaki-label.png'),
                                  )
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                            _buildStep(
                              stepIndex: 2,
                              title: 'ASNラベルスキャン',
                              children: [
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
                                            'assets/images/tumituke3.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
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
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: TextField(
                                    focusNode: _step2Focus,
                                    onSubmitted: (_) async {
                                      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      await _audioPlayer.play(AssetSource('sounds/pl-himoduke.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 1500));
                                      setState(() {
                                        _showModal = true;
                                      });
                                      _playStepSound(3);
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
                                      await _audioPlayer.play(AssetSource('sounds/pl-himoduke.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 1500));
                                      setState(() {
                                        _showModal = true;
                                      });
                                      _playStepSound(3);
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
                        '梱包完了',
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
