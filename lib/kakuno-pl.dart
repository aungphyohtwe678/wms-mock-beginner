import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/kakuno-cs.dart';
import 'package:otk_wms_mock/sub-menu2.dart';

class KakunoPLScreen extends StatefulWidget {
  final int currentStep;

  const KakunoPLScreen({super.key, this.currentStep = 1});

  @override
  State<KakunoPLScreen> createState() => _KakunoPLScreenState();
}

class _KakunoPLScreenState extends State<KakunoPLScreen> {
  final TextEditingController _asnController1 = TextEditingController();
  final TextEditingController _asnController2 = TextEditingController();
  final FocusNode _asnFocus1 = FocusNode();
  final FocusNode _asnFocus2 = FocusNode();
  final FocusNode _liftFocus = FocusNode();
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false];
  bool _showModal = false;
  bool _isFirstLocked = false;
  bool _isError = false;
  String _errorMessage = '';
  int _completedRounds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/kakuno-asn.ogg'));
      FocusScope.of(context).requestFocus(_asnFocus1);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _asnController1.dispose();
    _asnController2.dispose();
    _asnFocus1.dispose();
    _asnFocus2.dispose();
    _liftFocus.dispose();
    super.dispose();
  }

  Future<void> _playSound(String path) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
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
                                        visible: _completedRounds == 0 && !_isFirstLocked,
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
                                  '格納件数：${_completedRounds + 1}/3',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Helvetica Neue',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _buildStep(
                                  stepIndex: 0,
                                  title: 'ASNラベルスキャン',
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                            child: Text(
                                              '${_isFirstLocked ? 2 : 1}パレ目',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Helvetica Neue',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                            child: TextField(
                                              controller: _asnController1,
                                              focusNode: _asnFocus1,
                                          onSubmitted: (_) async {
                                            final input = _asnController1.text.trim();

                                            if (!_isFirstLocked) {
                                              if (input.isEmpty) {
                                                setState(() {
                                                  _isError = true;
                                                  _errorMessage = 'ラベルが未入力です';
                                                });
                                                await _playSound('sounds/ng-null.ogg');
                                                return;
                                              }
                                              // --- 「CS」と入力されたら KakunoCSScreen に遷移 ---
                                              if (input == 'CS') {
                                                await _playSound('sounds/pi.ogg');
                                                await Future.delayed(const Duration(milliseconds: 300));
                                                if (!mounted) return;
                                                Navigator.pushReplacement(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (_, __, ___) => const KakunoCSScreen(),
                                                    transitionDuration: Duration.zero,
                                                  ),
                                                );
                                                return;
                                              }

                                              // --- 「1」と入力されたら2枚目スキャン省略して次へ進む ---
                                              if (input == '1') {
                                                await _playSound('sounds/pi.ogg');
                                                setState(() {
                                                  _isFirstLocked = true;
                                                  _isError = false;
                                                  _asnController1.clear();
                                                  _stepCompleted[0] = true;
                                                  _expandedStep = 1;
                                                });
                                                await Future.delayed(const Duration(milliseconds: 500));
                                                FocusScope.of(context).requestFocus(_liftFocus);
                                                if (_completedRounds == 3) {
                                                  await _audioPlayer.play(AssetSource('sounds/kakuno2.ogg'));
                                                } else {
                                                  await _audioPlayer.play(AssetSource('sounds/kakuno.ogg'));
                                                }
                                                await Future.delayed(const Duration(milliseconds: 3800));
                                                await _playSound('sounds/dansu.ogg');
                                                return;
                                              }

                                              // 通常の1回目処理
                                              setState(() {
                                                _isFirstLocked = true;
                                                _isError = false;
                                                _asnController1.clear();
                                              });
                                              await _playSound('sounds/pi.ogg');
                                              FocusScope.of(context).requestFocus(_asnFocus1);
                                            } else {
                                              // 2回目のスキャン → 次工程へ
                                              await _playSound('sounds/pi.ogg');
                                              setState(() {
                                                _stepCompleted[0] = true;
                                                _expandedStep = 1;
                                              });
                                              await Future.delayed(const Duration(milliseconds: 500));
                                              FocusScope.of(context).requestFocus(_liftFocus);
                                              if (_completedRounds == 3) {
                                                await _audioPlayer.play(AssetSource('sounds/kakuno2.ogg'));
                                              } else {
                                                await _audioPlayer.play(AssetSource('sounds/kakuno.ogg'));
                                              }
                                              await Future.delayed(const Duration(milliseconds: 3800));
                                              await _playSound('sounds/dansu.ogg');
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
                                          if (_isError)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
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
                                    ),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 1,
                                  title: '格納ロケーション確認・スキャン',
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      _completedRounds == 2 ? '03-003-2' : '03-003-1',
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontFamily: 'Helvetica Neue',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '保管段数：3段',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Helvetica Neue',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _completedRounds == 2 ? 'ロケーション進捗：1/1' : 'ロケーション進捗：${_completedRounds + 1}/2',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Helvetica Neue',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: TextField(
                                        focusNode: _liftFocus,
                                        onSubmitted: (_) async {
                                          if (_completedRounds >= 2) {
                                            setState(() => _showModal = true);
                                            await _playSound('sounds/pi.ogg');
                                            await Future.delayed(const Duration(milliseconds: 500));
                                            await _playSound('sounds/kakuno-kanryo.ogg');
                                            await Future.delayed(const Duration(seconds: 2));
                                            if (!mounted) return;
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) => const SubMenu2Screen(),
                                                transitionDuration: Duration.zero,
                                              ),
                                            );
                                          } else {
                                            setState(() => _showModal = true);
                                            await _playSound('sounds/pi.ogg');
                                            await Future.delayed(const Duration(milliseconds: 500));
                                            await _playSound('sounds/kakuno-kanryo.ogg');
                                            await Future.delayed(const Duration(seconds: 2));
                                            // 初期化して再度1工程目から繰り返す
                                            setState(() {
                                              _stepCompleted = [false, false, false];
                                              _expandedStep = 0;
                                              _isFirstLocked = false;
                                              _asnController1.clear();
                                              _asnController2.clear();
                                              _showModal = false;
                                            });
                                            _completedRounds++;
                                            await Future.delayed(const Duration(milliseconds: 300));
                                            FocusScope.of(context).requestFocus(_asnFocus1);
                                            await _audioPlayer.play(AssetSource('sounds/kakuno-asn.ogg'));
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'ロケーションバーコードをスキャン',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
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