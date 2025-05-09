import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu.dart';

class ShiwakeStartScreen extends StatefulWidget {
  final int currentStep;

  const ShiwakeStartScreen({super.key, this.currentStep = 1});

  @override
  State<ShiwakeStartScreen> createState() => _ShiwakeStartScreenState();
}

class _ShiwakeStartScreenState extends State<ShiwakeStartScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _liftScanFocusNode = FocusNode();

  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false, false];
  String _selectedDenpyo = '';
  bool _showModal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/kenpin-start.ogg'));
      FocusScope.of(context).requestFocus(_liftScanFocusNode);

      _liftScanFocusNode.addListener(() async {
        if (!_liftScanFocusNode.hasFocus && !_stepCompleted[0]) {
          await _playStepSound(1);
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
    super.dispose();
  }

  Future<void> _playStepSound(int stepIndex) async {
    final soundMap = {
      1: 'sounds/denpyo.ogg',
      2: 'sounds/rotto.ogg',
      3: 'sounds/asn-scan.ogg',
      4: 'sounds/kenpin-kakunin.ogg',
    };
    if (soundMap.containsKey(stepIndex)) {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(soundMap[stepIndex]!));
    }
  }

  Widget _buildLeadingIcon(int stepIndex) {
    return Icon(
      _stepCompleted[stepIndex] ? Icons.check_circle : Icons.radio_button_unchecked,
      color: _stepCompleted[stepIndex] ? Colors.lightBlue : Colors.grey,
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
                          '検品',
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
                                customExpansionTile(
                                  stepIndex: 0,
                                  title: '商品の状態を確認',
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: TextField(
                                        focusNode: _liftScanFocusNode,
                                        decoration: const InputDecoration(
                                          hintText: '商品のバーコードをスキャン',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
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
                                  ],
                                ),
                                customExpansionTile(
                                  stepIndex: 1,
                                  title: '伝票選択',
                                  children: [
                                    for (var label in ['MM10D1124533', 'MG10D11245241', 'GG10D11245241'])
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 32),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (_selectedDenpyo != label) {
                                              await _playStepSound(2);
                                              setState(() {
                                                _selectedDenpyo = label;
                                                _stepCompleted[1] = true;
                                                _expandedStep = 2;
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: _selectedDenpyo == label ? Colors.blue : Colors.black26,
                                              ),
                                              color: _selectedDenpyo == label
                                                  ? Colors.blue.shade50
                                                  : (_selectedDenpyo.isNotEmpty ? Colors.grey.shade200 : null),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              label,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),

                                customExpansionTile(
                                  stepIndex: 2,
                                  title: 'ロット確認',
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Y2025D05M00XXX',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: 'Helvetica Neue',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 344,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await _playStepSound(3);
                                          setState(() {
                                            _stepCompleted[2] = true;
                                            _expandedStep = 3;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          '確認',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Helvetica Neue',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                customExpansionTile(
                                  stepIndex: 3,
                                  title: 'ASNラベルスキャン or 印刷',
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
                                          await _playStepSound(4); // asn-scan.ogg
                                          setState(() {
                                            _stepCompleted[3] = true;
                                            _expandedStep = 4;
                                          });
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
                                      ),
                                    ),
                                  ],
                                ),
                                customExpansionTile(
                                  stepIndex: 4,
                                  title: '最終チェック',
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text('全工程が完了していることを確認し、完了ボタンを押してください。'),
                                    ),
                                    SizedBox(
                                      width: 344,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() => _showModal = true);
                                          await Future.delayed(const Duration(seconds: 1));
                                          await _audioPlayer.play(AssetSource('sounds/kenpin-kanryo.ogg'));
                                          await Future.delayed(const Duration(seconds: 2));
                                          if (!mounted) return;
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) => const MenuScreen(),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration: Duration.zero,
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          '検品完了',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Helvetica Neue',
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
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    '検品完了',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customExpansionTile({
    required int stepIndex,
    required String title,
    required List<Widget> children,
  }) {
    final isExpanded = _expandedStep == stepIndex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() => _expandedStep = isExpanded ? -1 : stepIndex);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildLeadingIcon(stepIndex),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
          firstChild: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(children: children),
          ),
          secondChild: const SizedBox.shrink(),
        ),
        const Divider(height: 1),
      ],
    );
  }
}