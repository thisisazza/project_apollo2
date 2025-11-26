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

  // Factory for initial state
  factory UserStats.initial() {
    return const UserStats(xp: 0, streakDays: 0, level: 1);
  }
}
