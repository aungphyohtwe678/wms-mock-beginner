import 'package:flutter/material.dart';
import 'package:otk_wms_mock/kenpin1.dart';
import 'package:otk_wms_mock/menu1.dart';
import 'package:otk_wms_mock/tumituke.dart';

class SubMenu3Screen extends StatefulWidget {
  const SubMenu3Screen({super.key});

  @override
  State<SubMenu3Screen> createState() => _SubMenu3ScreenState();
}

class _SubMenu3ScreenState extends State<SubMenu3Screen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => MenuScreen(
          initialSelectedIndex: index,
          initialSelectedCategoryIndex: -1,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(40),
              ),
              clipBehavior: Clip.antiAlias,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.5),
                  title: const Text(
                    '検品メニュー',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvetica Neue',
                    ),
                  ),
                  centerTitle: true,
                  actions: [],
                ),
                body: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      left: 16,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const MenuScreen(),
                              transitionDuration: Duration.zero,
                            ),
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
                        child: const Text('戻る',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Helvetica Neue',
                            )),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _menuButton(context, '検品', const KenpinStartScreen()),
                          const SizedBox(height: 16),
                          _menuButton(context, '積み付け確認（バラ用）', const TumitukeScreen()),
                        ],
                      ),
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
                        offset: const Offset(0, -2),
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
                      BottomNavigationBarItem(icon: Icon(Icons.inbox), label: '入荷'),
                      BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: '出荷'),
                      BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: '移動'),
                      BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'その他'),
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

  Widget _menuButton(BuildContext context, String label, Widget screen) {
    return FractionallySizedBox(
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
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => screen,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
