import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../repositories/economy_repository.dart';
import '../repositories/trading_card_repository.dart';
import '../repositories/user_stats_repository.dart';
import 'trading_card_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final economy = EconomyRepository();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('CYBER SHOP'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: AnimatedBuilder(
                animation: economy,
                builder: (context, child) {
                  return Text(
                    '${economy.credits} CR',
                    style: const TextStyle(
                      color: AppColors.electricBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'BOOSTER PACKS'),
          _buildShopItem(
            context,
            title: 'Standard Data Pack',
            description: 'Contains 1 random AI Trading Card.',
            cost: 100,
            icon: Icons.sd_storage,
            color: AppColors.neonGreen,
            onBuy: () {
              if (economy.spendCredits(100)) {
                // Generate card
                final newCard = TradingCardRepository.generateCard(
                  UserStatsRepository().stats,
                );
                // Show it
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TradingCardScreen(card: newCard),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Insufficient Credits!')),
                );
              }
            },
          ),
          _buildShopItem(
            context,
            title: 'Elite Neural Pack',
            description: 'Higher chance for Rare/Epic cards.',
            cost: 250,
            icon: Icons.memory,
            color: AppColors.neonPink,
            onBuy: () {
              if (economy.spendCredits(250)) {
                // Generate card (same logic for MVP, but imagine better odds)
                final newCard = TradingCardRepository.generateCard(
                  UserStatsRepository().stats,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TradingCardScreen(card: newCard),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Insufficient Credits!')),
                );
              }
            },
          ),

          const SizedBox(height: 24),
          _buildSectionHeader(context, 'PREMIUM ACCESS'),
          AnimatedBuilder(
            animation: economy,
            builder: (context, child) {
              if (economy.isPremium) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: Colors.amber),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, color: Colors.amber),
                      SizedBox(width: 12),
                      Text(
                        'PREMIUM ACTIVE',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return _buildShopItem(
                context,
                title: 'Project Apollo PRO',
                description: 'Unlock all themes & advanced analytics.',
                cost: 1000,
                icon: Icons.diamond,
                color: Colors.amber,
                onBuy: () {
                  if (economy.spendCredits(1000)) {
                    economy.setPremium(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Welcome to PRO!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Insufficient Credits!')),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: AppColors.textGrey,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildShopItem(
    BuildContext context, {
    required String title,
    required String description,
    required int cost,
    required IconData icon,
    required Color color,
    required VoidCallback onBuy,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onBuy,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceLight,
              foregroundColor: color,
              side: BorderSide(color: color),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text('$cost CR'),
          ),
        ],
      ),
    );
  }
}
