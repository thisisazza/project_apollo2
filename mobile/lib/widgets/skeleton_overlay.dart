import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../theme/app_colors.dart';
import '../utils/coordinates_translator.dart';

class SkeletonOverlay extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  SkeletonOverlay({
    required this.poses,
    required this.imageSize,
    required this.rotation,
    required this.cameraLensDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = AppColors.neonGreen;

    final jointPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.electricBlue;

    for (final pose in poses) {
      // Helper to translate points
      Offset translatePoint(PoseLandmark landmark) {
        // For front camera, we typically need to mirror X
        // But ML Kit's coordinate system and the display might vary.
        // The standard translateX/Y helpers usually handle scaling.
        // Mirroring is often handled by the camera preview widget itself,
        // but if we are drawing ON TOP, we need to match.

        double x = translateX(landmark.x, rotation, size, imageSize);
        double y = translateY(landmark.y, rotation, size, imageSize);

        if (Platform.isAndroid &&
            cameraLensDirection == CameraLensDirection.front) {
          x = size.width - x;
        }
        return Offset(x, y);
      }

      void paintLine(PoseLandmarkType type1, PoseLandmarkType type2) {
        final PoseLandmark? joint1 = pose.landmarks[type1];
        final PoseLandmark? joint2 = pose.landmarks[type2];

        if (joint1 == null || joint2 == null) return;

        canvas.drawLine(translatePoint(joint1), translatePoint(joint2), paint);
      }

      // Torso
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);

      // Arms
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
      paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
      paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);

      // Legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
      paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
      paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
      paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);

      // Draw joints
      for (final landmark in pose.landmarks.values) {
        canvas.drawCircle(translatePoint(landmark), 6, jointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SkeletonOverlay oldDelegate) {
    return oldDelegate.poses != poses ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.rotation != rotation;
  }
}
