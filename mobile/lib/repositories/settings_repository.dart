import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository extends ChangeNotifier {
  static final SettingsRepository _instance = SettingsRepository._internal();
  factory SettingsRepository() => _instance;
  SettingsRepository._internal() {
    _loadSettings();
  }

  bool _soundEnabled = true;
  bool _hapticsEnabled = true;
  bool _musicEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get musicEnabled => _musicEnabled;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _hapticsEnabled = prefs.getBool('hapticsEnabled') ?? true;
    _musicEnabled = prefs.getBool('musicEnabled') ?? true;
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', value);
    notifyListeners();
  }

  Future<void> setHapticsEnabled(bool value) async {
    _hapticsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hapticsEnabled', value);
    notifyListeners();
  }

  Future<void> setMusicEnabled(bool value) async {
    _musicEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('musicEnabled', value);
    notifyListeners();
  }
}
