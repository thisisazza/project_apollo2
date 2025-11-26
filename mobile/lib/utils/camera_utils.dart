import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

// Stub class for Web compatibility
class CameraUtils {
  // Mock InputImage class since we removed the ML Kit import
  static dynamic inputImageFromCameraImage({
    required CameraImage image,
    required CameraController controller,
    required List<CameraDescription> cameras,
    required int cameraIndex,
  }) {
    return null;
  }
}
