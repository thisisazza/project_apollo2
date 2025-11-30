import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../repositories/club_repository.dart';
import '../models/club.dart';
import '../services/feature_flag_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Club _club = ClubRepository.clubs.first;
  final _featureFlags = FeatureFlagService();

  @override
  void initState() {
    super.initState();
    _loadClub();
  }

  Future<void> _loadClub() async {
    final club = await ClubRepository.getSelectedClub();
    setState(() {
      _club = club;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('PLAYER PROFILE'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Club Identity Card
            _buildClubCard(),
            const SizedBox(height: 24),

            // 2. Stats Overview
            _buildStatsGrid(),
            const SizedBox(height: 24),

            // 3. Engagement Features
            _buildEngagementSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildClubCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _club.primaryColor.withOpacity(0.8),
            _club.secondaryColor.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _club.primaryColor.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shield, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _club.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Teko',
                  ),
                ),
                const Text(
                  "STRIKER • LVL 12",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              await Navigator.pushNamed(context, '/club_selection');
              _loadClub(); // Reload after return
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard("XP EARNED", "12,450", Icons.bolt, AppColors.neonGreen),
        _buildStatCard(
          "DRILLS",
          "142",
          Icons.sports_soccer,
          AppColors.electricBlue,
        ),
        _buildStatCard(
          "STREAK",
          "5 DAYS",
          Icons.local_fire_department,
          AppColors.neonPink,
        ),
        _buildStatCard("ACCURACY", "88%", Icons.gps_fixed, AppColors.alertRed),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Teko',
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementSection() {
    return AnimatedBuilder(
      animation: _featureFlags,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ENGAGEMENT",
              style: TextStyle(
                color: AppColors.neonBlue,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            if (_featureFlags.rivalryMode)
              _buildFeatureCard(
                "RIVALRY MODE ACTIVE",
                "You are competing against Ghost_01",
                Icons.people_outline,
                AppColors.neonPink,
              )
            else
              _buildFeatureCard(
                "RIVALRY MODE INACTIVE",
                "Enable in Settings to compete",
                Icons.people_outline,
                Colors.grey,
              ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
