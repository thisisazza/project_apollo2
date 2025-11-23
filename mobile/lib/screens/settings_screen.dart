import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../repositories/settings_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsRepository();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('SYSTEM SETTINGS'),
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: settings,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader(context, 'AUDIO & HAPTICS'),
              _buildSwitchTile(
                context,
                'SOUND EFFECTS',
                'Enable UI sounds and feedback',
                settings.soundEnabled,
                (val) => settings.setSoundEnabled(val),
                Icons.volume_up,
              ),
              _buildSwitchTile(
                context,
                'BACKGROUND MUSIC',
                'Cyberpunk beats during drills',
                settings.musicEnabled,
                (val) => settings.setMusicEnabled(val),
                Icons.music_note,
              ),
              _buildSwitchTile(
                context,
                'HAPTIC FEEDBACK',
                'Vibration on interaction',
                settings.hapticsEnabled,
                (val) => settings.setHapticsEnabled(val),
                Icons.vibration,
              ),

              const SizedBox(height: 32),
              _buildSectionHeader(context, 'DEVICE'),
              _buildInfoTile(context, 'VERSION', '1.0.0 (Alpha)', Icons.info),
              _buildInfoTile(context, 'BUILD', '2025.11.23', Icons.build),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.neonBlue,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value
              ? AppColors.neonGreen.withOpacity(0.5)
              : AppColors.textGrey.withOpacity(0.3),
        ),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.neonGreen,
        inactiveThumbColor: AppColors.textGrey,
        inactiveTrackColor: AppColors.surfaceLight,
        secondary: Icon(
          icon,
          color: value ? AppColors.neonGreen : AppColors.textGrey,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textGrey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textGrey),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(color: AppColors.textGrey)),
        ],
      ),
    );
  }
}
