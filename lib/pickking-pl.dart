import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/sub-menu5.dart';

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
      3: 'sounds/pic-asn.ogg',
      4: 'sounds/rotto.ogg',
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
    await _audioPlayer.play(AssetSource('sounds/pl-himoduke.ogg'));

    setState(() {
      _showModal = true;
    });
    await Future.delayed(const Duration(milliseconds: 1500));
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
          pageBuilder: (_, __, ___) => const SubMenu5Screen(),
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
    body: Stack(
      children: [
        Center(
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
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (_, __, ___) => const SubMenu5Screen(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero,
                                          ),
                                        );
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
                                    visible: _repeatCount == 1 && !_stepCompleted[0], // 1週目の1工程目のみ表示
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: OutlinedButton(
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'ピック件数：$_repeatCount/2',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Helvetica Neue',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            _buildStep(
                              stepIndex: 0,
                              title: 'ピックロケーション確認・スキャン',
                              children: [
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
                                      setState(() {
                                        _stepCompleted[0] = true;
                                        _expandedStep = 1;
                                      });
                                      _requestFocusForExpandedStep();
                                      _playStepSound(2);
                                      await Future.delayed(const Duration(milliseconds: 2000));
                                      _playStepSound(1);
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
                              title: '商品確認・スキャン',
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
                                Text.rich(
                                  TextSpan(
                                    text: '32ケース（完パレ）',
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // 通常の色
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' $_repeatCount/2',
                                        style: const TextStyle(
                                          color: Colors.red, // ← この色を好きな色に変更可能
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: TextField(
                                    focusNode: _step2Focus,
                                    decoration: const InputDecoration(
                                      hintText: 'バーコードをスキャン',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    onSubmitted: (value) async {
                                      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      await _audioPlayer.play(AssetSource('sounds/label-harituke.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 3500));
                                      if (value.trim().toLowerCase() == 'gs1-128') {
                                        setState(() {
                                          _stepCompleted[1] = true;
                                          _stepCompleted[2] = true;
                                          _expandedStep = 3;
                                        });
                                        await _playStepSound(3);
                                      } else {
                                        await _playStepSound(4);
                                        setState(() {
                                          _stepCompleted[1] = true;
                                          _expandedStep = 2;
                                        });
                                        await Future.delayed(const Duration(seconds: 2));
                                        if (!mounted) return;
                                        setState(() {
                                          _stepCompleted[2] = true;
                                          _expandedStep = 3;
                                        });
                                        await _playStepSound(3);
                                      }
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
                              title: 'ロット確認',
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text('Y2025D05M00XXX',
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
// Align(
//   alignment: Alignment.topLeft,
//   child: Padding(
//     padding: const EdgeInsets.only(left: 16, top: 72),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text(
//           '該当業務フロー',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             fontFamily: 'Helvetica Neue',
//           ),
//         ),
//         Text(
//           '→v0.7.0 3-3',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             fontFamily: 'Helvetica Neue',
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           'パターン１：通常ピッキング（ロット確認あり）',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 15,
//             fontFamily: 'Helvetica Neue',
//           ),
//         ),
//         Text('・「{ピックロケーション}に移動し、ロケーションをスキャンしてください」音声'),
//         Text('・ピックロケーションを確認し、バーコードをスキャン'),
//         Text('・「○ケース（完パレ）」音声'),
//         Text('・「ピックする商品のバーコードをスキャンしてください」音声'),
//         Text('・商品バーコードをスキャン'),
//         Text('・「出力されたラベルをダンボールに貼り付けてください」音声'),
//         Text('・「ロットを確認してください」音声'),
//         Text('・ロット情報を表示'),
//         Text('・「ピックしたパレットのASNラベルをスキャンしてください」音声'),
//         Text('・ASNラベルをスキャン、または「ASNラベルを発行する」ボタンを押下'),
//         Text('・「パレット紐付け完了」音声'),
//         Text('・「ピック完了」音声'),
//         Text('・ピック件数繰り返し'),
//         Text('・すべての指示完了後、メニューへ戻る'),

//         SizedBox(height: 8),
//         Text(
//           'パターン２：GS1-128を入力（ロット確認スキップ）',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 15,
//             fontFamily: 'Helvetica Neue',
//           ),
//         ),
//         Text('・商品をスキャン工程で「gs1-128」と入力'),
//         Text('・ロット確認ステップはスキップ'),
//         Text('・「出力されたラベルをダンボールに貼り付けてください」音声'),
//         Text('・「ピックしたパレットのASNラベルをスキャンしてください」音声'),
//         Text('・ASNラベルをスキャン、または「ASNラベルを発行する」ボタンを押下'),
//         Text('・「パレット紐付け完了」音声'),
//         Text('・「ピック完了」音声'),
//         Text('・ピック件数繰り返し'),
//         Text('・すべての指示完了後、メニューへ戻る'),
//         SizedBox(height: 8),
//         Text(
//           '※モックなのでGS1-128の場合でも工程が一瞬表示されるが',
//           style: TextStyle(
            
//             fontFamily: 'Helvetica Neue',
//             color: Colors.red, // ← 赤文字
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           '実際はスキップなので表示されない',
//           style: TextStyle(
            
//             fontFamily: 'Helvetica Neue',
//             color: Colors.red, // ← 赤文字
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           '※2パレ同時ピックの場合は、数量＋赤字で1/2、2/2を表示',
//           style: TextStyle(
            
//             fontFamily: 'Helvetica Neue',
//             color: Colors.red, // ← 赤文字
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           '確認',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 15,
//             fontFamily: 'Helvetica Neue',
//           ),
//         ),
//         Text(
//           '・スキップした工程を後で展開表示した時に何を表示すべき？',
//           style: TextStyle(
            
//             fontFamily: 'Helvetica Neue',
//             color: Colors.red, // ← 赤文字
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           '→GS1-128の場合：？',
//           style: TextStyle(
            
//             fontFamily: 'Helvetica Neue',
//             color: Colors.red, // ← 赤文字
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           '・パレット紐付け完了→ASN紐付け完了　の方が良い？',
//           style: TextStyle(
            
//             fontFamily: 'Helvetica Neue',
//             color: Colors.red, // ← 赤文字
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           '商品スキャン時にロットのテキストボックスを追加・かつロット表示工程不要（設計書には「確認」ボタンを設置）',
//           style: TextStyle(
            
//             fontFamily: 'Helvetica Neue',
//             color: Colors.blue, // ← 赤文字
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     ),
//   ),
// )
      ]
    )
    );
  }
}
