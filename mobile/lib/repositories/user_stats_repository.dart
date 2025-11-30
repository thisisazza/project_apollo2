import 'package:flutter/material.dart';
import 'economy_repository.dart';
import '../models/user_stats.dart';
import '../models/workout_session.dart';

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

  final List<WorkoutSession> _sessions = [];

  UserStats get stats => _stats;
  List<WorkoutSession> get sessions => List.unmodifiable(_sessions);

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

  void recordSession(String drillType, int reps, int xpEarned) {
    final session = WorkoutSession(
      date: DateTime.now(),
      drillType: drillType,
      reps: reps,
      xpEarned: xpEarned,
    );
    _sessions.add(session);

    // Also update aggregate stats
    addXp(xpEarned);
    completeDrill();

    notifyListeners();
  }

  void incrementStreak() {
      'Dribbling': 0,
      'Physical': 0,
      'Mental': 0,
    };

    for (var session in _sessions) {
      // Simple categorization based on drill type string
      // In a real app, Drill object would have a 'skillType' enum
      String type = session.drillType;
      if (breakdown.containsKey(type)) {
        breakdown[type] = (breakdown[type] ?? 0) + session.xpEarned;
      } else {
        // Default fallback or try to match substrings
        if (type.contains('Pass'))
          breakdown['Passing'] = (breakdown['Passing'] ?? 0) + session.xpEarned;
        else if (type.contains('Shoot'))
          breakdown['Shooting'] =
              (breakdown['Shooting'] ?? 0) + session.xpEarned;
        else if (type.contains('Dribble'))
          breakdown['Dribbling'] =
              (breakdown['Dribbling'] ?? 0) + session.xpEarned;
        else
          breakdown['Physical'] =
              (breakdown['Physical'] ?? 0) + session.xpEarned;
      }
    }

    // Normalize to 0-100 scale for radar chart (mock logic)
    // Let's say 1000 XP = 100 skill points
    return breakdown.map(
      (key, value) => MapEntry(key, (value / 10).clamp(0, 100).toInt()),
    );
  }

  List<int> getLast7DaysXp() {
    final now = DateTime.now();
    final List<int> dailyXp = List.filled(7, 0);

    for (var session in _sessions) {
      final difference = now.difference(session.date).inDays;
      if (difference < 7 && difference >= 0) {
        // 0 = today, 6 = 7 days ago
        // We want index 6 to be today, 0 to be 7 days ago for the chart
        // Actually, usually charts go Left (Old) -> Right (New)
        // So index 0 = 6 days ago, index 6 = Today

        int index = 6 - difference;
        if (index >= 0 && index < 7) {
          dailyXp[index] += session.xpEarned;
        }
      }
    }
    return dailyXp;
  }
}
