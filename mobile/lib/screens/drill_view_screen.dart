import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../services/ai/pose_detector_service.dart';
import '../services/ai/rep_counter.dart';
import '../widgets/pose_painter.dart';

class DrillViewScreen extends StatefulWidget {
  final Drill drill;
  const DrillViewScreen({super.key, required this.drill});

  @override
  State<DrillViewScreen> createState() => _DrillViewScreenState();
}

class _DrillViewScreenState extends State<DrillViewScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  int _repCount = 0;
  int _currentStepIndex = 0;
  final FlutterTts _flutterTts = FlutterTts();

  // AI Vision
  final _poseDetector = PoseDetectorService();
  final _repCounter = RepCounter();
  List<Pose> _poses = [];
  bool _isDetecting = false;

  // Managers
  final _hapticManager = HapticManager();
  final _audioManager = AudioCoachManager();
  final _featureFlags = FeatureFlagService();
  final _settings = SettingsRepository();
  final _statsRepo = UserStatsRepository();
  final _economyRepo = EconomyRepository();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initTts();
    _startDrill();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
  }

  Future<void> _speak(String text) async {
    if (_featureFlags.aiAudioCoach) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    // Use front camera for selfie mode
    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420, // Required for Android ML Kit
    );

    await _cameraController?.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
      _startImageStream();
    }
  }

  void _startImageStream() {
    _cameraController?.startImageStream((image) {
      if (_isDetecting) return;
      _isDetecting = true;

      final inputImage = _convertCameraImage(image);
      if (inputImage == null) {
        _isDetecting = false;
        return;
      }

      _poseDetector.processImage(inputImage, (poses) {
        if (!mounted) return;

        setState(() {
          _poses = poses;
        });

        // Process Reps
        if (poses.isNotEmpty) {
          // Heuristic: Check drill title for type
          DrillType type = DrillType.unknown;
          if (widget.drill.title.toLowerCase().contains('squat')) {
            type = DrillType.squat;
          } else if (widget.drill.title.toLowerCase().contains('knees')) {
            type = DrillType.highKnees;
          }

          if (type != DrillType.unknown) {
            final oldReps = _repCounter.reps;
            _repCounter.processPose(poses.first, type);
            if (_repCounter.reps > oldReps) {
              _onRepCompleted();
            }
          }
        }

        _isDetecting = false;
      });
    });
  }

  // Helper to convert CameraImage to InputImage (Simplified for Android)
  InputImage? _convertCameraImage(CameraImage image) {
    final allBytes = WriteBuffer();
    for (finalPlane in image.planes) {
      allBytes.putUint8List(finalPlane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final InputImageRotation imageRotation =
        InputImageRotation.rotation270deg; // Typical for front camera Android
    final InputImageFormat inputImageFormat =
        InputImageFormat.yuv420; // Default for Android

    final planeData = image.planes.map((Plane plane) {
      return InputImagePlaneMetadata(
        bytesPerRow: plane.bytesPerRow,
        height: plane.height,
        width: plane.width,
      );
    }).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  }

  void _startDrill() {
    // Initial encouragement
    Future.delayed(const Duration(seconds: 1), () {
      _speak(
        "Starting ${widget.drill.title}. ${widget.drill.steps.first.instruction}",
      );
    });
  }

  void _onRepCompleted() {
    setState(() {
      _repCount = _repCounter.reps;
    });

    // Dopamine Hits
    if (_settings.hapticsEnabled) {
      _hapticManager.success();
    }

    // Check for step completion (Mock logic: 5 reps per step)
    if (_repCount % 5 == 0) {
      _advanceStep();
    } else {
      // Encouragement every few reps
      if (_repCount % 2 == 0) {
        _speak("$_repCount");
      }
    }
  }

  // Manual fallback
  void _simulateRep() {
    // ... (Keep existing logic if needed, or remove)
    _onRepCompleted(); // Reuse logic
  }

  void _advanceStep() {
    if (_currentStepIndex < widget.drill.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
      _speak("Next step. ${widget.drill.steps[_currentStepIndex].instruction}");
    } else {
      _finishDrill();
    }
  }

  void _finishDrill() {
    _speak("Drill complete! Great work.");
    _cameraController?.stopImageStream(); // Stop AI

    // Rewards
    _statsRepo.addXp(100);
    _statsRepo.addSkillPoints(1); // Award 1 SP
    _economyRepo.addCredits(50);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'DRILL COMPLETE',
          style: TextStyle(
            color: AppColors.neonGreen,
            fontFamily: 'Teko',
            fontSize: 32,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+100 XP',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '+1 SP',
              style: TextStyle(
                color: AppColors.neonPurple,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '+50 CR',
              style: TextStyle(
                color: AppColors.neonBlue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
              foregroundColor: AppColors.black,
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to selection
            },
            child: const Text('CONTINUE'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _poseDetector.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = widget.drill.steps[_currentStepIndex];

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // 1. Camera Layer
          if (_isCameraInitialized)
            SizedBox.expand(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CameraPreview(_cameraController!),
                  // Pose Overlay
                  CustomPaint(
                    painter: PosePainter(
                      _poses,
                      Size(
                        _cameraController!.value.previewSize!.height,
                        _cameraController!.value.previewSize!.width,
                      ),
                      InputImageRotation.rotation270deg,
                    ),
                  ),
                ],
              ),
            )
          else
            const Center(
              child: Text(
                "Initializing AI Vision...",
                style: TextStyle(color: Colors.white),
              ),
            ),

          // 2. Cyber Overlay
          const CyberOverlay(),

          // 3. AI Coach Layer (PiP)
          if (_featureFlags.ghostOverlay)
            Positioned(
              top: 50,
              right: 20,
              width: 120,
              height: 180,
              child: const AiCoachPlayer(
                videoUrl:
                    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', // Placeholder
              ),
            ),

          // 4. Phase Indicator (Top Center)
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Center(
              child: PhaseIndicator(
                phaseName:
                    "STEP ${_currentStepIndex + 1}/${widget.drill.steps.length}",
                instruction: currentStep.instruction,
              ),
            ),
          ),

          // 5. HUD Layer (Bottom)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Rep Counter with Pulse Animation
                Text(
                      "REPS: $_repCount",
                      style: const TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Teko',
                        shadows: [
                          Shadow(color: AppColors.neonGreen, blurRadius: 20),
                        ],
                      ),
                    )
                    .animate(key: ValueKey(_repCount))
                    .scale(duration: 200.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 20),
                // Manual override still useful for testing
                ElevatedButton(
                  onPressed: _simulateRep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: const BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                  child: const Text(
                    "MANUAL REP",
                    style: TextStyle(color: Colors.white, fontFamily: 'Teko'),
                  ),
                ),
              ],
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
