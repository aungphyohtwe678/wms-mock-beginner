
import 'package:flutter/material.dart';
import 'package:otk_wms_mock/kakuno-pl.dart';
import 'package:otk_wms_mock/shipment_qr_scan_page.dart';

import 'l10n/app_localizations.dart';
import 'login.dart';

class TopMenuScreen extends StatefulWidget {
  final int initialSelectedIndex;
  final int initialSelectedCategoryIndex;
  final Locale? userLocale;

  const TopMenuScreen({
    super.key,
    this.initialSelectedIndex = 0,
    this.initialSelectedCategoryIndex = -1,
    this.userLocale,
  });

  @override
  State<TopMenuScreen> createState() => _TopMenuScreenState();
}

class _TopMenuScreenState extends State<TopMenuScreen> {
  Locale? currentLocale;

  @override
  void initState() {
    super.initState();
    currentLocale = widget.userLocale;
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
                      AppLocalizations.of(context)!.menu,
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
                                if (currentLocale != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'Language: ${currentLocale!.languageCode.toUpperCase()}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Set locale to Japanese when logging out
                                      setState(() {
                                        currentLocale = const Locale('ja');
                                      });
                                      
                                      Navigator.of(context).pushAndRemoveUntil(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(userLocale: Locale('ja')),
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
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MenuButton(
                          text: AppLocalizations.of(context)!.inbound,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const KakunoPLScreen(),
                              ),
                            );
                            
                          },
                        ),
                        const SizedBox(height: 20),
                        MenuButton(
                          text: AppLocalizations.of(context)!.outbound,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ShipmentQrScanPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }  
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MenuButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        fixedSize: const Size(370, 120),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}