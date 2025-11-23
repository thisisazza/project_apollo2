import 'package:flutter/material.dart';
import 'user_stats_repository.dart';

class CareerRank {
  final String id;
  final String title;
  final int minXp;
  final int requiredDrills;
  final String iconAsset;

  const CareerRank({
    required this.id,
    required this.title,
    required this.minXp,
    required this.requiredDrills,
    required this.iconAsset,
  });
}

class Arena {
  final String id;
  final String name;
  final String description;
  final String assetPath; // Background image
  final String requiredRankId;

  const Arena({
    required this.id,
    required this.name,
    required this.description,
    required this.assetPath,
    required this.requiredRankId,
  });
}

class CareerRepository {
  static final CareerRepository _instance = CareerRepository._internal();
  factory CareerRepository() => _instance;
  CareerRepository._internal();

  final List<CareerRank> ranks = [
    const CareerRank(
      id: 'rookie',
      title: 'STREET ROOKIE',
      minXp: 0,
      requiredDrills: 0,
      iconAsset: 'assets/ranks/rookie.png',
    ),
    const CareerRank(
      id: 'amateur',
      title: 'LOCAL HERO',
      minXp: 1000,
      requiredDrills: 10,
      iconAsset: 'assets/ranks/amateur.png',
    ),
    const CareerRank(
      id: 'semi_pro',
      title: 'ACADEMY PROSPECT',
      minXp: 5000,
      requiredDrills: 50,
      iconAsset: 'assets/ranks/semi_pro.png',
    ),
    const CareerRank(
      id: 'pro',
      title: 'RISING STAR',
      minXp: 15000,
      requiredDrills: 150,
      iconAsset: 'assets/ranks/pro.png',
    ),
    const CareerRank(
      id: 'world_class',
      title: 'WORLD CLASS',
      minXp: 50000,
      requiredDrills: 500,
      iconAsset: 'assets/ranks/world_class.png',
    ),
    const CareerRank(
      id: 'legend',
      title: 'CYBER LEGEND',
      minXp: 100000,
      requiredDrills: 1000,
      iconAsset: 'assets/ranks/legend.png',
    ),
  ];

  final List<Arena> arenas = [
    const Arena(
      id: 'cage',
      name: 'THE CAGE',
      description: 'Where it all begins. Concrete and steel.',
      assetPath: 'assets/arenas/cage.jpg',
      requiredRankId: 'rookie',
    ),
    const Arena(
      id: 'local_pitch',
      name: 'LOCAL PITCH',
      description: 'Sunday league vibes. Mud and glory.',
      assetPath: 'assets/arenas/pitch.jpg',
      requiredRankId: 'amateur',
    ),
    const Arena(
      id: 'academy',
      name: 'THE ACADEMY',
      description: 'Clean turf. Serious business.',
      assetPath: 'assets/arenas/academy.jpg',
      requiredRankId: 'semi_pro',
    ),
    const Arena(
      id: 'stadium',
      name: 'PRO STADIUM',
      description: 'Under the floodlights.',
      assetPath: 'assets/arenas/stadium.jpg',
      requiredRankId: 'pro',
    ),
    const Arena(
      id: 'cyber_arena',
      name: 'CYBER COLISEUM',
      description: 'The ultimate stage. Neon and noise.',
      assetPath: 'assets/arenas/cyber.jpg',
      requiredRankId: 'legend',
    ),
  ];

  CareerRank getCurrentRank() {
    final stats = UserStatsRepository().stats;
    // Find the highest rank met
    return ranks.lastWhere(
      (rank) =>
          stats.xp >= rank.minXp &&
          stats.totalDrillsCompleted >= rank.requiredDrills,
      orElse: () => ranks.first,
    );
  }

  CareerRank? getNextRank() {
    final current = getCurrentRank();
    final index = ranks.indexOf(current);
    if (index < ranks.length - 1) {
      return ranks[index + 1];
    }
    return null;
  }

  bool isArenaUnlocked(String arenaId) {
    final arena = arenas.firstWhere(
      (a) => a.id == arenaId,
      orElse: () => arenas.first,
    );
    final currentRank = getCurrentRank();
    final requiredRank = ranks.firstWhere((r) => r.id == arena.requiredRankId);

    // Simple logic: if current rank index >= required rank index
    return ranks.indexOf(currentRank) >= ranks.indexOf(requiredRank);
  }
}
