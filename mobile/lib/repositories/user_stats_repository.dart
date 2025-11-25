import 'package:flutter/material.dart';
import 'economy_repository.dart';

class UserStats {
  final int xp;
  final int streakDays;
  final int level;
  final int totalDrillsCompleted;

  const UserStats({
    required this.xp,
    required this.streakDays,
    required this.level,
    this.totalDrillsCompleted = 0,
  });
}

class UserStatsRepository extends ChangeNotifier {
  static final UserStatsRepository _instance = UserStatsRepository._internal();
  factory UserStatsRepository() => _instance;
  UserStatsRepository._internal();

  UserStats _stats = const UserStats(
    xp: 0,
    streakDays: 1,
    level: 1,
    totalDrillsCompleted: 0,
  );

  UserStats get stats => _stats;

  void addXp(int amount) {
    int newXp = _stats.xp + amount;
    int newLevel = (newXp / 1000).floor() + 1;

    _stats = UserStats(
      xp: newXp,
      streakDays: _stats.streakDays,
      level: newLevel,
      totalDrillsCompleted: _stats.totalDrillsCompleted,
    );

    // Award Credits (10% of XP)
    EconomyRepository().addCredits((amount * 0.1).ceil());

    notifyListeners();
  }

  void incrementStreak() {
    _stats = UserStats(
      xp: _stats.xp,
      streakDays: _stats.streakDays + 1,
      level: _stats.level,
      totalDrillsCompleted: _stats.totalDrillsCompleted,
    );
    notifyListeners();
  }

  void completeDrill() {
    _stats = UserStats(
      xp: _stats.xp,
      streakDays: _stats.streakDays,
      level: _stats.level,
      totalDrillsCompleted: _stats.totalDrillsCompleted + 1,
    );
    notifyListeners();
  }
}
