import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../repositories/user_stats_repository.dart';
import '../repositories/economy_repository.dart';
import 'workout_logger_screen.dart';
import 'drill_view_screen.dart';
import 'shop_screen.dart';
import 'settings_screen.dart';
import 'career_screen.dart';
import 'locker_room_screen.dart';
import '../repositories/customization_repository.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // Listen to stats changes
    final statsRepo = UserStatsRepository();
    final economyRepo = EconomyRepository();

    return AnimatedBuilder(
      animation: Listenable.merge([statsRepo, economyRepo]),
      builder: (context, child) {
        final stats = statsRepo.stats;

        return Scaffold(
          appBar: AppBar(
            title: const Text('DASHBOARD'),
            leading: const Icon(Icons.menu),
            actions: [
              // Credits Display
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                        '${stats.streakDays} DAYS',
                        Icons.local_fire_department,
                        AppColors.alertRed,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'LEVEL ${stats.level}',
                        '${stats.xp} XP',
                        Icons.star,
                        AppColors.neonGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 2. Main Action (Start Workout)
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: const BoxDecoration(
                    gradient: AppColors.cyberGradient,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Navigate to Club Selection for now as a demo of "Profile/Club"
                        // In reality this would start a workout, but let's hook it to DrillView
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DrillViewScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'START TRAINING',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'TODAY: SPEED & AGILITY',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Recent Activity
                Text(
                  'RECENT ACTIVITY',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                _buildActivityItem(
                  context,
                  'LEG DAY',
                  'YESTERDAY',
                  'COMPLETED',
                ),
                const SizedBox(height: 12),
                _buildActivityItem(
                  context,
                  'HIIT CARDIO',
                  '2 DAYS AGO',
                  'COMPLETED',
                ),

                const SizedBox(height: 24),

                // 4. Career Mode Access
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.neonBlue, AppColors.neonPurple],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CareerScreen(),
                          ),
                        );
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: AppColors.textWhite,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 5. Locker Room Access
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LockerRoomScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceLight,
                      foregroundColor: AppColors.textWhite,
                      side: const BorderSide(color: AppColors.neonBlue),
                    ),
                    child: const Text('ENTER LOCKER ROOM'),
                  ),
                ),
                const SizedBox(height: 16),

                // 6. Shop Access (Economy)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonPink,
                      foregroundColor: AppColors.textWhite,
                    ),
                    child: const Text('OPEN CYBER SHOP'),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkoutLoggerScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.textGrey),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'VIEW FULL LOG',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ); // Close AnimatedBuilder
  } // Close build

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String date,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          left: BorderSide(color: AppColors.electricBlue, width: 4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              Text(date, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          Text(
            status,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.neonGreen),
          ),
        ],
      ),
    );
  }
}
