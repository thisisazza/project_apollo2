class UserStats {
  final int xp;
  final int streakDays;
  final int level;

  const UserStats({
    required this.xp,
    required this.streakDays,
    required this.level,
  });

  // Factory for initial state
  factory UserStats.initial() {
    return const UserStats(xp: 0, streakDays: 0, level: 1);
  }
}
