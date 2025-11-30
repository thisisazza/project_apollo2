import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeatureFlagService extends ChangeNotifier {
  static final FeatureFlagService _instance = FeatureFlagService._internal();
  factory FeatureFlagService() => _instance;
  FeatureFlagService._internal() {
    _loadFlags();
  }

  // Feature Flags
  bool _rivalryMode = false;
  bool _ghostOverlay = false;
  bool _aiAudioCoach = false;
  bool _clubIdentity = false;
  bool _smartProgression = false;
  bool _shopEnabled = false;

  // Getters
  bool get rivalryMode => _rivalryMode;
  bool get ghostOverlay => _ghostOverlay;
  bool get aiAudioCoach => _aiAudioCoach;
  bool get clubIdentity => _clubIdentity;
  bool get smartProgression => _smartProgression;
  bool get shopEnabled => _shopEnabled;

  Future<void> _loadFlags() async {
    final prefs = await SharedPreferences.getInstance();
    _rivalryMode = prefs.getBool('ff_rivalryMode') ?? false;
    _ghostOverlay = prefs.getBool('ff_ghostOverlay') ?? false;
    _aiAudioCoach = prefs.getBool('ff_aiAudioCoach') ?? false;
    _clubIdentity = prefs.getBool('ff_clubIdentity') ?? false;
    _smartProgression = prefs.getBool('ff_smartProgression') ?? false;
    _shopEnabled = prefs.getBool('ff_shopEnabled') ?? false;
    notifyListeners();
  }

  Future<void> toggleFeature(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'rivalryMode':
        _rivalryMode = value;
        await prefs.setBool('ff_rivalryMode', value);
        break;
      case 'ghostOverlay':
        _ghostOverlay = value;
        await prefs.setBool('ff_ghostOverlay', value);
        break;
      case 'aiAudioCoach':
        _aiAudioCoach = value;
        await prefs.setBool('ff_aiAudioCoach', value);
        break;
      case 'clubIdentity':
        _clubIdentity = value;
        await prefs.setBool('ff_clubIdentity', value);
        break;
      case 'smartProgression':
        _smartProgression = value;
        await prefs.setBool('ff_smartProgression', value);
        break;
      case 'shopEnabled':
        _shopEnabled = value;
        await prefs.setBool('ff_shopEnabled', value);
        break;
    }
    notifyListeners();
  }
}
