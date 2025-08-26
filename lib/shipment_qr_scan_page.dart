import 'package:flutter/material.dart';
import 'package:otk_wms_mock/pickking-cs2.dart';
import 'l10n/app_localizations.dart';
import 'login.dart';

class ShipmentQrScanPage extends StatefulWidget {
  const ShipmentQrScanPage({super.key});

  @override
  State<ShipmentQrScanPage> createState() => _ShipmentQrScanPageState();
}

class _ShipmentQrScanPageState extends State<ShipmentQrScanPage> {
  final TextEditingController _qrController = TextEditingController();
  final FocusNode _qrFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the text field when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _qrFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _qrController.dispose();
    _qrFocusNode.dispose();
    super.dispose();
  }

  void _onQrCodeEntered() {
    final qrCode = _qrController.text.trim();
    print('QR Code entered: "$qrCode"'); // Debug log
    
    if (qrCode.isNotEmpty || qrCode == '') {
      // Navigate to PickkingCS2Screen page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PickkingCS2Screen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
        title: Text(
          localizations.outbound_equipment_qr_scan,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Helvetica Neue',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                      localizations.notifications,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Helvetica Neue',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '2025/6/XX 16:00 XXXXXXX',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Text(
                      '2025/6/XX 15:00 YYYYYYY',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Text(
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
                      localizations.general_worker('山田太郎'),
                      style: const TextStyle(
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
                        child: Text(localizations.logout),
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
                        child: Text(localizations.accident_report),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Back button row at the top
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                    child: Text(
                      localizations.back,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Helvetica Neue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content centered in the middle
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.forklift, size: 80), // フォークリフト代替アイコン
                  const SizedBox(height: 20),
                  TextField(
                    controller: _qrController,
                    focusNode: _qrFocusNode,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      print('onSubmitted called with: "$value"'); // Debug log
                      _onQrCodeEntered();
                    },
                    onChanged: (value) {
                      print('Text changed: "$value"'); // Debug log
                    },
                    decoration: InputDecoration(
                      labelText: localizations.qr_code,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.qr_code),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    localizations.scan_outbound_equipment_qr,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.auto_navigate_after_scan,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
