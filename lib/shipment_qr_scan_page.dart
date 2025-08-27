import 'package:flutter/material.dart';
import 'package:otk_wms_mock/pickking-cs2.dart';
import 'l10n/app_localizations.dart';
import 'login.dart';
import 'utils/sound_manager.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SoundManager.playSound('scan_shipping_equipment.ogg', context);
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
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Container(
                decoration: const BoxDecoration(
                  color: Colors.red, // background color
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.warning_amber_rounded, // warning/error icon
                  color: Colors.white,
                ),
              ),                          
              onPressed: () {
                // Action when pressed
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [            
            Container(
              width: double.infinity,
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
                    autofocus: false,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      print('onSubmitted called with: "$value"'); // Debug log
                      _onQrCodeEntered();
                    },
                    onChanged: (value) {
                      print('Text changed: "$value"'); // Debug log
                    },
                    decoration: InputDecoration(
                      hintText: localizations.qr_code,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
