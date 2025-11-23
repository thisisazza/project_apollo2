  const DrillViewScreen({super.key});

  @override
  State<DrillViewScreen> createState() => _DrillViewScreenState();
}

class _DrillViewScreenState extends State<DrillViewScreen> {
  late Drill _currentDrill;

  // Camera & ML Kit
  CameraController? _cameraController;
  PoseDetector? _poseDetector;
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  List<Pose> _poses = [];
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 1; // Default to front camera (1 usually)

  // Frame skipping
  int _frameCounter = 0;
  static const int _skipFrames = 2; // Process every 3rd frame

  @override
  void initState() {
    super.initState();
    _currentDrill = DrillRepository.getDrills().first;
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      // Find front camera if possible
      _cameraIndex = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
      if (_cameraIndex == -1) _cameraIndex = 0;

      _cameraController = CameraController(
        _cameras[_cameraIndex],
        ResolutionPreset
            .medium, // Medium is usually sufficient for Pose Detection and faster
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController?.initialize();

      // Initialize Pose Detector
      final options = PoseDetectorOptions(mode: PoseDetectionMode.stream);
      _poseDetector = PoseDetector(options: options);

      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });

      _startImageStream();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  void _startImageStream() {
    if (_cameraController == null) return;

    _cameraController?.startImageStream((CameraImage image) async {
      if (_isDetecting) return;

      _frameCounter++;
      if (_frameCounter % (_skipFrames + 1) != 0) return;

      _isDetecting = true;

      try {
        final inputImage = CameraUtils.inputImageFromCameraImage(
          image: image,
          controller: _cameraController!,
  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _poseDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // 1. Camera Feed
          if (_isCameraInitialized && _cameraController != null)
            SizedBox.expand(child: CameraPreview(_cameraController!))
          else
            Container(
              color: Colors.grey[900],
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.neonGreen),
              ),
            ),

          // 2. AI Coach Overlay (Top Center)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 200,
                height: 300,
                child: AiCoachPlayer(videoUrl: _currentDrill.videoUrl),
              ),
            ),
              ),
              child: Container(),
            ),

          // 4. HUD Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start),
            ),
          ),

          // Back Button
          Positioned(
            top: 48,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHudBadge(String text, {Color color = AppColors.alertRed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        color: color.withOpacity(0.1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontFamily: 'Teko',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
