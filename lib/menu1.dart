import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:otk_wms_mock/asn-scan.dart';
import 'package:otk_wms_mock/direct-move.dart';
import 'package:otk_wms_mock/hanso-out.dart';
import 'package:otk_wms_mock/kakuno-pcs.dart';
import 'package:otk_wms_mock/kakuno-cs.dart';
import 'package:otk_wms_mock/kenpin1.dart';
import 'package:otk_wms_mock/kinkyu-moto-sentaku.dart';
import 'package:otk_wms_mock/kinkyu-saki-sentaku.dart';
import 'package:otk_wms_mock/konpo.dart';
import 'package:otk_wms_mock/label-sai.dart';
import 'package:otk_wms_mock/main.dart';
import 'package:otk_wms_mock/picking-sentaku.dart';
import 'package:otk_wms_mock/shiwake.dart';
import 'package:otk_wms_mock/sub-menu1.dart';
import 'package:otk_wms_mock/sub-menu2.dart';
import 'package:otk_wms_mock/sub-menu3.dart';
import 'package:otk_wms_mock/sub-menu4.dart';
import 'package:otk_wms_mock/sub-menu5.dart';
import 'package:otk_wms_mock/tanaoroshi.dart';
import 'package:otk_wms_mock/kakuno-pl.dart';
import 'package:otk_wms_mock/hanso-in.dart';
import 'package:otk_wms_mock/tumituke.dart';
import 'package:otk_wms_mock/error.dart';
import 'package:otk_wms_mock/shijinashi.dart';
import 'package:otk_wms_mock/update.dart';

class MenuScreen extends StatefulWidget {
  final int initialSelectedIndex;
  final int initialSelectedCategoryIndex;

  const MenuScreen({
    super.key,
    this.initialSelectedIndex = 0,
    this.initialSelectedCategoryIndex = -1,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late int _selectedIndex;
  int? _selectedCategoryIndex;
  bool _hasInitializedPageJump = false;

  final PageController _pageController = PageController();
@override
void initState() {
  super.initState();
  _selectedIndex = widget.initialSelectedIndex;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _pageController.jumpToPage(_selectedIndex);
    setState(() {
      _selectedCategoryIndex = widget.initialSelectedCategoryIndex;
    });
  });
}


  final List<List<String>> _mainCategoriesList = [
  // 入荷
  ['搬送', '格納', '検品'],
  // 出荷
  ['緊急補充', 'ピッキング', '搬送（出荷）', '荷合わせ', '荷捌き場'],
  // 移動
  ['ダイレクト移動'],
  // その他
  ['作業状況検索', 'ラベル再印刷', '棚卸'],
];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedCategoryIndex = -1;
    });
    _pageController.jumpToPage(index); // ← これを追加
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
                    body: Column(
                      children: [
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: const ScrollBehavior().copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse, // ← マウスのドラッグを許可
                              },
                            ),
                            child: PageView(
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              onPageChanged: (index) {
                                if (!_hasInitializedPageJump) {
                                  _hasInitializedPageJump = true;
                                  return;
                                }

                                setState(() {
                                  _selectedIndex = index;
                                  _selectedCategoryIndex = -1;
                                });
                              },
                              children: List.generate(4, (index) {
                                final showSubMenu = _selectedIndex == index && _selectedCategoryIndex != -1;
                                return Center(
                                  child: showSubMenu
                                      ? _buildSubMenu()
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(
                                            _mainCategoriesList[index].length,
                                            (i) => Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              child: _buildMainCategoryButton(_mainCategoriesList[index][i], i),
                                            ),
                                          ),
                                        ),
                                );
                              
                            }),
                          ),
                          )
                        ),
                      ],
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 72), // BottomNavの高さ＋余白
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _quickButton(context, '指示なし', const ShijinashiScreen()),
                  const SizedBox(height: 8),
                  _quickButton(context, 'システムエラー', const SystemErrorScreen()),
                  const SizedBox(height: 8),
                  _quickButton(context, 'アップデート', const UpdateScreen()),
                ],
              ),
            ),
          ),

        ],
      )
    );
  }

Widget _buildSubMenu() {
final subMenus = [
  // 入荷: index 0〜2
  [
    {'label': '搬送（入庫）', 'screen': const TransportInScreen()},
    {'label': '仕分け', 'screen': const ShiwakeStartScreen()},
  ],
  [
    {'label': '格納（PL）', 'screen': const KakunoPLScreen()},
    {'label': '格納（CS）', 'screen': const KakunoCSScreen()},
    {'label': '格納（PCS）', 'screen': const KakunoPCSScreen()},
  ],
  [
    {'label': '検品', 'screen': const KenpinStartScreen()},
    {'label': '積み付け確認（バラ用）', 'screen': const TumitukeScreen()},
  ],

  // 出荷: index 3〜7
  [
    {'label': '緊急補充（元ロケ出庫）', 'screen': const KinkyuMotoSentakuScreen()},
    {'label': '緊急補充（先ロケ入庫）', 'screen': const KinkyuSakiSentakuScreen()},
  ],
  [
    {'label': 'ピッキング', 'screen': const PickInstructionScreen()},
    {'label': '梱包', 'screen': const KonpoScreen()},
  ],
  [
    {'label': '搬送（出荷）', 'screen': const TransportOutScreen()},
  ],
  [
    {'label': '荷合わせ', 'screen': const SystemErrorScreen()},
  ],
  [
    {'label': '荷捌き場', 'screen': const SystemErrorScreen()},
  ],

  // 移動: index 8
  [
    {'label': 'ダイレクト移動', 'screen': const DirectMoveScreen()},
  ],

  // その他: index 9〜11
  [
    {'label': '作業状況検索', 'screen': const ASNScanScreen()},
  ],
  [
    {'label': 'ラベル再印刷', 'screen': const LabelSaiScreen()},
  ],
  [
    {'label': '棚卸', 'screen': const TanaoroshiScreen()},
  ],
];

  final currentSubMenu = () {
    if (_selectedCategoryIndex == null || _selectedCategoryIndex == -1) return [];

    switch (_selectedIndex) {
      case 0: // 入荷
        return subMenus[_selectedCategoryIndex!];
      case 1: // 出荷
        return subMenus[_selectedCategoryIndex! + 3];
      case 2: // 移動（1カテゴリのみ）
        return subMenus[8];
      case 3: // その他（3カテゴリ）
        return subMenus[_selectedCategoryIndex! + 9];
      default:
        return [];
    }
  }();

  return Stack(
    children: [
      // 戻るボタン（左上固定）
      Positioned(
        top: 8,
        left: 8,
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedCategoryIndex = -1;
            });
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

      // サブメニュー中央配置
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: currentSubMenu.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    final submenuScreens = {
                      0: {
                        0: const SubMenu1Screen(),
                        1: const SubMenu2Screen(),
                        2: const SubMenu3Screen(),
                      },
                      1: {
                        0: const SubMenu4Screen(),
                        1: const SubMenu5Screen(),
                      },
                    };

                    final submenuTarget = submenuScreens[_selectedIndex]?[index];
                    if (submenuTarget != null) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => submenuTarget,
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                      return;
                    }

                    final instantNavigateMap = {
                      1: {
                        2: const TransportOutScreen(),
                        3: const SystemErrorScreen(),
                        4: const SystemErrorScreen(),
                      },
                      2: {
                        0: const DirectMoveScreen(),
                      },
                      3: {
                        0: const ASNScanScreen(),
                        1: const LabelSaiScreen(),
                        2: const TanaoroshiScreen(),
                      }
                    };

                    final target = instantNavigateMap[_selectedIndex]?[index];
                    if (target != null) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => target,
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    } else {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    }
                  },
                  child: Text(
                    item['label'] as String,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}

Widget _buildMainCategoryButton(String title, int index) {
  final subMenuDirectMap = {
    0: { // 入荷
      0: const SubMenu1Screen(),
      1: const SubMenu2Screen(),
      2: const SubMenu3Screen(),
    },
    1: { // 出荷
      0: const SubMenu4Screen(),
      1: const SubMenu5Screen(),
    },
  };

  final instantNavigateMap = {
    1: {
      2: const TransportOutScreen(),
      3: const SystemErrorScreen(),
      4: const SystemErrorScreen(),
    },
    2: {
      0: const DirectMoveScreen(),
    },
    3: {
      0: const ASNScanScreen(),
      1: const LabelSaiScreen(),
      2: const TanaoroshiScreen(),
    }
  };

  return Center(
    child: FractionallySizedBox(
      widthFactor: 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {
          // ✅ サブメニュー画面への即遷移対応
          final submenuTarget = subMenuDirectMap[_selectedIndex]?[index];
          if (submenuTarget != null) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => submenuTarget,
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            return;
          }

          // ✅ その他即遷移マップ
          final target = instantNavigateMap[_selectedIndex]?[index];
          if (target != null) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => target,
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            return;
          }

          // ✅ 通常のサブメニュー展開
          setState(() {
            _selectedCategoryIndex = index;
          });
        },
        child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      ),
    ),
  );
}



  Widget _quickButton(BuildContext context, String label, Widget target) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black26,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    onPressed: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => target,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    },
    child: Text(label, style: const TextStyle(fontSize: 14)),
  );
}
}