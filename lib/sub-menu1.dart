import 'package:flutter/material.dart';
import 'package:otk_wms_mock/main.dart';
import 'package:otk_wms_mock/menu1.dart';
import 'package:otk_wms_mock/shiwake.dart';
import 'package:otk_wms_mock/hanso-in.dart';

import 'l10n/app_localizations.dart';

class SubMenu1Screen extends StatefulWidget {
  const SubMenu1Screen({super.key});

  @override
  State<SubMenu1Screen> createState() => _SubMenu1ScreenState();
}

class _SubMenu1ScreenState extends State<SubMenu1Screen> {
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
                    '搬送メニュー',
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
                                        pageBuilder: (context, _, __) => const LoginPage(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                      (route) => false,
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
                                  onPressed: () => Navigator.pop(context),
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
                        child: Text(AppLocalizations.of(context)!.back,
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
                          _menuButton(context, AppLocalizations.of(context)!.receiving_transport, const TransportInScreen()),
                          const SizedBox(height: 16),
                          _menuButton(context, AppLocalizations.of(context)!.sorting, const ShiwakeStartScreen()),
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
                            label: AppLocalizations.of(context)!.receiving,
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.local_shipping),
                            label: AppLocalizations.of(context)!.shipping,
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.swap_horiz),
                            label: AppLocalizations.of(context)!.move,
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.more_horiz),
                            label: AppLocalizations.of(context)!.others,
                          ),
                        ],
                        type: BottomNavigationBarType.fixed,
                      ),
                    ),
              )
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
