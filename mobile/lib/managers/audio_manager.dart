import 'package:audioplayers/audioplayers.dart';
import '../repositories/settings_repository.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();

  // Preload common sounds
  Future<void> init() async {
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playSfx(String assetPath) async {
    if (!SettingsRepository().soundEnabled) return;

    // In a real app, we would use a pool of players for overlapping SFX
    // For MVP, stopping the previous SFX is acceptable or just fire and forget
    // We use Source from AssetSource
    try {
      // Note: Ensure you have assets in pubspec.yaml
      // For now, we will just log if assets are missing
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // print('Error playing SFX: $e');
    }
  }

  Future<void> startMusic() async {
    if (!SettingsRepository().musicEnabled) return;

    if (_musicPlayer.state != PlayerState.playing) {
      try {
        // Placeholder for cyberpunk music
        // await _musicPlayer.play(AssetSource('audio/cyberpunk_beat.mp3'));
      } catch (e) {
        // print('Error playing music: $e');
      }
    }
  }

  Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  // Call this when settings change
  void onSettingsChanged() {
    if (!SettingsRepository().musicEnabled) {
      stopMusic();
    } else {
      // Optionally restart music if we are in a screen that needs it
    }
  }
}
