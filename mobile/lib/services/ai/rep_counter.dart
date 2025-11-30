import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum DrillType { squat, highKnees, unknown }

class RepCounter {
  int _reps = 0;
  bool _isDown = false; // For squats: true when hips are low
  bool _isUp = true; // For squats: true when standing

  // High Knees state
  bool _leftLegUp = false;
  bool _rightLegUp = false;

  int get reps => _reps;

  void processPose(Pose pose, DrillType type) {
    if (type == DrillType.squat) {
      _processSquat(pose);
    } else if (type == DrillType.highKnees) {
      _processHighKnees(pose);
    }
  }

  void _processSquat(Pose pose) {
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final rightHip = pose.landmarks[PoseLandmarkType.rightHip];
    final rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];

    if (leftHip == null ||
        leftKnee == null ||
        rightHip == null ||
        rightKnee == null)
      return;

    // Simple heuristic: Hip Y > Knee Y (remember Y increases downwards in image coordinates)
    // Actually, usually Hip is ABOVE Knee (smaller Y). When squatting, Hip gets closer to Knee Y.
    // Let's use a threshold.

    // Check if hips are low enough (close to knee level)
    // Note: In image coords, larger Y is lower on screen.
    // Standing: Hip Y << Knee Y
    // Squatting: Hip Y ~= Knee Y

    final hipY = (leftHip.y + rightHip.y) / 2;
    final kneeY = (leftKnee.y + rightKnee.y) / 2;

    // Threshold: Hip is within 15% of Knee height (relative to body size?)
    // Let's try a simple relative check first.

    bool isSquatting =
        hipY > (kneeY - 100); // Very rough heuristic, needs calibration

    if (isSquatting) {
      if (_isUp) {
        _isDown = true;
        _isUp = false;
      }
    } else {
      if (_isDown) {
        _reps++;
        _isDown = false;
        _isUp = true;
      }
    }
  }

  void _processHighKnees(Pose pose) {
    final leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
    final rightHip = pose.landmarks[PoseLandmarkType.rightHip];

    if (leftKnee == null ||
        leftHip == null ||
        rightKnee == null ||
        rightHip == null)
      return;

    // High Knee: Knee Y < Hip Y (Knee is higher than Hip)

    bool leftUp = leftKnee.y < leftHip.y;
    bool rightUp = rightKnee.y < rightHip.y;

    if (leftUp && !_leftLegUp) {
      _reps++; // Count every step
      _leftLegUp = true;
    } else if (!leftUp) {
      _leftLegUp = false;
    }

    if (rightUp && !_rightLegUp) {
      _reps++;
      _rightLegUp = true;
    } else if (!rightUp) {
      _rightLegUp = false;
    }
  }

  void reset() {
    _reps = 0;
    _isDown = false;
    _isUp = true;
  }
}
