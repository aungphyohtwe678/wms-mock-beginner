import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/hanso-asn.dart';
import 'package:otk_wms_mock/kakuno-asn.dart';

class ASNScanScreen extends StatefulWidget {
  final int currentStep;

  const ASNScanScreen({super.key, this.currentStep = 1});

  @override
  State<ASNScanScreen> createState() => _ASNScanScreen();
}

class _ASNScanScreen extends State<ASNScanScreen> {
  final TextEditingController _scanController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _scanFocusNode1 = FocusNode();

  bool _showError = false;
  bool _isFirstFieldLocked = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _status = '';
  String _destination = '';
  String _productName = '';
  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false];

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scanController.dispose();
    _scanFocusNode1.dispose();
    super.dispose();
  }

  Future<void> _playSound(String path) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
  }

  String _generateStatus() {
    final List<String> statuses = ['搬送待ち', '格納待ち', '在庫'];
    return statuses[DateTime.now().millisecondsSinceEpoch % statuses.length];
  }

  String _generateDestination() {
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final code = List.generate(3, (_) => letters[random.nextInt(letters.length)]).join();
    final number = random.nextInt(1000).toString().padLeft(3, '0');
    return '$code-$number';
  }

  String _generateProductName() {
    final random = Random();
    final products = [
      '大塚生食100ml', '大塚生食50ml', '大塚生食500ml', 'ビーフリード1000ml',
      'KN1号輸液200ml', 'KN1号輸液500ml', 'KN2号輸液200ml', 'KN2号輸液500ml',
      'KN3号輸液200ml', 'KN3号輸液500ml', 'KN4号輸液200ml', 'KN4号輸液500ml'
    ];
    return products[random.nextInt(products.length)];
  }

  void _validateFirstField() async {
    final text = _scanController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = 'ラベルを入力してください';
      });
      await _playSound('sounds/ng-null.ogg');
      return;
    } else if (!RegExp(r'^[a-zA-Z0-9]{3,}$').hasMatch(text)) {
      setState(() {
        _showError = true;
        _errorMessage = 'ラベルが不正です';
      });
      await _playSound('sounds/ng-label.ogg');
      return;
    }

    setState(() {
      _showError = false;
      _isFirstFieldLocked = true;
      _stepCompleted[0] = true;
      _expandedStep = 1;
      _isLoading = true;
    });

    await _playSound('sounds/pi.ogg');
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _status = _generateStatus();
      _destination = _generateDestination();
      _productName = _generateProductName();
      _isLoading = false;
    });
  }

  int _getCurrentStep(String status) {
    switch (status) {
      case '搬送待ち': return 1;
      case '格納待ち': return 2;
      case '在庫': return 3;
      default: return 0;
    }
  }

  Widget _buildStep({
    required int stepIndex,
    required String title,
    required List<Widget> children,
  }) {
    if (!_stepCompleted.sublist(0, stepIndex).every((e) => e)) return const SizedBox.shrink();
    final isExpanded = !_stepCompleted[stepIndex] && _expandedStep == stepIndex;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/asn-scan.ogg'));
      FocusScope.of(context).requestFocus(_scanFocusNode1);
    });
  }

  Widget _buildStepBarVertical(int currentStep) {
    List<String> steps;
    switch (_status) {
      case '搬送待ち':
        steps = ['検品済み', '搬送待ち', '格納待ち', '在庫　　'];
        break;
      case '格納待ち':
        steps = ['検品済み', '搬送済み', '格納待ち', '在庫　　'];
        break;
      case '在庫':
        steps = ['検品済み', '搬送済み', '格納済み', '在庫　　'];
        break;
      default:
        steps = ['検品待ち', '搬送待ち', '格納待ち', '在庫　　'];
    }

    return Center(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text(
            '　　詳細',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Helvetica Neue',
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          initiallyExpanded: true,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: 8),
          children: List.generate(steps.length, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isCompleted || (_status == '在庫' && index == steps.length - 1))
                              ? Colors.blue
                              : Colors.grey[300],
                        ),
                        child: Icon(
                          isCompleted
                              ? Icons.check
                              : isCurrent
                                  ? Icons.circle_outlined
                                  : Icons.circle_outlined,
                          size: 18,
                          color: (isCompleted || (_status == '在庫' && index == steps.length - 1))
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                      if (index < steps.length - 1)
                        Container(
                          width: 2,
                          height: 32,
                          margin: const EdgeInsets.only(top: 0),
                          color: index < currentStep ? Colors.blue : Colors.grey[300],
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted || isCurrent ? Colors.black : Colors.grey,
                        fontFamily: 'Helvetica Neue',
                        decoration: isCurrent ? TextDecoration.underline : TextDecoration.none,
                        decorationColor: isCurrent ? Colors.blue : null,
                        decorationThickness: isCurrent ? 2.0 : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

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
                          '作業状況検索',
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
                                      OutlinedButton(
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
                                      )
                                    ],
                                  ),
                                ),
                                _buildStep(
                                  stepIndex: 0,
                                  title: 'ASNラベルスキャン',
                                  children: [
                                    if (_showError)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                                      ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: TextField(
                                        controller: _scanController,
                                        focusNode: _scanFocusNode1,
                                        enabled: !_isFirstFieldLocked,
                                        onSubmitted: (_) => _validateFirstField(),
                                        decoration: const InputDecoration(
                                          hintText: 'ASNラベルをスキャン',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: 0.8,
                                      child: Container(
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
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 1,
                                  title: '作業状況確認',
                                  children: _isLoading
                                      ? [ const SizedBox(height: 44), 
                                          const CircularProgressIndicator(),
                                          const SizedBox(height: 44)
                                    ] : [
                                          const SizedBox(height: 8),
                                          if (!_isLoading) ...[
                                          const SizedBox(height: 5),
                                          const Text(
                                            'ステータス',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Helvetica Neue',
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            _status,
                                            style: const TextStyle(
                                              fontSize: 48,
                                              fontFamily: 'Helvetica Neue',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          FractionallySizedBox(
                                            widthFactor: 0.7, // ← 画面幅の70%
                                            child: _buildStepBarVertical(_getCurrentStep(_status)),
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            '商品コード',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Helvetica Neue',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            _destination,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'Helvetica Neue',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          if (_status == '在庫') ...[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'ロット',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Helvetica Neue',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const Text(
                                                  'Y2025M5D00',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontFamily: 'Helvetica Neue',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          const SizedBox(height: 12),
                                          const Text(
                                            '商品名',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Helvetica Neue',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            _productName,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'Helvetica Neue',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          if (_status == '在庫') ...[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  '格納ロケーション',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Helvetica Neue',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const Text(
                                                  '03-003-01',
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    fontFamily: 'Helvetica Neue',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          if (_status == '格納待ち')
                                            Padding(
                                              padding: const EdgeInsets.only(top: 24),
                                              child: SizedBox(
                                                width: 344,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (_, __, ___) => const KakunoLocatinoScreen2(
                                                          currentStep: 100,
                                                        ),
                                                        transitionDuration: Duration.zero,
                                                        reverseTransitionDuration: Duration.zero,
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
                                                  child: const Text(
                                                    '格納作業を行う',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Helvetica Neue',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          else if (_status == '搬送待ち')
                                            Padding(
                                              padding: const EdgeInsets.only(top: 24),
                                              child: SizedBox(
                                                width: 344,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (_, __, ___) => const LiftScanScreen2(
                                                        ),
                                                        transitionDuration: Duration.zero,
                                                        reverseTransitionDuration: Duration.zero,
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
                                                  child: const Text(
                                                    '搬送作業を行う',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Helvetica Neue',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10)
                                        ]
                                      ]
                                ),
                              ]
                            )
                          )
                        ]
                      )
                    )
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