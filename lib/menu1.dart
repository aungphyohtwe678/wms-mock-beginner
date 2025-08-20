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
import 'package:otk_wms_mock/l10n/app_localizations_en.dart';
import 'package:otk_wms_mock/label-sai.dart';
import 'package:otk_wms_mock/main.dart';
import 'package:otk_wms_mock/picking-sentaku.dart';
import 'package:otk_wms_mock/shiwake.dart';
import 'package:otk_wms_mock/sub-menu1.dart';
import 'package:otk_wms_mock/sub-menu2.dart';
import 'package:otk_wms_mock/sub-menu3.dart';
import 'package:otk_wms_mock/sub-menu4.dart';
import 'package:otk_wms_mock/sub-menu5.dart';
import 'package:otk_wms_mock/tanaoroshi-sentaku.dart';
import 'package:otk_wms_mock/tanaoroshi.dart';
import 'package:otk_wms_mock/kakuno-pl.dart';
import 'package:otk_wms_mock/hanso-in.dart';
import 'package:otk_wms_mock/tumituke.dart';
import 'package:otk_wms_mock/error.dart';
import 'package:otk_wms_mock/shijinashi.dart';
import 'package:otk_wms_mock/update.dart';

import 'l10n/app_localizations.dart';

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


  List<List<String>> _mainCategoriesList(BuildContext context) => [
  // 入荷
  [
    AppLocalizations.of(context)!.transport,
    AppLocalizations.of(context)!.storage,
    AppLocalizations.of(context)!.inspection
  ],
  // 出荷
  [
    AppLocalizations.of(context)!.emergency_replenishment,
    AppLocalizations.of(context)!.picking,
    AppLocalizations.of(context)!.shipping_transport,
    AppLocalizations.of(context)!.consolidation,
    AppLocalizations.of(context)!.sorting_area
  ],
  // 移動
  [
    AppLocalizations.of(context)!.direct_movement
  ],
  // その他
  [
    AppLocalizations.of(context)!.work_status_search,
    AppLocalizations.of(context)!.label_reprint,
    AppLocalizations.of(context)!.inventory
  ],
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // 黒い枠
                borderRadius: BorderRadius.zero,           // 角丸
              ),
              clipBehavior: Clip.antiAlias, // はみ出し防止
              child: SafeArea(              // ダイナミックアイランド対応
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.black,
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.5),
                    title: Text(
                      AppLocalizations.of(context)!.menu_title,
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
        children: [
          Text(
            AppLocalizations.of(context)!.notifications,
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
                                Text(
                                  AppLocalizations.of(context)!.general_worker('山田太郎'),
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
                                    child: Text(AppLocalizations.of(context)!.logout),
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
                                    child: Text(AppLocalizations.of(context)!.accident_report),
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
                                          _mainCategoriesList(context)[index].length,
                                          (i) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: _buildMainCategoryButton(_mainCategoriesList(context)[index][i], i),
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
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.inbox),
                          label: AppLocalizations.of(context)!.receiving, // 'Receiving' in English, '入荷' in Japanese
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.local_shipping),
                          label: AppLocalizations.of(context)!.shipping, // 'Shipping' in English, '出荷' in Japanese
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.swap_horiz),
                          label: AppLocalizations.of(context)!.move, // 'Movement' in English, '移動' in Japanese
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.more_horiz),
                          label: AppLocalizations.of(context)!.others, // 'Others' in English, 'その他' in Japanese
                        ),
                      ],
                      type: BottomNavigationBarType.fixed,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 16, top: 10), // BottomNavの高さ＋余白
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text('該当業務フロー：なし',style: TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 20,
          //                             fontFamily: 'Helvetica Neue',
          //                           ),),
          //         Text('パターン１：入荷関連',
          //         style: TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 18,
          //                             fontFamily: 'Helvetica Neue',
          //                           ),),
          //         Text('搬送'),
          //         Text('格納'),
          //         Text('検品'),
          //         Text('フッターアイコン「入荷」白、そのほかグレー'),
          //         Text('※「入荷」メニューが初期表示'),
          //         const SizedBox(height: 8),
          //         Text('パターン２：出荷関連',style: TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 18,
          //                             fontFamily: 'Helvetica Neue',
          //                           ),),
          //         Text('緊急補充'),
          //         Text('ピッキング'),
          //         Text('搬送（出荷）'),
          //         Text('荷合わせ'),
          //         Text('荷捌き場'),
          //         Text('フッターアイコン「出荷」白、そのほかグレー'),
          //         const SizedBox(height: 8),
          //         Text('パターン３：移動関連',
          //         style: TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 18,
          //                             fontFamily: 'Helvetica Neue',
          //                           ),),
          //         Text('ダイレクト移動'),
          //         Text('フッターアイコン「移動」白、そのほかグレー'),
          //         const SizedBox(height: 8),
          //         Text('パターン４：その他',style: TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 18,
          //                             fontFamily: 'Helvetica Neue',
          //                           ),),
          //         Text('作業状況検索'),
          //         Text('ラベル再印刷'),
          //         Text('棚卸し'),
          //         Text('フッターアイコン「出荷」白、そのほかグレー'),
          //         Text(
          //           '・通知アイコン「🔔」を追加／人アイコンの隣',
          //           style: TextStyle(
                      
          //             fontFamily: 'Helvetica Neue',
          //             color: Colors.blue, // ← 赤文字
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         Text(
          //           '・荷捌きば設定　はその他　に移動したいかも（後ほど確定した後に移すかも）',
          //           style: TextStyle(
                      
          //             fontFamily: 'Helvetica Neue',
          //             color: Colors.red, // ← 赤文字
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         Text(
          //           '・移動　と言うメニューがあること自体が違和感ではある',
          //           style: TextStyle(
                      
          //             fontFamily: 'Helvetica Neue',
          //             color: Colors.red, // ← 赤文字
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 72), // BottomNavの高さ＋余白
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _quickButton(context, AppLocalizations.of(context)!.no_instructions, const ShijinashiScreen()),
                  const SizedBox(height: 8),
                  _quickButton(context, AppLocalizations.of(context)!.system_error, const SystemErrorScreen()),
                  const SizedBox(height: 8),
                  _quickButton(context, AppLocalizations.of(context)!.update, const UpdateScreen()),
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
    {'label': AppLocalizations.of(context)!.receiving_transport, 'screen': const TransportInScreen()},
    {'label': AppLocalizations.of(context)!.sorting, 'screen': const ShiwakeStartScreen()},
  ],
  [
    {'label': '格納（PL）', 'screen': const KakunoPLScreen()},
    {'label': '格納（CS）', 'screen': const KakunoCSScreen()},
    {'label': '格納（PCS）', 'screen': const KakunoPCSScreen()},

    {'label': AppLocalizations.of(context)!.storage_pl, 'screen': const KakunoPLScreen()},
    {'label': AppLocalizations.of(context)!.storage_cs, 'screen': const KakunoCSScreen()},
    {'label': AppLocalizations.of(context)!.storage_pcs, 'screen': const KakunoPCSScreen()},
  ],
  [
    {'label': AppLocalizations.of(context)!.inspection, 'screen': const KenpinStartScreen()},
    {'label': AppLocalizations.of(context)!.stacking_confirmation, 'screen': const TumitukeScreen()},
  ],

  // 出荷: index 3〜7
  [
    {'label': AppLocalizations.of(context)!.emergency_source_location, 'screen': const KinkyuMotoSentakuScreen()},
    {'label': AppLocalizations.of(context)!.emergency_destination_location, 'screen': const KinkyuSakiSentakuScreen()},
  ],
  [
    {'label': AppLocalizations.of(context)!.picking, 'screen': const PickInstructionScreen()},
    {'label': AppLocalizations.of(context)!.packing, 'screen': const KonpoScreen()},
  ],
  [
    {'label': AppLocalizations.of(context)!.shipping_transport, 'screen': const TransportOutScreen()},
  ],
  [
    {'label': AppLocalizations.of(context)!.consolidation, 'screen': const SystemErrorScreen()},
  ],
  [
    {'label': AppLocalizations.of(context)!.sorting_area, 'screen': const SystemErrorScreen()},
  ],

  // 移動: index 8
  [
    {'label': AppLocalizations.of(context)!.direct_movement, 'screen': const DirectMoveScreen()},
  ],

  // その他: index 9〜11
  [
    {'label': AppLocalizations.of(context)!.work_status_search, 'screen': const ASNScanScreen()},
  ],
  [
    {'label': AppLocalizations.of(context)!.label_reprint, 'screen': const LabelSaiScreen()},
  ],
  [
    {'label': AppLocalizations.of(context)!.inventory, 'screen': const TanaoroshiSentakuScreen()},
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
          child: Text(
            AppLocalizations.of(context)!.back,
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
                        2: const KenpinStartScreen(),
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
                        2: const TanaoroshiSentakuScreen(),
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
      2: const KenpinStartScreen(),
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
      2: const TanaoroshiSentakuScreen(),
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