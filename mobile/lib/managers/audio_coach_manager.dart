import 'package:flutter_tts/flutter_tts.dart';
import '../services/feature_flag_service.dart';

class AudioCoachManager {
  static final AudioCoachManager _instance = AudioCoachManager._internal();
  factory AudioCoachManager() => _instance;

  late FlutterTts _flutterTts;
  bool _isInitialized = false;

  AudioCoachManager._internal() {
    _initTts();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    _isInitialized = true;
  }

  bool get _isEnabled {
    return FeatureFlagService().aiAudioCoach;
  }

  Future<void> speak(String text) async {
    if (!_isEnabled || !_isInitialized) return;
    // Don't overlap too much, maybe stop previous?
    // await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> encourage() async {
    if (!_isEnabled) return;
    const phrases = [
      "Great job!",
      "Keep it up!",
      "You're on fire!",
      "Excellent form!",
    ];
    await speak(
      phrases[DateTime.now().millisecondsSinceEpoch % phrases.length],
    );
  }

  Future<void> correct(String correction) async {
    if (!_isEnabled) return;
    await speak(correction);
  }
}
