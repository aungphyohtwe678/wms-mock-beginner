import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/asn-scan-result.dart';
import 'package:otk_wms_mock/menu.dart';
import 'package:otk_wms_mock/tranceport-2.dart';

class ASNScanScreen extends StatefulWidget {
  final int currentStep;

  const ASNScanScreen({super.key, this.currentStep = 1});

  @override
  State<ASNScanScreen> createState() => _ASNScanScreen();
}

class _ASNScanScreen extends State<ASNScanScreen> {
  final TextEditingController _scanController = TextEditingController();
  final TextEditingController _scanSecondController = TextEditingController();
  final FocusNode _scanFocusNode1 = FocusNode();
  final FocusNode _scanFocusNode2 = FocusNode();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _showError = false;
  bool _isButtonEnabled = false;
  bool _isFirstFieldLocked = false;
  bool _skipValidation = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _playSound('sounds/asn-scan.ogg');
      FocusScope.of(context).requestFocus(_scanFocusNode1);
    });

    _scanFocusNode1.addListener(() {
      if (_skipValidation) {
        _skipValidation = false;
        return;
      }
      if (!_scanFocusNode1.hasFocus && !_isFirstFieldLocked) {
        _validateFirstField();
      }
    });

    _scanFocusNode2.addListener(() {
      if (!_scanFocusNode2.hasFocus) {
        _validateSecondField();
      }
    });

    _scanController.addListener(_updateButtonState);
    _scanSecondController.addListener(_updateButtonState);
  }

  Future<void> _playSound(String path) async {
    await _audioPlayer.play(AssetSource(path));
  }

  void _validateFirstField() async {
    final text = _scanController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = 'ラベルを入力してください';
      });
      _playSound('sounds/ng-null.ogg');
    } else if (!RegExp(r'^[a-zA-Z0-9]{10,}$').hasMatch(text)) {
      setState(() {
        _showError = true;
        _errorMessage = 'ラベルが不正です';
      });
      _playSound('sounds/ng-label.ogg');
    } else {
      setState(() {
        _showError = false;
        _isFirstFieldLocked = true;
      });
      await _playSound('sounds/pi.ogg');
      FocusScope.of(context).requestFocus(_scanFocusNode2);
    }
  }

  void _validateSecondField() async {
    final text = _scanSecondController.text.trim();
    if (text.isNotEmpty && !RegExp(r'^[a-zA-Z0-9]{10,}$').hasMatch(text)) {
      setState(() {
        _showError = true;
        _errorMessage = 'ラベルが不正です';
      });
      _playSound('sounds/ng-label.ogg');
    } else {
      setState(() {
        _showError = false;
      });
      _goToNextScreen();
    }
  }

  void _updateButtonState() {
    final hasInput1 = _scanController.text.trim().isNotEmpty;
    final hasInput2 = _scanSecondController.text.trim().isNotEmpty;
    setState(() {
      _isButtonEnabled = hasInput1 || hasInput2;
    });
  }

  void _goToNextScreen() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ASNScanResultScreen(currentStep: widget.currentStep),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );

    if (result == 'clear') {
      if (widget.currentStep >= 1) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MenuScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
          (route) => false,
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ASNScanResultScreen(currentStep: widget.currentStep + 1),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scanController.dispose();
    _scanSecondController.dispose();
    _scanFocusNode1.dispose();
    _scanFocusNode2.dispose();
    super.dispose();
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
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.5),
                title: const Text(
                  'ASN照会（作業検索）',
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
              body: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.currentStep == 1
                            ? OutlinedButton(
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
                            : const SizedBox.shrink(),
                        // Text(
                        //   '${widget.currentStep}/5',
                        //   style: const TextStyle(
                        //     fontSize: 24,
                        //     color: Colors.black,
                        //     fontFamily: 'Helvetica Neue',
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_showError)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Helvetica Neue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _scanController,
            focusNode: _scanFocusNode1,
            enabled: !_isFirstFieldLocked,
            decoration: const InputDecoration(
              hintText: 'ASNラベルをスキャン',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 24),
          SizedBox(
            width: 344,
            height: 50,
            child: ElevatedButton(
              onPressed: _isButtonEnabled ? _goToNextScreen : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '検索',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Helvetica Neue',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
