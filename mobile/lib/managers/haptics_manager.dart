import 'package:vibration/vibration.dart';
import '../repositories/settings_repository.dart';

class HapticsManager {
  static final HapticsManager _instance = HapticsManager._internal();
  factory HapticsManager() => _instance;
  HapticsManager._internal();

  Future<void> lightImpact() async {
    if (!SettingsRepository().hapticsEnabled) return;
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 15); // Short, light tap
    }
  }

  Future<void> heavyImpact() async {
    if (!SettingsRepository().hapticsEnabled) return;
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50); // Stronger thud
    }
  }

  Future<void> success() async {
    if (!SettingsRepository().hapticsEnabled) return;
    if (await Vibration.hasVibrator() ?? false) {
      // Double tap pattern
      Vibration.vibrate(pattern: [0, 50, 50, 50]);
    }
  }
}
