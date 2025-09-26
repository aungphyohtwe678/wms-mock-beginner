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
  bool _audioContextInitialized = false;
  bool _userHasInteracted = false;

  // Enable audio on first user interaction (iOS Safari requirement)
  Future<void> _enableAudioOnUserInteraction() async {
    if (!_userHasInteracted) {
      _userHasInteracted = true;
      print('User interaction detected - enabling audio for iOS Safari');
      try {
        // Play a silent sound to unlock audio context
        await _audioPlayer.setVolume(0.01);
        await _audioPlayer.play(AssetSource('sounds/kara-pl.ogg'));
        await Future.delayed(const Duration(milliseconds: 100));
        await _audioPlayer.stop();
        await _audioPlayer.setVolume(1.0);
        await _initializeAudioForSafari();
        print('Audio enabled successfully');
      } catch (e) {
        print('Error enabling audio: $e');
      }
    }
  }

  // iOS Safari specific audio initialization
  Future<void> _initializeAudioForSafari() async {
    if (!_audioContextInitialized) {
      try {
        // For iOS Safari, we need to ensure audio is enabled through user interaction
        // This should be called after user interaction (like the initial sound play)
        await _audioPlayer.setVolume(1.0);
        // Try to play and immediately stop to unlock audio context
        await _audioPlayer.play(AssetSource('sounds/kara-pl.ogg'));
        await Future.delayed(const Duration(milliseconds: 50));
        await _audioPlayer.stop();
        await Future.delayed(const Duration(milliseconds: 50));
        _audioContextInitialized = true;
        print('Audio context initialized for iOS Safari');
      } catch (e) {
        print('Error initializing audio context: $e');
        _audioContextInitialized = false;
      }
    }
  }

  // === Constants ===
  Future<void> _playStepSound(int stepIndex) async {
    final soundMap = {
      1: 'sounds/pic-start5.ogg',
      2: 'sounds/8c.ogg',
      3: 'sounds/4c.ogg',
      4: 'sounds/tumituke.ogg',
      5: 'sounds/syohin-scan.ogg',
      6: 'sounds/pic-asn.ogg',
      7: 'sounds/label-harituke.ogg',
      8: 'sounds/pic-kanryo.ogg',
      9: 'sounds/pic-start6.ogg'
    };
    
    if (soundMap.containsKey(stepIndex)) {
      print('Attempting to play sound for step $stepIndex: ${soundMap[stepIndex]}');
      
      // For iOS Safari, be more aggressive about audio context initialization
      try {
        // Force re-initialization if needed
        if (!_audioContextInitialized || stepIndex == 1) {
          print('Force initializing audio context for step $stepIndex');
          await _initializeAudioForSafari();
        }
        
        // Stop any currently playing audio
        await _audioPlayer.stop();
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Create new player instance for iOS Safari compatibility
        await _audioPlayer.setSource(AssetSource(soundMap[stepIndex]!));
        await Future.delayed(const Duration(milliseconds: 50));
        await _audioPlayer.resume();
        
        print('Successfully played sound for step $stepIndex: ${soundMap[stepIndex]}');
      } catch (e) {
        print('Error playing sound for step $stepIndex: $e');
        
        // iOS Safari fallback - multiple retry attempts with different strategies
        for (int retry = 0; retry < 5; retry++) {
          try {
            print('Retry attempt ${retry + 1} for step $stepIndex');
            await Future.delayed(Duration(milliseconds: 200 * (retry + 1)));
            
            // Different strategies for each retry
            if (retry == 0) {
              // Try direct play
              await _audioPlayer.play(AssetSource(soundMap[stepIndex]!));
            } else if (retry == 1) {
              // Try setSource then resume
              await _audioPlayer.setSource(AssetSource(soundMap[stepIndex]!));
              await _audioPlayer.resume();
            } else if (retry == 2) {
              // Try disposing and recreating player
              await _audioPlayer.dispose();
              final newPlayer = AudioPlayer();
              await newPlayer.play(AssetSource(soundMap[stepIndex]!));
            } else {
              // Last attempts with volume manipulation
              await _audioPlayer.setVolume(0.0);
              await _audioPlayer.play(AssetSource(soundMap[stepIndex]!));
              await Future.delayed(const Duration(milliseconds: 50));
              await _audioPlayer.setVolume(1.0);
            }
            
            print('Retry ${retry + 1} successful for step $stepIndex');
            break;
          } catch (e2) {
            print('Retry ${retry + 1} failed for step $stepIndex: $e2');
            if (retry == 4) {
              print('All retry attempts failed for step $stepIndex');
            }
          }
        }
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
      try {
        // Play initial sound first - this is user-triggered navigation
        await _audioPlayer.play(AssetSource('sounds/kara-pl.ogg'));
        print('Initial sound played successfully');
        
        // Wait for initial sound to finish and establish audio context
        await Future.delayed(const Duration(milliseconds: 1000));
        
        // Now initialize audio context for iOS Safari using the established context
        await _initializeAudioForSafari();
        
      } catch (e) {
        print('Error playing initial sound: $e');
      }
      
      // Initialize first step if needed (moved from build method)
      if (_expandedStep == 0 && !_stepCompleted[0] && !_isSecondRound) {
        // Add more delay before starting countdown to ensure audio is ready
        await Future.delayed(const Duration(milliseconds: 500));
        await _startCountdownAndCompleteStep(0, 1, 1);
      }
      
      // Fallback mechanism for iOS Safari - ensure step transition happens
      Future.delayed(const Duration(seconds: 8), () {  // Increased from 5 to 8 seconds
        if (mounted && _expandedStep == 0 && !_stepCompleted[0] && !_isSecondRound) {
          print('Fallback: Force transition from step 0 to step 1');
          setState(() {
            _stepCompleted[0] = true;
            _expandedStep = 1;
          });
          _requestFocusForExpandedStep();
          
          // Force audio context initialization in fallback
          _initializeAudioForSafari().then((_) {
            _playStepSound(1);
          });
        }
      });
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
    try {
      print('Starting countdown for step $stepIndex -> $nextStepIndex, sound: $soundStepIndex');
      
      for (int i = 3; i >= 1; i--) {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        print('Countdown: $i');
      }
      
      print('Playing step sound $soundStepIndex');
      await _playStepSound(soundStepIndex);
      
      if (mounted) {
        setState(() {
          _stepCompleted[stepIndex] = true;
          _expandedStep = nextStepIndex;
        });
        _requestFocusForExpandedStep();
        print('Step $stepIndex completed, moved to step $nextStepIndex');
      }
    } catch (e) {
      print('Error in _startCountdownAndCompleteStep: $e');
      // Fallback: still complete the step even if audio fails
      if (mounted) {
        setState(() {
          _stepCompleted[stepIndex] = true;
          _expandedStep = nextStepIndex;
        });
        _requestFocusForExpandedStep();
        
        // Try to play sound again after state update
        Future.delayed(const Duration(milliseconds: 100), () {
          _playStepSound(soundStepIndex);
        });
      }
    }
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
    await _playStepSound(4);
    await Future.delayed(const Duration(milliseconds: 2500));
    _playStepSound(5);

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
    await _audioPlayer.play(AssetSource('sounds/label-harituke.ogg'));
    await Future.delayed(const Duration(milliseconds: 3500));
    setState(() {
      _stepCompleted[2] = true;
      _stepCompleted[3] = true;
      _expandedStep = 4;
    });
    await _playStepSound(6);
  }

  Future<void> _processInvalidBarcode() async {
    await _audioPlayer.play(AssetSource('sounds/label-harituke.ogg'));
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
    await _audioPlayer.play(AssetSource('sounds/pl-himoduke.ogg'));
    await Future.delayed(const Duration(milliseconds: 1500));
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

    // Enable audio on first user interaction for iOS Safari
    await _enableAudioOnUserInteraction();

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
    await _audioPlayer.play(AssetSource('sounds/8c.ogg'));
    await Future.delayed(const Duration(milliseconds: 1000));
    await _audioPlayer.play(AssetSource('sounds/pic-kanryo.ogg'));
    await Future.delayed(const Duration(milliseconds: 2000));
    
    _resetForSecondRound();
    
    await _playStepSound(9); // 'pic-start3.ogg' に対応させる
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
    await _audioPlayer.play(AssetSource('sounds/4c.ogg'));
    await Future.delayed(const Duration(milliseconds: 1000));
    await _audioPlayer.play(AssetSource('sounds/pic-kanryo.ogg'));
    await Future.delayed(const Duration(milliseconds: 2000));
    
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
          // Audio enable button for iOS Safari
          if (!_audioContextInitialized && _expandedStep == 0)
            ElevatedButton.icon(
              onPressed: () async {
                await _enableAudioOnUserInteraction();
                // Force play pic-start5.ogg after enabling audio
                await Future.delayed(const Duration(milliseconds: 200));
                await _playStepSound(1);
              },
              icon: const Icon(Icons.volume_up, size: 16),
              label: const Text(
                'Enable Audio',
                style: TextStyle(fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 32),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_userHasInteracted && !_audioContextInitialized)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Tap to enable audio',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isWorkflowCompleted)
                  Text(
                    'Workflow completed',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
              ],
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
            await _audioPlayer.play(AssetSource('sounds/pl-himoduke.ogg'));
            await Future.delayed(const Duration(milliseconds: 1500));
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