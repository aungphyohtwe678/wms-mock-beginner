// 搬送ステップ画面（1画面に統合）
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/menu.dart';

class TransportInScreen extends StatefulWidget {
  const TransportInScreen({super.key});

  @override
  State<TransportInScreen> createState() => _TransportInScreenState();
}

class _TransportInScreenState extends State<TransportInScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final TextEditingController _asnController1 = TextEditingController();
  final TextEditingController _asnController2 = TextEditingController();
  final FocusNode _asnFocus1 = FocusNode();
  final FocusNode _asnFocus2 = FocusNode();
  final FocusNode _liftFocus = FocusNode();

  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false];
  bool _showModal = false;
  bool _isFirstLocked = false;
  bool _isError = false;
  String _errorMessage = '';
  String _destination = '昇降機A-①';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/hanso-asn.ogg'));
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
                          '搬送',
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
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                            child: TextField(
                                              controller: _asnController1,
                                              focusNode: _asnFocus1,
                                              enabled: !_isFirstLocked,
                                              onSubmitted: (_) async {
                                                if (_asnController1.text.trim().isEmpty) {
                                                  setState(() {
                                                    _isError = true;
                                                    _errorMessage = '1枚目のラベルが未入力です';
                                                  });
                                                  await _playSound('sounds/ng-null.ogg');
                                                  return;
                                                }
                                                setState(() {
                                                  _isFirstLocked = true;
                                                  _isError = false;
                                                });
                                                await _playSound('sounds/pi.ogg');
                                                FocusScope.of(context).requestFocus(_asnFocus2);
                                              },
                                              decoration: const InputDecoration(
                                                hintText: '1枚目のASNラベルをスキャン',
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                              child: TextField( 
                                              controller: _asnController2,
                                              focusNode: _asnFocus2,
                                              onSubmitted: (_) async {
                                                await _playSound('sounds/pi.ogg');
                                                setState(() {
                                                  _stepCompleted[0] = true;
                                                  _expandedStep = 1;
                                                });
                                                await Future.delayed(const Duration(milliseconds: 500));
                                                FocusScope.of(context).requestFocus(_liftFocus);
                                                await _audioPlayer.play(AssetSource('sounds/hanso.ogg'));
                                              },
                                              decoration: const InputDecoration(
                                                hintText: '2枚目のASNラベルをスキャン',
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
                                  title: '搬送先確認',
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(_destination, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: TextField(
                                        focusNode: _liftFocus,
                                        onSubmitted: (_) async {
                                          setState(() => _showModal = true);
                                          await _playSound('sounds/pi.ogg');
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _playSound('sounds/hanso-kanryo.ogg');
                                          await Future.delayed(const Duration(seconds: 2));
                                          if (!mounted) return;
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) => const MenuScreen(),
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
                                        },
                                        decoration: const InputDecoration(
                                          hintText: '昇降機のQRコードをスキャン',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 400,
                                      margin: const EdgeInsets.symmetric(horizontal: 32),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.asset('assets/images/hanso-qr.png', fit: BoxFit.cover),
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
                                  Text('搬送完了', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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