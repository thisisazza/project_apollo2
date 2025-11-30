import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Request permissions
    var status = await Permission.camera.request();
    if (status.isDenied) {
      // Handle permission denied
      return;
    }

    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    // Use the first camera (usually back)
    _controller = CameraController(
      _cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (!mounted) return;

    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview
          SizedBox.expand(child: CameraPreview(_controller!)),

          // Overlay (Grid/Zones)
          // TODO: Draw map grid here

          // Controls
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // Start/Stop recording or calibration
                  },
                  child: const Icon(Icons.videocam),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
