import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu1.dart';
import 'package:otk_wms_mock/sub-menu3.dart';

class KenpinStartScreen extends StatefulWidget {
  final int currentStep;

  const KenpinStartScreen({super.key, this.currentStep = 1});

  @override
  State<KenpinStartScreen> createState() => _KenpinStartScreenState();
}

class _KenpinStartScreenState extends State<KenpinStartScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _liftScanFocusNode = FocusNode();
  final FocusNode _step2Focus = FocusNode();

  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false, false];
  String _selectedDenpyo = '';
  bool _showModal = false;
  final TextEditingController _quantityController = TextEditingController(text: '10');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/kenpin-start.ogg'));
      FocusScope.of(context).requestFocus(_liftScanFocusNode);

      _liftScanFocusNode.addListener(() async {
        if (!_liftScanFocusNode.hasFocus && !_stepCompleted[0]) {
          setState(() {
            _stepCompleted[0] = true;
            _expandedStep = 1;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _liftScanFocusNode.dispose();
    _step2Focus.dispose();
    super.dispose();
  }

  Future<void> _playStepSound(int stepIndex) async {
    final soundMap = {
      1: 'sounds/rotto.ogg',
      2: 'sounds/denpyo.ogg',
      3: 'sounds/suryo.ogg',
      4: 'sounds/asn-scan.ogg',
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
                          '検品',
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
                                        visible: !_stepCompleted[0], // 1工程目が完了したら非表示
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
                                const Text(
                                  '入庫件数：1/1',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Helvetica Neue',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _buildStep(
                                  stepIndex: 0,
                                  title: '商品の状態を確認・スキャン',
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                      child: TextField(
                                        focusNode: _liftScanFocusNode,
                                        decoration: const InputDecoration(
                                          hintText: 'バーコードをスキャン',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        onSubmitted: (value) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 500));

                                          if (value.trim().toLowerCase() == 'gs1') {
                                            // ロット確認（stepIndex: 1）をスキップ
                                            setState(() {
                                              _stepCompleted[0] = true;
                                              _stepCompleted[1] = true;
                                              _expandedStep = 2;
                                            });
                                            await _playStepSound(2);
                                          } else {
                                            await _playStepSound(1);
                                            await Future.delayed(const Duration(seconds: 3));
                                            if (!mounted) return;
                                            setState(() {
                                              _stepCompleted[1] = true;
                                              _expandedStep = 2;
                                            });
                                            await _playStepSound(2);
                                          }
                                        }
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    FractionallySizedBox(
                                      widthFactor: 0.9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset('assets/images/syohin.jpg'),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 1,
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
                                  stepIndex: 2,
                                  title: '伝票選択',
                                  children: [
                                    for (var label in ['MM10D1124533', 'MG10D11245241', 'GG10D11245241'])
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (_selectedDenpyo != label) {
                                              await _playStepSound(3);
                                              setState(() {
                                                _selectedDenpyo = label;
                                                _stepCompleted[2] = true;
                                                _expandedStep = 3;
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: _selectedDenpyo == label ? Colors.blue : Colors.black26,
                                              ),
                                              color: _selectedDenpyo == label ? Colors.blue.shade50 : null,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            alignment: Alignment.center, // 中央揃え（任意）
                                            child: Text(
                                              label,
                                              style: const TextStyle(
                                                fontSize: 20, // お好みで調整（例: 20〜24程度）
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Helvetica Neue', // UIと統一感を持たせる
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
                                  title: '数量確認',
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 132, vertical: 8),
                                      child: TextField(
                                        controller: _quantityController,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center, // ← 中央揃え
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
                                          await _playStepSound(4);
                                          setState(() {
                                            _stepCompleted[3] = true;
                                            _expandedStep = 4;
                                          });
                                          await Future.delayed(const Duration(milliseconds: 300));
                                          FocusScope.of(context).requestFocus(_step2Focus);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('確認'),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 4,
                                  title: 'ASNラベルスキャン or 印刷',
                                  children: [
                                    Image.asset('assets/images/asn-qr2.png'),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 32),
                                      child: TextField(
                                        focusNode: _step2Focus,
                                        onSubmitted: (_)  async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          setState(() => _showModal = true);
                                          await _audioPlayer.play(AssetSource('sounds/label-harituke.ogg'));
                                          await Future.delayed(const Duration(seconds: 3));
                                          await _audioPlayer.play(AssetSource('sounds/kenpin-kanryo.ogg'));
                                          await Future.delayed(const Duration(seconds: 2));
                                          if (!mounted) return;
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) => const SubMenu3Screen(),
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
                                        },
                                        decoration: InputDecoration(
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
                                          setState(() => _showModal = true);
                                          await _audioPlayer.play(AssetSource('sounds/label-harituke.ogg'));
                                          await Future.delayed(const Duration(seconds: 3));
                                          await _audioPlayer.play(AssetSource('sounds/kenpin-kanryo.ogg'));
                                          await Future.delayed(const Duration(seconds: 2));
                                          if (!mounted) return;
                                         Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) => const MenuScreen(
                                                initialSelectedIndex: 0,
                                                initialSelectedCategoryIndex: 2, // 「検品」のカテゴリインデックス
                                              ),
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
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
                                  Text('検品完了', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
//       Align(
//   alignment: Alignment.topLeft,
//   child: Padding(
//     padding: const EdgeInsets.only(left: 16, top: 10),
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
//           '→v0.7.0/1-3',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             fontFamily: 'Helvetica Neue',
//           ),
//         ),
//         Text(
//           '※P6,7,8,9 すべてをこの画面で',
//           style: TextStyle(
            
//             fontFamily: 'Helvetica Neue',
//             color: Colors.red, // ← 赤文字
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 8),

//         Text(
//           'パターン１：通常検品（ロット確認あり）',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 15,
//             fontFamily: 'Helvetica Neue',
//           ),
//         ),
//         Text('・画面表示時に「商品の状態を確認しバーコードをスキャンしてください」音声'),
//         Text('・商品の状態確認 → バーコードをスキャン'),
//         Text('・「ロットを確認してください」音声'),
//         Text('・ロット確認情報を表示'),
//         Text('・「伝票を選択してください」音声'),
//         Text('・伝票を選択'),
//         Text('・「数量を確認してください」音声'),
//         Text('・数量を確定 '),
//         Text('・「対象のASNラベルをスキャンしてください」音声'),
//         Text('・ASNラベルをスキャン '),
//         Text('「出力されたラベルをダンボールに貼り付けてください」音声'),
//         Text('・「検品完了」音声'),
//         Text('・メニューへ戻る'),

//         SizedBox(height: 8),

//         Text(
//           'パターン２：GS1-128を入力（ロット確認スキップ）',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 15,
//             fontFamily: 'Helvetica Neue',
//           ),
//         ),
//         Text('・商品の状態確認ステップで「gs1」と入力してスキャン'),
//         Text('・ロット確認ステップはスキップして伝票選択へ遷移'),
//         Text('・「伝票を選択してください」音声'),
//         Text('・伝票を選択 → 「数量を確認してください」音声'),
//         Text('・数量を入力 → 「ASNラベルをスキャンしてください」音声'),
//         Text('・ASNラベルをスキャン '),
//         Text('「出力されたラベルをダンボールに貼り付けてください」音声'),
//         Text('・「検品完了」音声'),
//         Text('・メニューへ戻る'),
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
//           '※複数伝票出ない場合は、伝票選択工程スキップ',
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
//           '→単一伝票の場合：該当の伝票番号',
//           style: TextStyle(
            
//             fontFamily: 'Helvetica Neue',
//             color: Colors.red, // ← 赤文字
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           'シンプルパターンを追加',
//           style: TextStyle(
            
//             fontFamily: 'Helvetica Neue',
//             color: Colors.blue, // ← 赤文字
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           '商品名・ロット・数数量　を合体',
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
