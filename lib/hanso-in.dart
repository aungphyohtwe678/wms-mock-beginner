// 搬送ステップ画面（1画面に統合）
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/shiwake.dart';
import 'package:otk_wms_mock/sub-menu1.dart';

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
  int _completedCount = 1;

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
    body: Stack(
      children: [
        // ① AspectRatio内のUI（中央に配置）
        Center(
          child: AspectRatio(
            aspectRatio: 9 / 19.5,
            child: Container(
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
                                        visible: !_isFirstLocked, // ← 1枚目のラベルを読み取ったら非表示
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
                                  '搬送件数：$_completedCount/2',
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
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                            child: TextField(
                                              controller: _asnController1,
                                              focusNode: _asnFocus1,
                                              textInputAction: TextInputAction.done,
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

                                                  if (input.toLowerCase() == 'shiwake') {
                                                    await _playSound('sounds/shiwake-ari.ogg');
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      Future.delayed(const Duration(seconds: 3), () {
                                                        if (Navigator.canPop(context)) {
                                                          Navigator.pop(context); // モーダルを閉じる
                                                          Navigator.pushReplacement(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (_, __, ___) => const ShiwakeStartScreen(),
                                                              transitionDuration: Duration.zero,
                                                            ),
                                                          );
                                                        }
                                                      });

                                                      return Dialog(
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                        backgroundColor: Colors.white,
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: const [
                                                              Text(
                                                                '仕分けが必要です',
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: 'Helvetica Neue',
                                                                  color: Colors.black,
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              SizedBox(height: 12),
                                                              Text(
                                                                '仕分け作業を行ってください',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: 'Helvetica Neue',
                                                                  color: Colors.black,
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              SizedBox(height: 24),
                                                              CircularProgressIndicator(color: Colors.black),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                  return;
                                                }
                                                // --- 「1」が入力された場合、即ステップ完了として次へ進む処理 ---
                                                if (input == '1') {
                                                  await _playSound('sounds/pi.ogg');
                                                  setState(() {
                                                    _stepCompleted[0] = true;
                                                    _expandedStep = 1;
                                                    _isFirstLocked = true;
                                                    _asnController1.clear();
                                                  });
                                                  await Future.delayed(const Duration(milliseconds: 500));
                                                  FocusScope.of(context).requestFocus(_liftFocus);
                                                  await _audioPlayer.play(AssetSource('sounds/hanso.ogg'));
                                                  return;
                                                }

                                                // 1回目処理
                                                setState(() {
                                                  _isFirstLocked = true;
                                                  _isError = false;
                                                  _asnController1.clear(); // 入力をクリア
                                                });

                                                await _playSound('sounds/pi.ogg');
                                                await Future.delayed(const Duration(milliseconds: 100));
                                                FocusScope.of(context).requestFocus(_asnFocus1); // 同じ場所に再度フォーカス
                                              } else {
                                                // 2回目処理（空でエンター押された場合
                                                  await _playSound('sounds/pi.ogg');
                                                  setState(() {
                                                    _stepCompleted[0] = true;
                                                    _expandedStep = 1;
                                                  });
                                                  await Future.delayed(const Duration(milliseconds: 500));
                                                  FocusScope.of(context).requestFocus(_liftFocus);
                                                  await _audioPlayer.play(AssetSource('sounds/hanso.ogg'));
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
                                  title: '搬送先確認',
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(_destination, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: TextField(
                                        focusNode: _liftFocus,
                                        onSubmitted: (_) async {
                                          setState(() {
                                            _stepCompleted[1] = true;
                                            _showModal = true;
                                          });

                                          await _playSound('sounds/pi.ogg');
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          await _playSound('sounds/hanso-kanryo.ogg');
                                          await Future.delayed(const Duration(seconds: 2));

                                          if (!mounted) return;

                                          if (_completedCount >= 2) {
                                            // 2回目終了 → サブメニューに遷移
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) => const SubMenu1Screen(),
                                                transitionDuration: Duration.zero,
                                              ),
                                            );
                                          } else {
                                            // 1回目終了 → 状態をリセットして2回目へ
                                            setState(() {
                                              _completedCount += 1;
                                              _isFirstLocked = false;
                                              _asnController1.clear();
                                              _asnController2.clear();
                                              _stepCompleted = [false, false, false];
                                              _expandedStep = 0;
                                              _showModal = false;
                                            });
                                            await Future.delayed(const Duration(milliseconds: 100));
                                            FocusScope.of(context).requestFocus(_asnFocus1);
                                            await _playSound('sounds/hanso-asn.ogg');
                                          }
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
                        ]
                      ),
                  ),
                )
              )
            ),
          ),
        ),
        //           Align(
        //             alignment: Alignment.topLeft,
        //             child: Padding(
        //               padding: const EdgeInsets.only(left: 16, top: 10), // BottomNavの高さ＋余白
        //               child: Column(
        //                 mainAxisSize: MainAxisSize.min,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text('該当業務フロー',style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 20,
        //                               fontFamily: 'Helvetica Neue',
        //                             ),),
        //                   Text('→v0.7.0/1-4-1,1-4-2',style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 20,
        //                               fontFamily: 'Helvetica Neue',
        //                             ),),
        //                             const SizedBox(height: 8),
        //                   Text('パターン１：パレット１枚・仕分けなし',style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 15,
        //                               fontFamily: 'Helvetica Neue',
        //                             ),),
        //                   const Text('・「搬送するASNラベルをスキャンしてください」音声'),
        //                   const Text('・ASNラベルスキャンにフォーカスが当たる'),
        //                   const Text('・「1」と入力すると即搬送ステップへ進む'),
        //                   const Text('・「A-1（昇降機名）に搬送しQRコードをスキャンしてください」音声'),
        //                   const Text('・搬送先QRスキャン完了で1件終了、2件完了後はサブメニューへ戻る'),
        //                   const SizedBox(height: 8),
        //                   Text('パターン２：パレット２枚・仕分けなし',style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 15,
        //                               fontFamily: 'Helvetica Neue',
        //                             ),),
        //                   const Text('・「搬送するASNラベルをスキャンしてください」音声'),
        //                   const Text('・ASNラベルスキャンにフォーカスが当たる'),
        //                   const Text('・何も入力せず、2回Enter'),
        //                   const Text('・「１パレ目→２パレ目」とスキャン進捗更新'),
        //                   const Text('・「A-1（昇降機名）に搬送しQRコードをスキャンしてください」音声'),
        //                   const Text('・搬送先QRスキャン完了で1件終了、2件完了後はサブメニューへ戻る'),
        //                   const SizedBox(height: 8),
        //                   Text('パターン３：仕分けあり',style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 15,
        //                               fontFamily: 'Helvetica Neue',
        //                             ),),
        //                   const Text('・「搬送するASNラベルをスキャンしてください」音声'),
        //                   const Text('・ASNラベルスキャンにフォーカスが当たる'),
        //                   const Text('・「shiwake」と入力しEnter'),
        //                   const Text('・「混載パレットです。仕分けを行なってください。」音声'),
        //                   const Text('・仕分けモーダル表示'),
        //                   const Text('・仕分け画面に遷移'),
        //                   const Text('※仕分けが終わったら再度「搬送」から'),
        //                   const SizedBox(height: 8),
        //                   Text('確認',style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 15,
        //                               fontFamily: 'Helvetica Neue',
        //                             ),),
        //                   Text(
        //   '・昇降機QRコードはどのような形式で何桁を想定？',
        //   style: TextStyle(
            
        //     fontFamily: 'Helvetica Neue',
        //     color: Colors.red, // ← 赤文字
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        //                 ],
        //               ),
        //             ),
        //           ),
      ]
  )
  );
  
}
}