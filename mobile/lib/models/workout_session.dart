class WorkoutSession {
  final DateTime date;
  final String drillType; // e.g., "Passing", "Shooting"
  final int reps;
  final int xpEarned;

  WorkoutSession({
    required this.date,
    required this.drillType,
    required this.reps,
    required this.xpEarned,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'drillType': drillType,
      'reps': reps,
      'xpEarned': xpEarned,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      date: DateTime.parse(json['date']),
      drillType: json['drillType'],
      reps: json['reps'],
      xpEarned: json['xpEarned'],
    );
  }
}
