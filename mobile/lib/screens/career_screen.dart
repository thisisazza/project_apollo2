import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Assuming we might use provider later, but for now direct repo access
import '../theme/app_colors.dart';
import '../repositories/career_repository.dart';
import '../repositories/user_stats_repository.dart';
import '../repositories/economy_repository.dart';
import '../widgets/cyber_button.dart';
import '../models/contract.dart';
import '../managers/haptics_manager.dart';

class CareerScreen extends StatefulWidget {
  const CareerScreen({super.key});

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
  final _careerRepo = CareerRepository();
  final _statsRepo = UserStatsRepository();
  final _economyRepo = EconomyRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('CAREER HUB'),
        backgroundColor: Colors.transparent,
        actions: [
          // Skill Points Indicator
          AnimatedBuilder(
            animation: _statsRepo,
            builder: (context, _) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neonPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.neonPurple),
                ),
                child: Text(
                  '${_statsRepo.stats.skillPoints} SP',
                  style: const TextStyle(
                    color: AppColors.neonPurple,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Teko',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge(
          [_statsRepo, _economyRepo],
        ), // Listen to both if needed, but repo isn't a ChangeNotifier itself usually unless mixed in.
        // UserStatsRepository extends ChangeNotifier? Let's assume yes based on previous code.
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlayerCard(),
                const SizedBox(height: 24),
                _buildContractSection(),
                const SizedBox(height: 24),
                _buildMatchCenter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerCard() {
    final stats = _statsRepo.stats;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonBlue.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Avatar & OVR
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.neonBlue, width: 3),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/avatar_placeholder.png',
                    ), // Need a placeholder
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neonBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${stats.overallRating} OVR',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Teko',
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Attributes
          Expanded(
            child: Column(
              children: [
                _buildStatRow(
                  'PAC',
                  stats.attributes['PAC']!,
                  'SHO',
                  stats.attributes['SHO']!,
                ),
                const SizedBox(height: 8),
                _buildStatRow(
                  'PAS',
                  stats.attributes['PAS']!,
                  'DRI',
                  stats.attributes['DRI']!,
                ),
                const SizedBox(height: 8),
                _buildStatRow(
                  'DEF',
                  stats.attributes['DEF']!,
                  'PHY',
                  stats.attributes['PHY']!,
                ),
                const SizedBox(height: 16),
                CyberButton(
                  text: 'UPGRADE ATTRIBUTES',
                  onPressed: () => _showUpgradeDialog(),
                  height: 40,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String l1, int v1, String l2, int v2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildStatItem(l1, v1), _buildStatItem(l2, v2)],
    );
  }

  Widget _buildStatItem(String label, int value) {
    return SizedBox(
      width: 80,
      child: Row(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Teko',
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildContractSection() {
    final contract = _careerRepo.currentContract;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: contract != null ? AppColors.neonGreen : AppColors.textGrey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CONTRACT STATUS',
                style: TextStyle(
                  color: contract != null
                      ? AppColors.neonGreen
                      : AppColors.textGrey,
                  fontFamily: 'Teko',
                  fontSize: 24,
                ),
              ),
              if (contract != null)
                const Icon(Icons.check_circle, color: AppColors.neonGreen),
            ],
          ),
          const SizedBox(height: 16),
          if (contract != null) ...[
            Text(
              contract.clubName.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Teko',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Wage: ${contract.weeklyWage} CR / Week',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              'Goal Bonus: ${contract.goalBonus} CR',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              'Remaining: ${contract.weeksRemaining} Weeks',
              style: const TextStyle(color: AppColors.neonBlue),
            ),
          ] else ...[
            const Text(
              'You are currently a Free Agent.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            CyberButton(
              text: 'OPEN TRANSFER MARKET',
              onPressed: () => _showTransferMarket(),
              backgroundColor: AppColors.neonBlue,
              foregroundColor: Colors.black,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchCenter() {
    final contract = _careerRepo.currentContract;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonPink),
      ),
      child: Column(
        children: [
          const Text(
            'MATCH CENTER',
            style: TextStyle(
              color: AppColors.neonPink,
              fontFamily: 'Teko',
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'NEXT OPPONENT: RIVAL FC',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          CyberButton(
            text: 'SIMULATE MATCH',
            onPressed: contract != null ? () => _simulateMatch() : null,
            backgroundColor: contract != null
                ? AppColors.neonPink
                : Colors.grey,
            foregroundColor: Colors.white,
          ),
          if (contract == null)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Sign a contract to play matches.',
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => _UpgradeDialog(statsRepo: _statsRepo),
    );
  }

  void _showTransferMarket() {
    final offers = _careerRepo.generateContractOffers();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.black,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'TRANSFER OFFERS',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Teko',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            ...offers.map(
              (offer) => ListTile(
                title: Text(
                  offer.clubName,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${offer.weeklyWage} CR/Week • ${offer.difficulty}',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonGreen,
                  ),
                  onPressed: () {
                    _careerRepo.signContract(offer);
                    Navigator.pop(context);
                    setState(() {}); // Refresh UI
                  },
                  child: const Text(
                    'SIGN',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _simulateMatch() {
    final result = _careerRepo.simulateMatch();
    final won = result['won'] as bool;
    final score = result['score'] as int;
    final goals = result['goals'] as int;
    final wage = result['wage'] as int;
    final bonus = result['bonus'] as int;
    final totalEarned = wage + bonus;

    if (result['played'] == true) {
      _economyRepo.addCredits(totalEarned);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            won ? 'VICTORY!' : 'DEFEAT',
            style: TextStyle(
              color: won ? AppColors.neonGreen : Colors.red,
              fontFamily: 'Teko',
              fontSize: 32,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Performance Score: $score',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Goals Scored: $goals',
                style: const TextStyle(color: Colors.white70),
              ),
              const Divider(color: Colors.grey),
              Text(
                'Wage: $wage CR',
                style: const TextStyle(color: AppColors.neonBlue),
              ),
              Text(
                'Bonus: $bonus CR',
                style: const TextStyle(color: AppColors.neonBlue),
              ),
              const SizedBox(height: 8),
              Text(
                'TOTAL: +$totalEarned CR',
                style: const TextStyle(
                  color: AppColors.neonGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {}); // Refresh UI
              },
              child: const Text(
                'CONTINUE',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _UpgradeDialog extends StatefulWidget {
  final UserStatsRepository statsRepo;

  const _UpgradeDialog({required this.statsRepo});

  @override
  State<_UpgradeDialog> createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<_UpgradeDialog> {
  @override
  Widget build(BuildContext context) {
    final stats = widget.statsRepo.stats;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'ATTRIBUTE UPGRADE',
            style: TextStyle(color: Colors.white, fontFamily: 'Teko'),
          ),
          Text(
            'SP: ${stats.skillPoints}',
            style: const TextStyle(color: AppColors.neonPurple),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: stats.attributes.entries.map((entry) {
            return ListTile(
              title: Text(
                entry.key,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${entry.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('DONE', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
