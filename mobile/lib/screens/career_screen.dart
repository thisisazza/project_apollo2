import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../repositories/career_repository.dart';
import '../repositories/user_stats_repository.dart';

class CareerScreen extends StatelessWidget {
  const CareerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final careerRepo = CareerRepository();
    final statsRepo = UserStatsRepository();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('YOUR CAREER'),
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: statsRepo,
        builder: (context, child) {
          final currentRank = careerRepo.getCurrentRank();
          final stats = statsRepo.stats;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.neonBlue,
                      child: Icon(
                        Icons.emoji_events,
                        size: 50,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentRank.title,
                      style: const TextStyle(
                        color: AppColors.neonBlue,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Teko',
                      ),
                    ),
                    Text(
                      '${stats.xp} XP • ${stats.totalDrillsCompleted} DRILLS',
                      style: const TextStyle(color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Roadmap
              ...careerRepo.ranks.map((rank) {
                final isUnlocked =
                    stats.xp >= rank.minXp &&
                    stats.totalDrillsCompleted >= rank.requiredDrills;
                final isCurrent = rank.id == currentRank.id;
                final isNext = careerRepo.getNextRank()?.id == rank.id;

                return _buildRankNode(
                  context,
                  rank,
                  isUnlocked,
                  isCurrent,
                  isNext,
                  stats,
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRankNode(
    BuildContext context,
    CareerRank rank,
    bool isUnlocked,
    bool isCurrent,
    bool isNext,
    UserStats stats,
  ) {
    Color color = isUnlocked ? AppColors.neonGreen : AppColors.textGrey;
    if (isCurrent) color = AppColors.neonBlue;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          // Timeline Line
          Column(
            children: [
              Container(
                width: 2,
                height: 30,
                color: AppColors.textGrey.withOpacity(0.3),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.neonBlue
                      : (isUnlocked ? AppColors.neonGreen : AppColors.surface),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: AppColors.neonBlue.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ]
                      : [],
                ),
                child: isUnlocked
                    ? const Icon(Icons.check, size: 12, color: AppColors.black)
                    : null,
              ),
              Container(
                width: 2,
                height: 30,
                color: AppColors.textGrey.withOpacity(0.3),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Content Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCurrent ? AppColors.neonBlue : Colors.transparent,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rank.title,
                        style: TextStyle(
                          color: isUnlocked
                              ? AppColors.textWhite
                              : AppColors.textGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (!isUnlocked)
                        const Icon(
                          Icons.lock,
                          color: AppColors.textGrey,
                          size: 16,
                        ),
                    ],
                  ),
                  if (isNext) ...[
                    const SizedBox(height: 8),
                    _buildRequirementRow('XP', stats.xp, rank.minXp),
                    const SizedBox(height: 4),
                    _buildRequirementRow(
                      'Drills',
                      stats.totalDrillsCompleted,
                      rank.requiredDrills,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String label, int current, int target) {
    final progress = (current / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label: $current / $target',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(color: AppColors.neonGreen, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.surfaceLight,
          color: AppColors.neonGreen,
          minHeight: 4,
        ),
      ],
    );
  }
}
