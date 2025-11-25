import 'package:flutter/material.dart';
import '../models/club.dart';
import '../theme/app_colors.dart';

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

  static Club getClubById(String id) {
    return clubs.firstWhere((club) => club.id == id, orElse: () => clubs.first);
  }
}
