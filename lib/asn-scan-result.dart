import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu.dart';
import 'package:otk_wms_mock/tranceport-3.dart';
import 'package:otk_wms_mock/tranceport-kakuno-3.dart'; // MenuScreen


class ASNScanResultScreen extends StatefulWidget {
  final int currentStep;

  const ASNScanResultScreen({super.key, required this.currentStep});

  @override
  State<ASNScanResultScreen> createState() => _ASNScanResultScreenState();
}

class _ASNScanResultScreenState extends State<ASNScanResultScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _liftScanFocusNode = FocusNode();
  late String _destination;
  late String _productName;
  late String _status;
  bool _isLoading = true;

  final List<String> _destinations = [
    '搬送待ち', '格納待ち', '在庫',
  ];

  @override
  void initState() {
    super.initState();
    final random = Random();
    _status = _destinations[random.nextInt(_destinations.length)];
    _destination = _generateRandomDestination();
    _productName = _generateRandomProductName();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() => _isLoading = false);
      FocusScope.of(context).requestFocus(_liftScanFocusNode);
    });
  }

  String _generateRandomDestination() {
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final code = List.generate(3, (_) => letters[random.nextInt(letters.length)]).join();
    final number = random.nextInt(1000).toString().padLeft(3, '0');
    return '$code-$number';
  }

  String _generateRandomProductName() {
    final random = Random();
    final productList = [
      '大塚生食100ml',
      '大塚生食50ml',
      '大塚生食500ml',
      'ビーフリード1000ml',
      'KN1号輸液200ml',
      'KN1号輸液500ml',
      'KN2号輸液200ml',
      'KN2号輸液500ml',
      'KN3号輸液200ml',
      'KN3号輸液500ml',
      'KN4号輸液200ml',
      'KN4号輸液500ml',
    ];
    return productList[random.nextInt(productList.length)];
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _liftScanFocusNode.dispose();
    super.dispose();
  }

  int _getCurrentStep(String status) {
    switch (status) {
      case '入庫済み':
        return 0;
      case '搬送待ち':
        return 1;
      case '格納待ち':
        return 2;
      case '在庫':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 3), // 太枠
              borderRadius: BorderRadius.circular(40),          // 角丸
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40), // 外枠と同じ角丸
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(child: _buildMainScreen()),
                      ],
                    ),
                    if (_isLoading)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AppBar(
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
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.currentStep == 1
                    ? OutlinedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const MenuScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                            (route) => false, // すべての前のルートを削除
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
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          if (!_isLoading) ...[
            const SizedBox(height: 16),
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
                      '搬送作業を行う',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Helvetica Neue',
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepBarVertical(int currentStep) {
    List<String> steps;
    switch (_status) {
      case '搬送待ち':
        steps = ['入庫済み', '搬送待ち', '格納待ち', '在庫　　'];
        break;
      case '格納待ち':
        steps = ['入庫済み', '搬送済み', '格納待ち', '在庫　　'];
        break;
      case '在庫':
        steps = ['入庫済み', '搬送済み', '格納済み', '在庫　　'];
        break;
      default:
        steps = ['入庫待ち', '搬送待ち', '格納待ち', '在庫　　'];
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
}