class UserStats {
  final int skillPoints;
  final int overallRating;
  final Map<String, int>
  attributes; // Pace, Shooting, Passing, Dribbling, Defense, Physical

  const UserStats({
    required this.xp,
    required this.streakDays,
    required this.level,
    this.totalDrillsCompleted = 0,
    this.skillPoints = 0,
    this.overallRating = 60,
    this.attributes = const {
      'PAC': 60,
      'SHO': 60,
      'PAS': 60,
      'DRI': 60,
      'DEF': 60,
      'PHY': 60,
    },
  });

  // Factory for initial state
  factory UserStats.initial() {
    return const UserStats(
      xp: 0,
      streakDays: 0,
      level: 1,
      totalDrillsCompleted: 0,
      skillPoints: 5, // Start with some points
      overallRating: 60,
      attributes: {
        'PAC': 60,
        'SHO': 60,
        'PAS': 60,
        'DRI': 60,
        'DEF': 60,
        'PHY': 60,
      },
    );
  }

  UserStats copyWith({
    int? xp,
    int? streakDays,
    int? level,
    int? totalDrillsCompleted,
    int? skillPoints,
    int? overallRating,
    Map<String, int>? attributes,
  }) {
    return UserStats(
      xp: xp ?? this.xp,
      streakDays: streakDays ?? this.streakDays,
      level: level ?? this.level,
      totalDrillsCompleted: totalDrillsCompleted ?? this.totalDrillsCompleted,
      skillPoints: skillPoints ?? this.skillPoints,
      overallRating: overallRating ?? this.overallRating,
      attributes: attributes ?? this.attributes,
    );
  }
}
