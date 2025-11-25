enum CoachType { male, female }

class Drill {
  final String id;
  final String name;
  final String description;
  final String videoUrl;
  final CoachType coachType;
  final int durationSeconds;

  const Drill({
    required this.id,
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.coachType,
    required this.durationSeconds,
  });
}
