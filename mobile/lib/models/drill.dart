enum Difficulty { beginner, intermediate, advanced, pro }

enum DrillCategory { passing, dribbling, shooting, fitness, reaction }

class DrillStep {
  final int stepId;
  final String instruction;
  final String voiceCommand;
  final String actionType;
  final int targetZone;
  final double timeoutSeconds;
  final double nextStepDelay;

  const DrillStep({
    required this.stepId,
    required this.instruction,
    required this.voiceCommand,
    required this.actionType,
    required this.targetZone,
    required this.timeoutSeconds,
    required this.nextStepDelay,
  });

  factory DrillStep.fromJson(Map<String, dynamic> json) {
    return DrillStep(
      stepId: json['step_id'],
      instruction: json['instruction'],
      voiceCommand: json['voice_command'],
      actionType: json['action_type'],
      targetZone: json['target_zone'],
      timeoutSeconds: (json['timeout_seconds'] as num).toDouble(),
      nextStepDelay: (json['next_step_delay'] as num).toDouble(),
    );
  }
}

class Drill {
  final String id;
  final String title;
  final String description;
  final Difficulty difficulty;
  final DrillCategory category;
  final int durationSeconds;
  final String author;
  final List<DrillStep> steps;

  const Drill({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    required this.durationSeconds,
    required this.author,
    required this.steps,
  });

  factory Drill.fromJson(Map<String, dynamic> json) {
    final drillData = json['drill'];
    return Drill(
      id: drillData['id'],
      title: drillData['title'],
      description: drillData['description'],
      difficulty: Difficulty.values.firstWhere(
        (e) => e.name == drillData['difficulty'],
        orElse: () => Difficulty.beginner,
      ),
      category: DrillCategory.values.firstWhere(
        (e) => e.name == drillData['category'],
        orElse: () => DrillCategory.passing,
      ),
      durationSeconds: drillData['duration_seconds'],
      author: drillData['author'],
      steps: (drillData['steps'] as List)
          .map((step) => DrillStep.fromJson(step))
          .toList(),
    );
  }
}
