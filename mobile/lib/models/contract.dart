class Contract {
  final String id;
  final String clubName;
  final int weeklyWage;
  final int goalBonus;
  final int durationWeeks;
  final int weeksRemaining;
  final String difficulty; // 'Rookie', 'Pro', 'World Class'

  const Contract({
    required this.id,
    required this.clubName,
    required this.weeklyWage,
    required this.goalBonus,
    required this.durationWeeks,
    required this.weeksRemaining,
    required this.difficulty,
  });

  Contract copyWith({
    String? id,
    String? clubName,
    int? weeklyWage,
    int? goalBonus,
    int? durationWeeks,
    int? weeksRemaining,
    String? difficulty,
  }) {
    return Contract(
      id: id ?? this.id,
      clubName: clubName ?? this.clubName,
      weeklyWage: weeklyWage ?? this.weeklyWage,
      goalBonus: goalBonus ?? this.goalBonus,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      weeksRemaining: weeksRemaining ?? this.weeksRemaining,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
