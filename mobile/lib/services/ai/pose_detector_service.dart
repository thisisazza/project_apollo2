import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectorService {
  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      model: PoseDetectionModel.base, // Use base for performance
    ),
  );

  bool _isBusy = false;

  Future<void> processImage(
    InputImage inputImage,
    Function(List<Pose>) onPosesDetected,
  ) async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      final poses = await _poseDetector.processImage(inputImage);
      onPosesDetected(poses);
    } catch (e) {
      debugPrint('Error detecting poses: $e');
    } finally {
      _isBusy = false;
    }
  }

  void dispose() {
    _poseDetector.close();
  }
}
