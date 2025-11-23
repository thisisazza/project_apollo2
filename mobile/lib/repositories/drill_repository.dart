import '../models/drill.dart';

class DrillRepository {
  static List<Drill> getDrills() {
    return [
      const Drill(
        id: '1',
        name: 'HIGH KNEES',
        description: 'Drive your knees up to your chest rapidly.',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', // Placeholder
        coachType: CoachType.female,
        durationSeconds: 45,
      ),
      const Drill(
        id: '2',
        name: 'JUMP SQUATS',
        description: 'Explosive jump from a squat position.',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', // Placeholder
        coachType: CoachType.male,
        durationSeconds: 30,
      ),
    ];
  }
}
