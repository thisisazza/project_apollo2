import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WorkoutLoggerScreen extends StatelessWidget {
  const WorkoutLoggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WORKOUT LOG'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.neonGreen),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return const ExerciseLogCard(
            exerciseName: 'BARBELL SQUAT',
            sets: 4,
            reps: 8,
            weight: 100.0,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.neonGreen,
        child: const Icon(Icons.add, color: AppColors.black),
      ),
    );
  }
}

class ExerciseLogCard extends StatelessWidget {
  final String exerciseName;
  final int sets;
  final int reps;
  final double weight;

  const ExerciseLogCard({
    super.key,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.neonGreen, width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exerciseName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
              const Icon(Icons.more_vert, color: AppColors.textGrey),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat(context, 'SETS', sets.toString()),
              _buildStat(context, 'REPS', reps.toString()),
              _buildStat(context, 'KG', weight.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.electricBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value, style: Theme.of(context).textTheme.displaySmall),
      ],
    );
  }
}
