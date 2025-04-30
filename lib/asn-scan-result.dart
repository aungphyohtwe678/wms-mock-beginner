import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
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
      'カロリーメイト',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Stack(
            children: [
              _buildMainScreen(),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainScreen() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
          title: const Text(
            'ANS検索結果',
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
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.currentStep == 1
                      ? OutlinedButton(
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
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            if (!_isLoading) ...[
              const SizedBox(height: 24),
              const Text(
                '進捗',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Helvetica Neue',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _status,
                style: const TextStyle(
                  fontSize: 48,
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
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
        )
      )
    );
  }
}