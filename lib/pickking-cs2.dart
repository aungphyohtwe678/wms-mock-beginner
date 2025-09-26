import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/safe_audio_manager.dart';
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

  bool _unlocked = false;

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

  /// Get localized sound path based on current locale
  /// 
  /// This method automatically determines the appropriate sound directory:
  /// - English locale ('en'): Uses 'sounds/en/' directory
  /// - Japanese locale (default): Uses 'sounds/' directory
  /// 
  /// To add English audio support:
  /// 1. Create assets/sounds/en/ directory
  /// 2. Add English versions of all sound files in this directory
  /// 3. Ensure pubspec.yaml includes the assets/sounds/en/ path
  String _getLocalizedSoundPath(String soundFile) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'en') {
      return 'sounds/en/$soundFile';
    } else {
      // Default to Japanese (sounds/ directory)
      return 'sounds/$soundFile';
    }
  }





  // === Constants ===
  Future<void> _playStepSound(int stepIndex) async {
    // CRITICAL: Completely disable step 1 audio to prevent iOS Safari NotAllowedError
    if (stepIndex == 1) {
      print('STEP 1 AUDIO COMPLETELY DISABLED: Skipping pic-start5.ogg to avoid NotAllowedError in iOS Safari');
      return; // Exit immediately - no audio attempt for step 1
    }
    
    final soundMap = {
      // Step 1 audio completely removed to prevent iOS Safari NotAllowedError
      // 1: _getLocalizedSoundPath('pic-start5.ogg'), // DISABLED for iOS Safari compatibility
      2: _getLocalizedSoundPath('8c.ogg'),
      3: _getLocalizedSoundPath('4c.ogg'),
      4: _getLocalizedSoundPath('tumituke.ogg'),
      5: _getLocalizedSoundPath('syohin-scan.ogg'),
      6: _getLocalizedSoundPath('pic-asn.ogg'),
      7: _getLocalizedSoundPath('label-harituke.ogg'),
      8: _getLocalizedSoundPath('pic-kanryo.ogg'),
      9: _getLocalizedSoundPath('pic-start6.ogg')
    };
    
    if (soundMap.containsKey(stepIndex)) {
      print('Attempting to play sound for step $stepIndex: ${soundMap[stepIndex]}');
      
      // Use only simple direct play for ALL steps to avoid NotAllowedError
      try {
        // Simple direct play - most conservative approach
        await _audioPlayer.play(AssetSource(soundMap[stepIndex]!));
        print('Successfully played sound for step $stepIndex: ${soundMap[stepIndex]}');
      } catch (e) {
        print('Audio play failed for step $stepIndex: $e');
        // Silently fail - don't attempt any fallbacks that might cause NotAllowedError
        print('Skipping audio to avoid NotAllowedError - workflow continues');
      }
    } else {
      print('No sound mapped for step $stepIndex');
    }
  }

  static const Duration _shortDelay = Duration(milliseconds: 50);
  static const Duration _mediumDelay = Duration(milliseconds: 300);

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

  // === Initialization & Cleanup ===
  void _initializeWorkflow() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SafeAudioManager.instance.isRegistered(_getLocalizedSoundPath('kara-pl.ogg'))) {
        await SafeAudioManager.instance.play(_getLocalizedSoundPath('kara-pl.ogg'));
      } else {
        print('Sound not registered, skipping playback to avoid NotAllowedError kara-pl.ogg');
      }       
    });
  }

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
 
      print('Starting countdown for step $stepIndex -> $nextStepIndex, sound: $soundStepIndex');
      
      for (int i = 3; i >= 1; i--) {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        print('Countdown: $i');
      }

      print('Countdown complete, playing sound for step $soundStepIndex');

      if (SafeAudioManager.instance.isRegistered(_getLocalizedSoundPath('pic-start5.ogg'))) {
        await SafeAudioManager.instance.play(_getLocalizedSoundPath('pic-start5.ogg'));
      } else {
        print('Sound not registered, skipping playback to avoid NotAllowedError');
      }
      // await SafeAudioPlayer.instance.play();
      

      print("Completing step $stepIndex, expanding to $nextStepIndex");

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

    await Future.delayed(const Duration(milliseconds: 500));

    // Play appropriate sound for round with Safari-specific handling
    try {
      if (_isSecondRound) {
        await _playStepSound(3);
      } else {
        await _playStepSound(2);
      }
    } catch (e) {
      print('Error in _handleStep1 audio: $e');
      // Fallback to regular sound method
      if (_isSecondRound) {
        await _playStepSound(3);
      } else {
        await _playStepSound(2);
      }
    }

    setState(() {
      _stepCompleted[1] = true;
      _expandedStep = 2;
    });

    await Future.delayed(const Duration(milliseconds: 1500));
    if (SafeAudioManager.instance.isRegistered(_getLocalizedSoundPath('tumituke.ogg'))) {
      await SafeAudioManager.instance.play(_getLocalizedSoundPath('tumituke.ogg'));
    } else {
      print('Sound not registered, skipping playback to avoid NotAllowedError tumituke.ogg');
    }
    await Future.delayed(const Duration(milliseconds: 2500));
    if (SafeAudioManager.instance.isRegistered(_getLocalizedSoundPath('syohin-scan.ogg'))) {
        await SafeAudioManager.instance.play(_getLocalizedSoundPath('syohin-scan.ogg'));
      } else {
        print('Sound not registered, skipping playback to avoid NotAllowedError syohin-scan.ogg');
      }

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
    if (SafeAudioManager.instance.isRegistered(_getLocalizedSoundPath('label-harituke.ogg'))) {
      await SafeAudioManager.instance.play(_getLocalizedSoundPath('label-harituke.ogg'));
    } else {
      print('Sound not registered, skipping playback to avoid NotAllowedError label-harituke.ogg');
    }
    await Future.delayed(const Duration(milliseconds: 3500));
    setState(() {
      _stepCompleted[2] = true;
      _stepCompleted[3] = true;
      _expandedStep = 4;
    });
    await _playStepSound(6);
  }

  Future<void> _processInvalidBarcode() async {
    
    if (SafeAudioManager.instance.isRegistered(_getLocalizedSoundPath('label-harituke.ogg'))) {
      await SafeAudioManager.instance.play(_getLocalizedSoundPath('label-harituke.ogg'));
    } else {
      print('Sound not registered, skipping playback to avoid NotAllowedError label-harituke.ogg');
    }
    await Future.delayed(const Duration(milliseconds: 3500));
    setState(() {
      _stepCompleted[2] = true;
      _expandedStep = 3;
    });
    await _playStepSound(6);
    FocusScope.of(context).requestFocus(_step4Focus);
  }

  Future<void> _handleStep4() async {
    _step4Controller.text = "ASN-LABEL-SCANNED";
    if (SafeAudioManager.instance.isRegistered(_getLocalizedSoundPath('pl-himoduke.ogg'))) {
      await SafeAudioManager.instance.play(_getLocalizedSoundPath('pl-himoduke.ogg'));
    } else {
      print('Sound not registered, skipping playback to avoid NotAllowedError pl-himoduke.ogg');
    }
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
      // Remove ALL audio attempts from tap handler to avoid NotAllowedError
      // iOS Safari is too restrictive even for user-triggered tap events
      print('User tap detected - skipping all audio to avoid NotAllowedError');

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
    await _audioPlayer.play(AssetSource(_getLocalizedSoundPath('8c.ogg')));
    await Future.delayed(const Duration(milliseconds: 2000));
    if (SafeAudioManager.instance.isRegistered(_getLocalizedSoundPath('pic-kanryo.ogg'))) {
      await SafeAudioManager.instance.play(_getLocalizedSoundPath('pic-kanryo.ogg'));
    } else {
      print('Sound not registered, skipping playback to avoid NotAllowedError pic-kanryo.ogg');
    }// 'pic-kanryo.ogg' に対応させる
    await Future.delayed(const Duration(milliseconds: 2500));
    
    _resetForSecondRound();
    
    if (SafeAudioManager.instance.isRegistered(_getLocalizedSoundPath('pic-start6.ogg'))) {
      await SafeAudioManager.instance.play(_getLocalizedSoundPath('pic-start6.ogg'));
    } else {
      print('Sound not registered, skipping playback to avoid NotAllowedError pic-start6.ogg');
    }// 'pic-start6.ogg' に対応させる
    await Future.delayed(const Duration(milliseconds: 50));
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
    await _audioPlayer.play(AssetSource(_getLocalizedSoundPath('4c.ogg')));
    await Future.delayed(const Duration(milliseconds: 2000));
     if (SafeAudioManager.instance.isRegistered(_getLocalizedSoundPath('pic-kanryo.ogg'))) {
      await SafeAudioManager.instance.play(_getLocalizedSoundPath('pic-kanryo.ogg'));
    } else {
      print('Sound not registered, skipping playback to avoid NotAllowedError pic-kanryo.ogg');
    }// 'pic-kanryo.ogg' に対応させ
    await Future.delayed(const Duration(milliseconds: 2500));
    SafeAudioManager.instance.resetAll();
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
        _isSecondRound ? '05‐016‐01‐00' : '05‐014‐01‐00',
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
            await _audioPlayer.play(AssetSource(_getLocalizedSoundPath('pl-himoduke.ogg')));
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

    if (_expandedStep == 0 && !_stepCompleted[0] && !_isSecondRound) {
      _startCountdownAndCompleteStep(0, 1, 1);
    }

    // Handle second round initialization
    if (_completedCount == 2 && !_stepCompleted[1] && _expandedStep == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _expandedStep = 1;
          });
          _requestFocusForExpandedStep();
        }
      });
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