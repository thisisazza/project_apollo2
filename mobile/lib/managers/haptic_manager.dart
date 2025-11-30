import 'package:flutter/services.dart';
import '../services/feature_flag_service.dart';
import '../repositories/settings_repository.dart';

class HapticManager {
  static final HapticManager _instance = HapticManager._internal();
  factory HapticManager() => _instance;
  HapticManager._internal();

  bool get _isEnabled {
    // Check both system settings and feature flags if needed
    // For now, just check SettingsRepository
    return SettingsRepository().hapticsEnabled;
  }

  Future<void> light() async {
    if (!_isEnabled) return;
    await HapticFeedback.lightImpact();
  }

  Future<void> medium() async {
    if (!_isEnabled) return;
    await HapticFeedback.mediumImpact();
  }

  Future<void> heavy() async {
    if (!_isEnabled) return;
    await HapticFeedback.heavyImpact();
  }

  Future<void> success() async {
    if (!_isEnabled) return;
    // Success pattern: two light taps
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  Future<void> error() async {
    if (!_isEnabled) return;
    // Error pattern: heavy vibration
    await HapticFeedback.vibrate();
  }

  Future<void> comboEscalation(int comboLevel) async {
    if (!_isEnabled) return;
    // Increase intensity based on combo
    if (comboLevel < 5) {
      await HapticFeedback.lightImpact();
    } else if (comboLevel < 10) {
      await HapticFeedback.mediumImpact();
    } else {
      await HapticFeedback.heavyImpact();
    }
  }
}
