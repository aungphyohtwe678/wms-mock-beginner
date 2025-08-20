import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/hanso-asn.dart';
import 'package:otk_wms_mock/kinkyu-moto-asn.dart';
import 'package:otk_wms_mock/menu1.dart';

import 'l10n/app_localizations.dart';
import 'l10n/localization_utils.dart';

class ASNScanScreen extends StatefulWidget {
  final int currentStep;

  const ASNScanScreen({super.key, this.currentStep = 1});

  @override
  State<ASNScanScreen> createState() => _ASNScanScreen();
}

class _ASNScanScreen extends State<ASNScanScreen> {
  final TextEditingController _scanController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _scanFocusNode1 = FocusNode();

  bool _showError = false;
  bool _isFirstFieldLocked = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _status = '';
  String _destination = '';
  String _productName = '';
  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false];

  @override
  void dispose() {
    _scanController.dispose();
    _scanFocusNode1.dispose();
    super.dispose();
  }

  Future<void> _playSound(String path) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
  }

  void _validateFirstField() async {
    final text = _scanController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = AppLocalizations.of(context)!.enter_label;
      });
      await _playSound('sounds/ng-null.ogg');
      return;
    }

    if (text == '1') {
      // 搬送
      setState(() {
        _status = '搬送待ち';
        _destination = 'ABC-001';
        _productName = '大塚生食100ml';
      });
    } else if (text == '2') {
      // 出荷 → 「在庫」まで完了済みの搬送系列に見せる
      setState(() {
        _status = '在庫'; // ← ここを「在庫」に変更！
        _destination = 'XYZ-456';
        _productName = 'KN1号輸液200ml';
      });
    } else if (text == '3') {
      // 移動
      setState(() {
        _status = '移動中';
        _destination = 'MNP-789';
        _productName = 'ビーフリード1000ml';
      });
    } else {
      // その他
      setState(() {
        _showError = true;
        _errorMessage = '不正なラベルです';
      });
      await _playSound('sounds/ng-label.ogg');
      return;
    }

    await _playSound('sounds/pi.ogg');
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _showError = false;
      _isFirstFieldLocked = true;
      _stepCompleted[0] = true;
      _expandedStep = 1;
    });
  }

  Widget _buildStep({
    required int stepIndex,
    required String title,
    required List<Widget> children,
  }) {
    if (!_stepCompleted.sublist(0, stepIndex).every((e) => e)) return const SizedBox.shrink();
    final isExpanded = !_stepCompleted[stepIndex] && _expandedStep == stepIndex;

    return ExpansionTile(
      key: ValueKey('step_$stepIndex-$_expandedStep'),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.play(AssetSource('sounds/asn-scan.ogg'));
      FocusScope.of(context).requestFocus(_scanFocusNode1);
    });
  }

Widget _buildStepBarVertical(String status) {
  List<String> steps = [];
  int currentIndex = 0;

  if (['搬送待ち', '格納待ち', '在庫'].contains(status)) {
    steps = ['検品済み', '搬送待ち', '格納待ち', '在庫'];
  } else if (['出荷指示待ち', 'ピッキング待ち', '搬送待ち', '出荷完了'].contains(status)) {
    steps = ['出荷指示待ち', 'ピッキング待ち', '搬送待ち', '出荷完了'];
  } else if (['移動指示', '移動中', '移動完了'].contains(status)) {
    steps = ['移動指示', '移動中', '移動完了'];
  } else {
    return const SizedBox(); // ← 不正なstatusなら空を返す
  }

  currentIndex = steps.indexOf(status);

  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 丸と線の列
        Column(
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isEven) {
              int stepIndex = i ~/ 2;
              bool isCurrent = stepIndex == currentIndex;
              bool isCompleted = stepIndex < currentIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Icon(
                  isCompleted
                      ? Icons.check_circle
                      : isCurrent
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                  color: isCompleted || isCurrent ? Colors.blue : Colors.grey,
                  size: isCurrent ? 28 : 20,
                ),
              );
            } else {
              return Container(
                width: 2,
                height: 38,
                color: (i ~/ 2) < currentIndex ? Colors.blue : Colors.grey[300],
              );
            }
          }),
        ),
        const SizedBox(width: 12),
        // テキストの列
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isEven) {
              int stepIndex = i ~/ 2;
              bool isCurrent = stepIndex == currentIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  LocalizationUtils.translateStep(context,steps[stepIndex]),
                  style: TextStyle(
                    fontSize: isCurrent ? 24 : 14,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? Colors.blue : Colors.black,
                  ),
                ),
              );
            } else {
              return const SizedBox(height: 25); // 丸と同じ高さの隙間
            }
          }),
        ),
      ],
    ),
  );
}


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Stack(
            children: [
              Container(
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
                        title: Text(
                          AppLocalizations.of(context)!.work_status_search,
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
                                      AppLocalizations.of(context)!.general_worker('山田 太郎'),
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
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) => const MenuScreen(
                                                  initialSelectedIndex: 3,
                                                ),
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
                                        child: Text(
                                          AppLocalizations.of(context)!.back,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Helvetica Neue',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                _buildStep(
                                  stepIndex: 0,
                                  title: AppLocalizations.of(context)!.asn_label_scan,
                                  children: [
                                    if (_showError)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                                      ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: TextField(
                                        controller: _scanController,
                                        focusNode: _scanFocusNode1,
                                        enabled: !_isFirstFieldLocked,
                                        onSubmitted: (_) => _validateFirstField(),
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(context)!.scan_asn_label,
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: 0.8,
                                      child: Container(
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
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                                _buildStep(
                                  stepIndex: 1,
                                  title: AppLocalizations.of(context)!.check_work_status,
                                  children: _isLoading
                                      ? [
                                          const SizedBox(height: 44),
                                          const CircularProgressIndicator(),
                                          const SizedBox(height: 44),
                                        ]
                                      : [
                                          const SizedBox(height: 8),
                                          const SizedBox(height: 5),
                                          FractionallySizedBox(
                                            widthFactor: 0.7,
                                            child: _buildStepBarVertical(_status),
                                          ),
                                          const SizedBox(height: 30),
                                          Text(
                                            AppLocalizations.of(context)!.outer_code,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Helvetica Neue',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            _destination,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'Helvetica Neue',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!.quantity,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Helvetica Neue',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                '6${AppLocalizations.of(context)!.cases}',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: 'Helvetica Neue',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            AppLocalizations.of(context)!.item_name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Helvetica Neue',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            _productName,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'Helvetica Neue',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 12),

                                          if (_status == '在庫') ...[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.storage_location,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Helvetica Neue',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  '03-003-01',
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    fontFamily: 'Helvetica Neue',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                              ],
                                            ),
                                          ] else if (_status == '移動中') ...[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 24, bottom: 20),
                                              child: SizedBox(
                                                width: 344,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (_, __, ___) => const KinkyuMotoASNScreen(currentStep: 100),
                                                        transitionDuration: Duration.zero,
                                                        reverseTransitionDuration: Duration.zero,
                                                      ),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.black,
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(context)!.perform_transit,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Helvetica Neue',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ] else if (_status == '搬送待ち') ...[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 24, bottom: 20),
                                              child: SizedBox(
                                                width: 344,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (_, __, ___) => const LiftScanScreen2(),
                                                        transitionDuration: Duration.zero,
                                                        reverseTransitionDuration: Duration.zero,
                                                      ),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.black,
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(context)!.perform_transport,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Helvetica Neue',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                ),
                              ]
                            )
                          )
                        ]
                      )
                    )
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}