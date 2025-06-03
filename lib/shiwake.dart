import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/sub-menu1.dart';

class ShiwakeStartScreen extends StatefulWidget {
  final int currentStep;

  const ShiwakeStartScreen({super.key, this.currentStep = 1});

  @override
  State<ShiwakeStartScreen> createState() => _ShiwakeStartScreenState();
}

class _ShiwakeStartScreenState extends State<ShiwakeStartScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final FocusNode _motoFocus = FocusNode();
  final FocusNode _sakiFocus = FocusNode();
  final FocusNode _shohinFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _saki2Focus = FocusNode();

  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _shohinController = TextEditingController();

  bool _showItemScan = false;
  bool _showModal = false;
  int _scanPhase = 1; // 今何回目のスキャン工程か（1 → 2）
  final int _maxPhases = 2;

  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false];
  int _completedCount = 1; // 商品スキャンの進捗を示すカウンター

  final List<Map<String, dynamic>> _scanItems = [
  {'name': 'ビーフリード輸液 500mL × 20袋', 'rotto': 'XSSF230353205', 'count': 2},
  {'name': 'エルネオパNF2号輸液 1000mL × 10袋','rotto': 'MXSF24067205', 'count': 5},
];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/shiwake-moto.ogg'));
      FocusScope.of(context).requestFocus(_motoFocus);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _motoFocus.dispose();
    _sakiFocus.dispose();
    _shohinFocus.dispose();
    _quantityFocus.dispose();
    _saki2Focus.dispose();
    _quantityController.dispose();
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
                          '仕分け',
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
                                        visible: !_stepCompleted[0],
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
                                const SizedBox(height: 10),
                                Text(
                                  '仕分け件数：$_completedCount/2',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Helvetica Neue',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _buildStep(
                                  stepIndex: 0,
                                  title: 'ASN（載せ替え元）スキャン',
                                  children: [
                                   Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                    child: TextField(
                                      focusNode: _motoFocus,
                                      onSubmitted: (_) async {
                                        await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                        setState(() {
                                          _stepCompleted[0] = true;
                                          _expandedStep = 1;
                                        });
                                        await Future.delayed(const Duration(milliseconds: 500));
                                        await _audioPlayer.play(AssetSource('sounds/shiwake-saki.ogg'));
                                        FocusScope.of(context).requestFocus(_sakiFocus);
                                      },
                                      decoration: const InputDecoration(
                                        hintText: '載せ替え元のASNラベルをスキャン',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      ),
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
                                    SizedBox(
                                      width: 344,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          setState(() {
                                            _stepCompleted[0] = true;
                                            _expandedStep = 1;
                                          });
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _audioPlayer.play(AssetSource('sounds/shiwake-saki.ogg'));
                                          FocusScope.of(context).requestFocus(_sakiFocus);
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
                                  stepIndex: 1,
                                  title: 'ASN（載せ替え先）スキャン',
                                  children: [
                                    Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                    child: TextField( 
                                        focusNode: _sakiFocus,
                                        onSubmitted: (_) async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          setState(() {
                                            _stepCompleted[1] = true;
                                            _expandedStep = 2;
                                            _showItemScan = true;
                                          });
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          if (_scanPhase == 1) {
                                            await _audioPlayer.play(AssetSource('sounds/2.ogg'));
                                            await Future.delayed(const Duration(milliseconds: 1000));
                                          } 
                                          await _audioPlayer.play(AssetSource('sounds/nosekae1.ogg'));
                                          await Future.delayed(const Duration(milliseconds: 2300));
                                          setState(() {
                                            _stepCompleted[2] = true;
                                            _expandedStep = 3;
                                          });
                                          await Future.delayed(const Duration(milliseconds: 200));
                                          FocusScope.of(context).requestFocus(_shohinFocus);
                                        },
                                        decoration: const InputDecoration(
                                        hintText: '載せ替え先のASNラベルをスキャン',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white,
                                      )
                                      ),
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
                                    SizedBox(
                                      width: 344,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                          setState(() {
                                            _stepCompleted[1] = true;
                                            _expandedStep = 2;
                                            _showItemScan = true;
                                          });
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _audioPlayer.play(AssetSource('sounds/syohin-scan.ogg'));
                                          FocusScope.of(context).requestFocus(_shohinFocus);
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
                                  stepIndex: 2,
                                  title: '載せ替え',
                                  children: [
                                    Text(
                                      _scanItems[_scanPhase - 1]['name'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Helvetica Neue',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _scanItems[_scanPhase - 1]['rotto'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Helvetica Neue',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${_scanItems[_scanPhase - 1]['count']}個',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'Helvetica Neue',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 3,
                                  title: '商品 or パレット明細ラベルスキャン',
                                  children: [
                                    if (_showItemScan)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                        child: TextField(
                                          focusNode: _shohinFocus,
                                          controller: _shohinController,
                                          onSubmitted: (_) async {
                                            await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
                                            setState(() {
                                              _stepCompleted[2] = true;
                                              _expandedStep = 3;
                                              _showItemScan = true;
                                            });
                                            if (_scanPhase < _maxPhases) {
  // 次の商品へ
  setState(() {
    _scanPhase++;
    _expandedStep = 2;
    _stepCompleted = [true, true, false, false];
    _shohinController.clear(); 
    _completedCount++;
  });
  await Future.delayed(const Duration(milliseconds: 500));
  await _audioPlayer.play(AssetSource('sounds/5.ogg'));
  await Future.delayed(const Duration(milliseconds: 1000));
  await _audioPlayer.play(AssetSource('sounds/nosekae1.ogg'));
  await Future.delayed(const Duration(milliseconds: 2000));
  setState(() {
    _stepCompleted[2] = true;
    _expandedStep = 3;
  });
  await Future.delayed(const Duration(milliseconds: 500));
  FocusScope.of(context).requestFocus(_shohinFocus);
} else {
  // ✅ 最終スキャン完了
  await _audioPlayer.play(AssetSource('sounds/pi.ogg'));
  setState(() {
    _stepCompleted[3] = true;
    _showModal = true;
  });
  await Future.delayed(const Duration(milliseconds: 500));
  await _audioPlayer.play(AssetSource('sounds/shiwake-kanryo.ogg'));
  await Future.delayed(const Duration(seconds: 2));
  if (!mounted) return;
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => const SubMenu1Screen(),
      transitionDuration: Duration.zero,
    ),
  );
}                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'バーコード／ラベルをスキャン',
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white,
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
                                  Text('仕分け完了', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
