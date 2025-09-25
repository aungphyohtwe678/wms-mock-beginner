import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/shipment_qr_scan_page.dart';
import 'package:otk_wms_mock/top-menu.dart';

import 'l10n/app_localizations.dart';

/// Picking workflow screen that handles CS2 (Case/Pallet) picking process
/// Supports a two-round picking workflow with audio feedback and tap-to-advance functionality
class PickkingCS2Screen extends StatefulWidget {
  final int currentStep;

  const PickkingCS2Screen({super.key, this.currentStep = 1});

  @override
  State<PickkingCS2Screen> createState() => _PickkingCS2ScreenState();
}

class _PickkingCS2ScreenState extends State<PickkingCS2Screen> {
  // === Audio Player ===
  final AudioPlayer _audioPlayer = AudioPlayer();

  // === Workflow State ===
  int _expandedStep = 0;
  List<bool> _stepCompleted = [false, false, false, false, false];
  bool _showModal = false;
  int _completedCount = 1;
  bool _isSecondRound = false;
  int _tapCount = 0;
  bool _isProcessingTap = false; // Prevent multiple taps

  // === UI Controllers ===
  final FocusNode _step1Focus = FocusNode();
  final FocusNode _step3Focus = FocusNode();
  final FocusNode _step4Focus = FocusNode();
  final TextEditingController _step1Controller = TextEditingController();
  final TextEditingController _step3Controller = TextEditingController();
  final TextEditingController _step4Controller = TextEditingController();
  final TextEditingController _shohinController2 = TextEditingController();

  // === Configuration ===
  int _requiredScanCount = 8;

  // === Constants ===
  static const Map<int, String> _soundMap = {
    1: 'pic-start5.ogg',
    2: '8c.ogg',
    3: '4c.ogg',
    4: 'tumituke.ogg',
    5: 'syohin-scan.ogg',
    6: 'pic-asn.ogg',
    7: 'label-harituke.ogg',
    8: 'pic-kanryo.ogg',
    9: 'pic-start6.ogg'
  };

  static const Duration _shortDelay = Duration(milliseconds: 50);
  static const Duration _mediumDelay = Duration(milliseconds: 300);
  static const Duration _longDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _initializeWorkflow();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _step1Focus.dispose();
    _step3Focus.dispose();
    _step4Focus.dispose();
    _step1Controller.dispose();
    _step3Controller.dispose();
    _step4Controller.dispose();
    _shohinController2.dispose();
    super.dispose();
  }

  // === Audio Helper Methods ===
  Future<void> _playSound(String soundFileName) async {
    // Get current locale before async operations
    final locale = Localizations.localeOf(context).languageCode;
    
    try {
      await _audioPlayer.stop();
      
      // Determine sound path based on locale
      String soundPath;
      if (locale == 'en') {
        // Play English version if available
        soundPath = 'sounds/en/$soundFileName';
      } else {
        // Default to Japanese sounds
        soundPath = 'sounds/$soundFileName';
      }
      
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      print('Error playing sound $soundFileName: $e');
      // Fallback to default Japanese sound if English version fails
      if (e.toString().contains('FileSystemException') || e.toString().contains('not found')) {
        try {
          await _audioPlayer.play(AssetSource('sounds/$soundFileName'));
        } catch (fallbackError) {
          print('Fallback sound also failed for $soundFileName: $fallbackError');
        }
      }
    }
  }

  Future<void> _stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }



  // === Initialization & Cleanup ===

  void _initializeWorkflow() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Play initial sound
      await _playSound('kara-pl.ogg');
      // Wait for sound to finish before allowing interaction
      await Future.delayed(const Duration(milliseconds: 3000));
    });
  }



  // === Focus Management ===

  void _requestFocusForExpandedStep() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      switch (_expandedStep) {
        case 1:
          await _setFocusWithDelay(_step1Focus);
          break;
        case 3:
          await _setFocusWithDelay(_step3Focus);
          break;
        case 4:
          await _setFocusWithDelay(_step4Focus);
          break;
      }
    });
  }

  Future<void> _setFocusWithDelay(FocusNode focusNode) async {
    FocusScope.of(context).unfocus();
    await Future.delayed(_shortDelay);
    FocusScope.of(context).requestFocus(focusNode);
  }

  void _unfocusStep(FocusNode focusNode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        focusNode.unfocus();
      }
    });
  }

  // === Step Progress Management ===

  void _advanceToNextStep() {
    setState(() {
      _tapCount++;
      
      if (_tapCount == 1 && _expandedStep == 0) {
        _expandedStep = 1;
      } else if (_tapCount == 2 && _expandedStep == 1) {
        _expandedStep = 2;
      } else if (_tapCount == 3 && _expandedStep == 2) {
        _expandedStep = 3;
      }
    });
  }

  Future<void> _startCountdownAndCompleteStep(int stepIndex, int nextStepIndex, int soundStepIndex) async {
    for (int i = 3; i >= 1; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
    }
    if (_soundMap.containsKey(soundStepIndex)) {
      await _stopSound();
      await Future.delayed(const Duration(milliseconds: 500)); // Safari compatibility
      await _playSound(_soundMap[soundStepIndex]!);
      // Wait for sound to finish before proceeding
      await Future.delayed(const Duration(milliseconds: 2500));
    }
    setState(() {
      _stepCompleted[stepIndex] = true;
      _expandedStep = nextStepIndex;
    });
    _requestFocusForExpandedStep();
  }

  // === Step Handlers ===

  Future<void> _handleStep1() async {
    // Set location code based on round
    _step1Controller.text = _isSecondRound ? "05‐016‐01‐00​" : "05‐014‐01‐00​";

    await Future.delayed(_longDelay);

    // Play appropriate sound for round with Safari-specific handling
    try {
      if (_isSecondRound) {
        await _playSound('4c.ogg');
        // Wait for sound to finish
        await Future.delayed(const Duration(milliseconds: 2000));
      } else {
        await _playSound('8c.ogg');
        // Wait for sound to finish
        await Future.delayed(const Duration(milliseconds: 2000));
      }
    } catch (e) {
      print('Error in _handleStep1 audio: $e');
      // Fallback to regular sound method
      if (_isSecondRound) {
        await _playSound('4c.ogg');
        await Future.delayed(const Duration(milliseconds: 2000));
      } else {
        await _playSound('8c.ogg');
        await Future.delayed(const Duration(milliseconds: 2000));
      }
    }

    setState(() {
      _stepCompleted[1] = true;
      _expandedStep = 2;
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    await _playSound('tumituke.ogg');
    // Wait for tumituke sound to finish
    await Future.delayed(const Duration(milliseconds: 2000));
    await _playSound('syohin-scan.ogg');
    // Wait for syohin-scan sound to finish
    await Future.delayed(const Duration(milliseconds: 2500));

    _unfocusStep(_step1Focus);
  }

  Future<void> _handleStep3() async {
    // Clear barcode field and set lot number
    _step3Controller.text = "";

    await Future.delayed(_mediumDelay);
    
    if (_completedCount == 1) {
      _shohinController2.text = 'MMY2025M5D00XX';
    } else if (_completedCount == 2) {
      _shohinController2.text = 'ZZY2025M5D01YY';
    }

    // Process barcode validation
    if (_step3Controller.text.trim().toLowerCase() == 'gs1-128') {
      await _processValidBarcode();
    } else {
      await _processInvalidBarcode();
    }

    _unfocusStep(_step3Focus);
  }

  Future<void> _processValidBarcode() async {
    await _playSound('label-harituke.ogg');
    await Future.delayed(const Duration(milliseconds: 3500));
    setState(() {
      _stepCompleted[2] = true;
      _stepCompleted[3] = true;
      _expandedStep = 4;
    });
    await _playSound('pic-asn.ogg');
    // Wait for pic-asn sound to finish
    await Future.delayed(const Duration(milliseconds: 2000));
  }

  Future<void> _processInvalidBarcode() async {
    await _playSound('label-harituke.ogg');
    await Future.delayed(const Duration(milliseconds: 3500));
    setState(() {
      _stepCompleted[2] = true;
      _expandedStep = 3;
    });
    await _stopSound();
    await Future.delayed(const Duration(milliseconds: 200)); // Safari compatibility
    await _playSound(_soundMap[6]!);
    // Wait for pic-asn sound to finish
    await Future.delayed(const Duration(milliseconds: 2000));
    FocusScope.of(context).requestFocus(_step4Focus);
  }

  Future<void> _handleStep4() async {
    _step4Controller.text = "ASN-LABEL-SCANNED";
    await Future.delayed(_longDelay);
    
    // Workflow completion logic (formerly _onImageTapped)
    await _playSound('pl-himoduke.ogg');
    // Wait for pl-himoduke sound to finish
    await Future.delayed(const Duration(milliseconds: 2500));
    setState(() {
      _showModal = true;
    });

    if (_completedCount == 1) {
      await _completeFirstRound();
    } else {
      await _completeWorkflow();
    }
    
    _unfocusStep(_step4Focus);
  }

  // === Main Tap Handler ===

  Future<void> _handleScreenTap() async {
    // Prevent multiple taps - return early if already processing
    if (_isProcessingTap) {
      return;
    }

    // Set processing flag to prevent additional taps
    _isProcessingTap = true;

    try {
      _advanceToNextStep();

      switch (_tapCount) {
        case 1:
          if (_expandedStep == 1) await _handleStep1();
          break;
        case 2:
          if (_expandedStep == 2) await _handleStep3();
          break;
        case 3:
          if (_expandedStep == 3) await _handleStep4();
          break;
        default:
          _requestFocusForExpandedStep();
      }
    } finally {
      // Always reset the processing flag, even if an error occurs
      _isProcessingTap = false;
    }
  }

  // === Workflow Completion ===

  Future<void> _completeFirstRound() async {
    await _playSound('8c.ogg');
    // Wait for 8c sound to finish
    await Future.delayed(const Duration(milliseconds: 100));
    await _playSound('pic-kanryo.ogg');
    // Wait for pic-kanryo sound to finish
    await Future.delayed(const Duration(milliseconds: 3000));
    
    _resetForSecondRound();
    
    await _stopSound();
    await Future.delayed(const Duration(milliseconds: 100)); // Safari compatibility
    await _playSound(_soundMap[9]!);
    // Wait for pic-start6 sound to finish
    await Future.delayed(const Duration(milliseconds: 2500));
    await Future.delayed(_shortDelay);
    FocusScope.of(context).requestFocus(_step1Focus);
  }

  void _resetForSecondRound() {
    setState(() {
      _stepCompleted[3] = true;
      _completedCount = 2;
      _isSecondRound = true;
      _stepCompleted = [true, false, false, false];
      _expandedStep = 1;
      _showModal = false;
      _requiredScanCount = 4;
      _tapCount = 0;
      _isProcessingTap = false; // Reset tap processing flag for second round
    });

    // Clear all controllers
    _step1Controller.clear();
    _step3Controller.clear();
    _step4Controller.clear();
    _shohinController2.clear();
  }

  Future<void> _completeWorkflow() async {
    await _playSound('4c.ogg');
    // Wait for 4c sound to finish
    await Future.delayed(const Duration(milliseconds: 100));
    await _playSound('pic-kanryo.ogg');
    // Wait for pic-kanryo sound to finish completely before navigation
    await Future.delayed(const Duration(milliseconds: 3000));
    
    if (mounted) {
      setState(() {
        _showModal = false;
      });
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const TopMenuScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  // === UI Building Methods ===

  Widget _buildStep({
    required int stepIndex,
    required String title,
    required List<Widget> children,
  }) {
    if (!_stepCompleted.sublist(0, stepIndex).every((e) => e)) {
      return const SizedBox.shrink();
    }

    final bool isExpanded = !_stepCompleted[stepIndex] && _expandedStep == stepIndex;

    return ExpansionTile(
      key: ValueKey('step_$stepIndex-$_expandedStep'),
      initiallyExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        if (!_stepCompleted[stepIndex]) {
          setState(() {
            _expandedStep = expanded ? stepIndex : -1;
          });

          if (expanded) {
            _requestFocusForExpandedStep();
          }
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.black,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      title: Text(
        AppLocalizations.of(context)!.picking_pl_cs,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TopMenuScreen()),
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              // TODO: Implement warning action
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: !_isSecondRound && !_stepCompleted[1],
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const ShipmentQrScanPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
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
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Helvetica Neue',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickCountHeader() {
    return Text(
      '${AppLocalizations.of(context)!.pick_count}：$_completedCount/2',
      style: const TextStyle(
        fontSize: 25,
        fontFamily: 'Helvetica Neue',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildModal() {
    if (!_showModal) return const SizedBox.shrink();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.zero,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.picking_complete,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Helvetica Neue',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTapArea() {
    final bool isWorkflowCompleted = (_completedCount == 2 && _stepCompleted[3]) || 
                                   (_stepCompleted[3] && !_isSecondRound);
    
    return Positioned(
      bottom: 0,
      right: 0,
      width: 120,
      height: 100,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleScreenTap,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Text(
              isWorkflowCompleted ? 'Workflow completed' : '',
              style: TextStyle(
                color: isWorkflowCompleted ? Colors.grey[600] : Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // === Step Content Builders ===

  List<Widget> _buildStep0Content() {
    return [
      const SizedBox(height: 8),
      Text(
        AppLocalizations.of(context)!.empty_pallets_n_count(1),
        style: const TextStyle(
          fontSize: 25,
          fontFamily: 'Helvetica Neue',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 10),
      FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            'assets/images/karapare.jpg',
            fit: BoxFit.cover,
          ),
        ),
      )
    ];
  }

  List<Widget> _buildStep1Content() {
    
    
    return [
      const SizedBox(height: 8),
      Text(
        _isSecondRound ? '04-004-13' : '04-004-12',
        style: const TextStyle(
          fontSize: 48,
          fontFamily: 'Helvetica Neue',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 6),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: TextField(
          controller: _step1Controller,
          focusNode: _step1Focus,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.scan_location,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),      
      const SizedBox(height: 16),
      FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            'assets/images/kakuno.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 10)
    ];
  }

  List<Widget> _buildStep2Content() {
    return [
      Text(
        _isSecondRound ? '0813​' : '1854',
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Helvetica Neue',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      Text(
        _isSecondRound ? '（局）大塚糖液　5％​' : 'ビーフリード輸液',
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Helvetica Neue',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      Text(
        _isSecondRound ? 'K5G73​' : 'M5E91N',
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Helvetica Neue',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      Text(
        '$_requiredScanCount ${AppLocalizations.of(context)!.cases}',
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Helvetica Neue',
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            height: 250,
            child: Image.asset(
              _isSecondRound
                  ? 'assets/images/tumituke2.png'
                  : 'assets/images/tumituke.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      const SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: TextField(
          controller: _step3Controller,
          focusNode: _step3Focus,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.scan_barcode,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 3),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: TextField(
          controller: _shohinController2,
          readOnly: true,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.lot,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 8),
      FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const SizedBox(
            height: 250,
            child: Image(
              image: AssetImage('assets/images/syohin.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
    ];
  }

  List<Widget> _buildStep3Content() {
    return [
      FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            'assets/images/karapare.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: TextField(
          controller: _step4Controller,
          focusNode: _step4Focus,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.scan_asn_label,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: 344,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            // Workflow completion logic (formerly _onImageTapped)
            await _playSound('pl-himoduke.ogg');
            // Wait for pl-himoduke sound to finish
            await Future.delayed(const Duration(milliseconds: 2500));
            setState(() {
              _showModal = true;
            });

            if (_completedCount == 1) {
              await _completeFirstRound();
            } else {
              await _completeWorkflow();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.issue_asn_label,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Helvetica Neue',
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
    ];
  }


  @override
  Widget build(BuildContext context) {
    // Initialize first step if needed
    if (_expandedStep == 0 && !_stepCompleted[0] && !_isSecondRound) {
      _startCountdownAndCompleteStep(0, 1, 1);
    }

    // Handle second round initialization
    if (_completedCount == 2 && !_stepCompleted[1] && _expandedStep == 0) {
      setState(() {
        _expandedStep = 1;
      });
      _requestFocusForExpandedStep();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.zero,
              ),
              clipBehavior: Clip.antiAlias,
              child: SafeArea(
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: _buildAppBar(),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildBackButton(),
                          const SizedBox(height: 10),
                          _buildPickCountHeader(),
                          _buildStep(
                            stepIndex: 0,
                            title: AppLocalizations.of(context)!.prepare_empty_pallets,
                            children: _buildStep0Content(),
                          ),
                          _buildStep(
                            stepIndex: 1,
                            title: AppLocalizations.of(context)!.pick_location_check_scan,
                            children: _buildStep1Content(),
                          ),
                          _buildStep(
                            stepIndex: 2,
                            title: AppLocalizations.of(context)!.product_scan_qty_stacking,
                            children: _buildStep2Content(),
                          ),
                          _buildStep(
                            stepIndex: 3,
                            title: AppLocalizations.of(context)!.asn_label_scan,
                            children: _buildStep3Content(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildModal(),
            _buildTapArea(),
          ],
        ),
      ),
    );
  }
}