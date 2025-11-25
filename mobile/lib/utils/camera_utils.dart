import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class CameraUtils {
  static InputImage inputImageFromCameraImage({
    required CameraImage image,
    required CameraController controller,
    required List<CameraDescription> cameras,
    required int cameraIndex,
  }) {
    final camera = cameras[cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    // On iOS, the image orientation is already correct (usually).
    // On Android, we need to calculate it based on device orientation.
    // For MVP, we assume portrait mode.
    InputImageRotation rotation = InputImageRotation.rotation0deg;
    if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[controller.value.deviceOrientation];
      if (rotationCompensation == null) return _fallbackInputImage(image);
      if (camera.lensDirection == CameraLensDirection.front) {
        // Front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // Back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation =
          InputImageRotationValue.fromRawValue(rotationCompensation) ??
          InputImageRotation.rotation0deg;
    } else if (Platform.isIOS) {
      // iOS usually handles this, but we might need mapping if issues arise.
      rotation =
          InputImageRotationValue.fromRawValue(sensorOrientation) ??
          InputImageRotation.rotation0deg;
    }

    // Format
    final format =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
        InputImageFormat.nv21;

    // Plane Data
    if (image.planes.isEmpty) return _fallbackInputImage(image);

    // Since we are using YUV420 or BGRA8888, we need to construct the bytes.
    // For ML Kit on Android, it typically expects NV21 (which is YUV420).
    // On iOS, it expects BGRA8888.

    // Concatenate planes
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final inputImageMetadata = InputImageMetadata(
      size: imageSize,
      rotation: rotation,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);
  }

  static InputImage _fallbackInputImage(CameraImage image) {
    // Fallback or error handling - return a dummy or throw
    // For now, we try to return something valid to avoid crash
    return InputImage.fromBytes(
      bytes: Uint8List(0),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: 0,
      ),
    );
  }

  static final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
}
