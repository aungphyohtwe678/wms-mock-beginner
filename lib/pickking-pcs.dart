import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/sub-menu5.dart';

class PickkingPCSScreen extends StatefulWidget {
  final int currentStep;
  const PickkingPCSScreen({super.key, this.currentStep = 1});

  @override
  State<PickkingPCSScreen> createState() => _PickkingPCSScreenState();
}

class _PickkingPCSScreenState extends State<PickkingPCSScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _expandedStep = 0;
  final List<bool> _stepCompleted = [false, false, false];
  final FocusNode _step1Focus = FocusNode();
  final FocusNode _step2Focus = FocusNode();
  int _scanCount = 0;
  final List<int> targetCounts = [4, 6]; // ← 2工程分にする
  bool _showModal = false;
  String _modalText = '撮影中...';
  int _completedCount = 1;
  final TextEditingController _shohinController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
final List<GlobalKey> _stepKeys = List.generate(3, (_) => GlobalKey());
  final TextEditingController _shohinController2 = TextEditingController();

final List<String> productList = [
  '生食注シリンジ「オーツカ」20mL',
  '生食注シリンジ「オーツカ」10mL'
];
final List<String> destinations = [
  '04-004-12',
  '04-004-13'
];

  late int _currentStep;
@override
void initState() {
  super.initState();

  _currentStep = 1; // ← 1回目スタート
  _completedCount = 1; // ← 表示：1/4

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await _audioPlayer.play(AssetSource('sounds/pic-pcs.ogg'));
    await Future.delayed(const Duration(seconds: 3));
    await _audioPlayer.play(AssetSource('sounds/pic-start5.ogg'));

    setState(() {
      _stepCompleted[0] = true;
      _expandedStep = 1;
    });

    FocusScope.of(context).requestFocus(_step1Focus);
  });
}


  @override
  void dispose() {
    _audioPlayer.dispose();
    _step1Focus.dispose();
    _step2Focus.dispose();
    _shohinController2.dispose();
    super.dispose();
  }

  Future<void> _scrollToStep(int index) async {
    await Future.delayed(Duration(milliseconds: 50)); 
  final keyContext = _stepKeys[index].currentContext;
  if (keyContext != null) {
    await Scrollable.ensureVisible(
      keyContext,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }
}

Widget _buildStep({
  required int stepIndex,
  required String title,
  required List<Widget> children,
}) {
  // 工程の前提条件を満たさなければ非表示
  if (stepIndex == 0 && _expandedStep == 2) return const SizedBox.shrink();
  if (!_stepCompleted.sublist(0, stepIndex).every((e) => e)) return const SizedBox.shrink();

  // 現在のステップのみ展開する（完了済みは常に閉じる）
  final bool isExpanded = !_stepCompleted[stepIndex] && _expandedStep == stepIndex;

  return Container(
    key: _stepKeys[stepIndex], // 自動スクロール対象
    child: ExpansionTile(
      key: ValueKey('step_$stepIndex-$_expandedStep'),
      initiallyExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        if (!_stepCompleted[stepIndex]) {
          setState(() {
            _expandedStep = expanded ? stepIndex : -1;
          });

          if (expanded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToStep(stepIndex);
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
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final hakodumeImage = 'assets/images/hakodume${_currentStep}.png';
    final cameraImage = 'assets/images/camera-${_currentStep}.png';
    final destination = destinations[_currentStep - 1];
    final product = productList[_currentStep - 1];
    final targetCount = targetCounts[_currentStep - 1];

    final stepOgg = {
      1: '4.ogg',
      2: '6.ogg',
      3: '5.ogg',
      4: '2.ogg'
    };
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
                    body: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: _currentStep == 1 && !_stepCompleted[1],
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
                                Visibility(
                                  visible: _stepCompleted[0],
                                  child: Text(
                                    '箱サイズ：K3', 
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Helvetica Neue',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    )
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'ピック件数：$_completedCount/2',
                              style: const TextStyle(
                                fontSize: 25,
                                fontFamily: 'Helvetica Neue',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          _buildStep(
                            stepIndex: 0,
                            title: '箱サイズ確認',
                            children: const [
                              SizedBox(height: 10),
                              Text(
                                'K3', 
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Helvetica Neue',
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          _buildStep(
                            stepIndex: 1,
                            title: 'ピックロケーション確認・スキャン',
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                destination, 
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontFamily: 'Helvetica Neue',
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  focusNode: _step1Focus,
                                  onSubmitted: (_) async {
                                    await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                    setState(() {
                                      _stepCompleted[1] = true;
                                      _expandedStep = 2;
                                    });
                                    await Future.delayed(const Duration(milliseconds: 300));
                                    await _scrollToStep(2);
                                    await Future.delayed(const Duration(milliseconds: 500));
                                    await _audioPlayer.play(AssetSource('sounds/${stepOgg[_currentStep]}'));
                                    await Future.delayed(const Duration(milliseconds: 800));
                                    await _audioPlayer.play(AssetSource('sounds/zensu.ogg'));
                                    FocusScope.of(context).unfocus();
                                    await Future.delayed(const Duration(milliseconds: 50));
                                    FocusScope.of(context).requestFocus(_step2Focus);
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'ロケーションバーコードをスキャン',
                                    border: OutlineInputBorder(),
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
                                      'assets/images/map3.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
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
                            title: '商品確認・スキャン・箱詰め',
                            children: [
                              Text(product, style: const TextStyle(fontSize: 20, fontFamily: 'Helvetica Neue',fontWeight: FontWeight.bold,)),
                              const SizedBox(height: 5),
                              Text('$_scanCount / $targetCount 個', style: const TextStyle(fontSize: 24, fontFamily: 'Helvetica Neue',fontWeight: FontWeight.bold,)),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: TextField(
                                  controller: _shohinController,
                                  focusNode: _step2Focus,
                                  onSubmitted: (_) async {
                                    if (_scanCount < targetCount) {
                                      // スキャン音
                                      await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                      await Future.delayed(const Duration(milliseconds: 300));
                                      if (_currentStep == 1) {
                                                _shohinController2.text = 'MMY2025M5D00XX';
                                              } else if (_currentStep == 2) {
                                                _shohinController2.text = 'ZZY2025M5D01YY';
                                              }

                                      setState(() {
                                        _scanCount++;
                                        _shohinController.clear();
                                      });

                                      // 残数音声
                                      await _audioPlayer.play(AssetSource('sounds/zansu.ogg'));
                                      await Future.delayed(const Duration(seconds: 1));

                                      // フォーカス維持
                                      await Future.delayed(const Duration(milliseconds: 100));
                                      FocusScope.of(context).requestFocus(_step2Focus);

                                      if (_scanCount >= targetCount) {
                                        // モーダル表示（撮影中…）
                                        setState(() {
                                          _showModal = true;
                                          _modalText = '撮影中...';
                                        });

                                        await Future.wait([
                                          _audioPlayer.play(AssetSource('sounds/satuei.ogg')),
                                          Future.delayed(const Duration(seconds: 1)),
                                        ]);

                                        if (!mounted) return;

                                        // 工程1が終わったとき → 工程2へ
                                        if (_currentStep == 1) {
                                          setState(() {
                                            _currentStep = 2;
                                            _completedCount = 2;
                                            _scanCount = 0;
                                            _stepCompleted[1] = false;
                                            _stepCompleted[2] = false;
                                            _expandedStep = 1;
                                            _shohinController2.clear();
                                          });

                                          setState(() => _modalText = 'ピック完了');
                                          await Future.delayed(const Duration(milliseconds: 1000));
                                          await _audioPlayer.play(AssetSource('sounds/pic-kanryo.ogg'));
                                          await Future.delayed(const Duration(seconds: 2));
                                          setState(() => _showModal = false);
                                          await _audioPlayer.play(AssetSource('sounds/pic-start6.ogg')); // 工程2用
                                          await Future.delayed(const Duration(milliseconds: 100));
                                          FocusScope.of(context).requestFocus(_step1Focus);
                                          return;
                                        }

                                        // 工程2が終わったとき → 完全終了
                                        else if (_currentStep == 2) {
                                          await _audioPlayer.play(AssetSource('sounds/label-harituke.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 3500));
                                          setState(() => _modalText = 'ピック完了');
                                          await Future.delayed(const Duration(milliseconds: 1000));
                                          await _audioPlayer.play(AssetSource('sounds/pic-kanryo.ogg'));
                                          await Future.delayed(const Duration(seconds: 2));

                                          if (!mounted) return;
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
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'バーコードをスキャン',
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
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
                              FractionallySizedBox(
                                widthFactor: 0.8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset('assets/images/syohin2.png', fit: BoxFit.cover,),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              FractionallySizedBox(
                                widthFactor: 0.8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(hakodumeImage, fit: BoxFit.cover,),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  )
                )
              ),
              if (_showModal)
              Container(
                color: Colors.white.withOpacity(0.9),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _modalText,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Helvetica Neue',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ],
                ),
              ),
            ]
          )
        )
      )
    );
  }
}
