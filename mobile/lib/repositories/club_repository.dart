import 'package:flutter/material.dart';
import '../models/club.dart';
import '../theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClubRepository {
  static const List<Club> clubs = [
    Club(
      id: 'neon_strikers',
      name: 'NEON STRIKERS',
      primaryColor: AppColors.neonGreen,
      secondaryColor: AppColors.electricBlue,
      assetPath: 'assets/clubs/neon_strikers.png',
    ),
    Club(
      id: 'cyber_united',
      name: 'CYBER UNITED',
      primaryColor: AppColors.electricBlue,
      secondaryColor: AppColors.neonPink,
      assetPath: 'assets/clubs/cyber_united.png',
    ),
    Club(
      id: 'plasma_fc',
      name: 'PLASMA FC',
      primaryColor: AppColors.alertRed,
      secondaryColor: Colors.orangeAccent,
      assetPath: 'assets/clubs/plasma_fc.png',
    ),
  ];

  static Future<void> saveSelectedClub(String clubId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_club_id', clubId);
  }

  static Future<Club> getSelectedClub() async {
    final prefs = await SharedPreferences.getInstance();
    final clubId = prefs.getString('selected_club_id');
    if (clubId != null) {
      return getClubById(clubId);
    }
    return clubs.first;
  }

  static Club getClubById(String id) {
    return clubs.firstWhere((club) => club.id == id, orElse: () => clubs.first);
  }
}
