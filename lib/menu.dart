import 'package:flutter/material.dart';
import 'package:otk_wms_mock/asn-scan.dart';
import 'package:otk_wms_mock/kenpin1.dart';
import 'package:otk_wms_mock/kinkyu-moto-sentaku.dart';
import 'package:otk_wms_mock/kinkyu-saki-sentaku.dart';
import 'package:otk_wms_mock/main.dart';
import 'package:otk_wms_mock/picking-sentaku.dart';
import 'package:otk_wms_mock/shiwake1.dart';
import 'package:otk_wms_mock/tranceport-kakuno.dart';
import 'package:otk_wms_mock/tranceport.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;

  final List<List<String>> _menuItems = [
    ['検品', '搬送', '仕分け', '格納'],
    ['緊急補充（元ロケ出庫）', '緊急補充（先ロケ入庫）', 'ピック開始', '梱包', '搬送', '荷合わせ', '荷捌き場設定'],
    ['ダイレクト移動'],
    ['作業状況検索', 'ラベル再印刷', '棚卸'],
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
              border: Border.all(color: Colors.black, width: 3), // 黒い枠
              borderRadius: BorderRadius.circular(40),           // 角丸
            ),
            clipBehavior: Clip.antiAlias, // はみ出し防止
            child: SafeArea(              // ダイナミックアイランド対応
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.5),
                  title: const Text(
                    'メニュー',
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
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(-1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeOut;
                                          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          final offsetAnimation = animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
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
                body: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    itemCount: _menuItems[_selectedIndex].length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final title = _menuItems[_selectedIndex][index];
                      return _buildMenuItem(title);
                    },
                  ),
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.black,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white70,
                    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.inbox),
                        label: '入荷',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.local_shipping),
                        label: '出荷',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.swap_horiz),
                        label: '移動',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.more_horiz),
                        label: 'その他',
                      ),
                    ],
                    type: BottomNavigationBarType.fixed,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: GestureDetector(
          onTap: () async {
            Widget? screen;
            if (title == '搬送') {
              screen = const PalletLabelScanScreen();
            } else if (title == '検品') {
              screen = const KenpinStartScreen();
            } else if (title == '仕分け') {
              screen = const ShiwakeStartScreen();
            } else if (title == '格納') {
              screen = const PalletLabelScanKakunoScreen();
            } else if (title == '作業状況検索') {
              screen = const ASNScanScreen();
            } else if (title == 'ピック開始') {
              screen = const PickInstructionScreen();
            } else if (title == '緊急補充（元ロケ出庫）') {
              screen = const KinkyuMotoSentakuScreen();
            } else if (title == '緊急補充（先ロケ入庫）') {
              screen = const KinkyuSakiSentakuScreen();
            }

            if (screen != null) {
              final result = await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => screen!,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );

              if (result is int) {
                setState(() {
                  _selectedIndex = result;
                });
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Helvetica Neue',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}