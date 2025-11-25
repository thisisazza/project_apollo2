import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../repositories/user_stats_repository.dart';
import '../repositories/economy_repository.dart';
import '../repositories/customization_repository.dart';
import 'workout_logger_screen.dart';
import 'drill_view_screen.dart';
import 'shop_screen.dart';
import 'settings_screen.dart';
import 'career_screen.dart';
import 'locker_room_screen.dart';
import 'analytics_screen.dart';
import '../widgets/cyber_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final statsRepo = UserStatsRepository();
    final economyRepo = EconomyRepository();
    final customizationRepo = CustomizationRepository();

    return AnimatedBuilder(
      animation: Listenable.merge([statsRepo, economyRepo, customizationRepo]),
      builder: (context, child) {
        final stats = statsRepo.stats;

        return Scaffold(
          appBar: _buildTopBar(context, economyRepo, customizationRepo),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Stats Row
                Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'STREAK',
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
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.2, end: 0),
                const SizedBox(height: 24),

                // 2. Main Action (Start Workout)
                Hero(
                  tag: 'start_training_card',
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: const BoxDecoration(
                      gradient: AppColors.cyberGradient,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
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
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),

                // 3. Recent Activity
                Text(
                  'RECENT ACTIVITY',
                  style: Theme.of(context).textTheme.headlineMedium,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 16),
                _buildActivityItem(
                  context,
                  'LEG DAY',
                  'YESTERDAY',
                  'COMPLETED',
                ).animate().fadeIn(delay: 300.ms).slideX(),
                const SizedBox(height: 12),
                _buildActivityItem(
                  context,
                  'HIIT CARDIO',
                  '2 DAYS AGO',
                  'COMPLETED',
                ).animate().fadeIn(delay: 400.ms).slideX(),

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
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'CAREER MODE',
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 20,
                                fontFamily: 'Teko',
                                fontWeight: FontWeight.bold,
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
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

                const SizedBox(height: 24),

                // 5. Locker Room Access
                Hero(
                  tag: 'locker_room_button',
                  child: CyberButton(
                    text: 'ENTER LOCKER ROOM',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LockerRoomScreen(),
                        ),
                      );
                    },
                    backgroundColor: AppColors.surfaceLight,
                    foregroundColor: AppColors.textWhite,
                    borderColor: AppColors.neonBlue,
                  ),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 16),

                // 6. Shop Access (Economy)
                CyberButton(
                  text: 'OPEN CYBER SHOP',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShopScreen(),
                      ),
                    );
                  },
                  backgroundColor: AppColors.neonPink,
                  foregroundColor: AppColors.textWhite,
                ).animate().fadeIn(delay: 700.ms),

                const SizedBox(height: 16),

                // 7. Analytics Access
                CyberButton(
                  text: 'VIEW PERFORMANCE DNA',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnalyticsScreen(),
                      ),
                    );
                  },
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.neonGreen,
                  borderColor: AppColors.neonGreen,
                ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 16),

                // 8. Workout Logger (Legacy)
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
                ).animate().fadeIn(delay: 900.ms),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildTopBar(
    BuildContext context,
    EconomyRepository economyRepo,
    CustomizationRepository customizationRepo,
  ) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        children: [
          // Profile Image (Customizable)
          CircleAvatar(
            radius: 24,
            backgroundColor: customizationRepo.currentThemeColor.withOpacity(
              0.2,
            ),
            child: Icon(
              customizationRepo.currentKitIcon,
              color: customizationRepo.currentThemeColor,
            ),
          ),
          const SizedBox(width: 12),

          // Greeting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WELCOME BACK,',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'CYBER ATHLETE',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 20,
                  fontFamily: 'Teko',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Credits
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.neonBlue.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.bolt, color: AppColors.neonBlue, size: 16),
              const SizedBox(width: 4),
              Text(
                '${economyRepo.credits} CR',
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Settings
        IconButton(
          icon: const Icon(Icons.settings, color: AppColors.textGrey),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }

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
