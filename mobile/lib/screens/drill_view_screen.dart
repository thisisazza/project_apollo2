// import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'; // Disabled for Web
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_colors.dart';
import '../models/drill.dart'; 
import '../repositories/drill_repository.dart';
import '../widgets/ai_coach_player.dart'; 
import '../utils/camera_utils.dart';
import '../managers/casting_manager.dart';

class DrillViewScreen extends StatefulWidget {
  const DrillViewScreen({super.key});

  @override
  State<DrillViewScreen> createState() => _DrillViewScreenState();
}

class _DrillViewScreenState extends State<DrillViewScreen> {
  late Drill _currentDrill;

  // Camera & ML Kit
  CameraController? _cameraController;
  // PoseDetector? _poseDetector; // Disabled
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  // List<Pose> _poses = []; // Disabled
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 1; 

  // Frame skipping
  int _frameCounter = 0;
  static const int _skipFrames = 2; 

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
        ResolutionPreset.medium,
        enableAudio: false,
        // imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888, // Platform check fails on web
      );

      await _cameraController?.initialize();

      // Initialize Pose Detector
      // final options = PoseDetectorOptions(mode: PoseDetectionMode.stream);
      // _poseDetector = PoseDetector(options: options);

      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });

      // _startImageStream(); // Disabled for Web/Stub
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  void _startImageStream() {
    // Disabled
  }
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    // _poseDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Feed (Full Screen)
          if (_isCameraInitialized && _cameraController != null)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _cameraController!.value.previewSize!.height,
                  height: _cameraController!.value.previewSize!.width,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            )
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.neonGreen),
              ),
            ),

          // 2. Minimalist HUD (Top)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button (Glassmorphism)
                  _buildGlassIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  
                  // Drill Title
                  _buildGlassBadge(_currentDrill.name),

                  // Settings/Cast Button
                  _buildGlassIconButton(
                    icon: Icons.cast,
                    onPressed: () {
                      _showCastingModal(context);
                    },
                  ),
                ],
              ),
            ),
          ),

          // 3. AI Coach (Draggable/Floating PIP)
          Positioned(
            top: 100,
            right: 16,
            child: SizedBox(
              width: 120,
              height: 180,
              child: AiCoachPlayer(videoUrl: _currentDrill.videoUrl),
            ),
          ),

          // 4. Interactive Feedback / Stats (Bottom)
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildGlassBadge("BALL DETECTED", color: AppColors.neonGreen),
                const SizedBox(height: 8),
                Text(
                  "KEEP IT UP!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: AppColors.neonGreen,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildGlassBadge(String text, {Color color = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
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

  void _showCastingModal(BuildContext context) {
    final castingManager = CastingManager(); // In a real app, provide this instance
    castingManager.startScanning();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CAST TO DEVICE",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.neonGreen,
                fontFamily: 'Teko',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: castingManager,
              builder: (context, _) {
                if (castingManager.isScanning) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(color: AppColors.neonGreen),
                    ),
                  );
                }

                if (castingManager.devices.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "No devices found.",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: castingManager.devices.length,
                  itemBuilder: (context, index) {
                    final device = castingManager.devices[index];
                    return ListTile(
                      leading: const Icon(Icons.tv, color: Colors.white),
                      title: Text(device, style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        castingManager.connectToDevice(device);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Connected to $device')),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
