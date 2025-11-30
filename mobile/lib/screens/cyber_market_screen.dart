import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../repositories/economy_repository.dart';
import '../repositories/customization_repository.dart';
import 'pack_opening_screen.dart';

class CyberMarketScreen extends StatelessWidget {
  const CyberMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final economyRepo = EconomyRepository();
    final customizationRepo = CustomizationRepository();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          title: const Text('CYBER MARKET'),
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            indicatorColor: AppColors.neonBlue,
            labelColor: AppColors.neonBlue,
            unselectedLabelColor: AppColors.textGrey,
            labelStyle: TextStyle(
              fontFamily: 'Teko',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: 'THE BLACK MARKET'),
              Tab(text: 'THE ARMORY'),
            ],
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: AnimatedBuilder(
                  animation: economyRepo,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.neonBlue.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bolt,
                            color: AppColors.neonBlue,
                            size: 16,
                          ),
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _ShopTab(economyRepo: economyRepo),
            _LockerRoomTab(
              customizationRepo: customizationRepo,
              economyRepo: economyRepo,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopTab extends StatelessWidget {
  final EconomyRepository economyRepo;

  const _ShopTab({required this.economyRepo});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(context, 'BOOSTER PACKS'),
        _buildShopItem(
          context,
          title: 'CYBER PACK',
          description: 'Contains 5 AI Trading Cards. Shake to open!',
          cost: 500,
          icon: Icons.flash_on,
          color: AppColors.neonPurple,
          onBuy: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PackOpeningScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 24),
        _buildSectionHeader(context, 'PREMIUM ACCESS'),
        AnimatedBuilder(
          animation: economyRepo,
          builder: (context, child) {
            if (economyRepo.isPremium) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(8),
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
                        fontFamily: 'Teko',
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
                if (economyRepo.spendCredits(1000)) {
                  economyRepo.setPremium(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Welcome to PRO!')),
                  );
                } else {
                  _showInsufficientCredits(context);
                }
              },
            );
          },
        ),
      ],
    );
  }

  void _showInsufficientCredits(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Insufficient Credits!')));
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: AppColors.textGrey,
          letterSpacing: 1.5,
          fontFamily: 'Teko',
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
                    fontFamily: 'Teko',
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

class _LockerRoomTab extends StatelessWidget {
  final CustomizationRepository customizationRepo;
  final EconomyRepository economyRepo;

  const _LockerRoomTab({
    required this.customizationRepo,
    required this.economyRepo,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: customizationRepo,
      builder: (context, child) {
        return Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      indicatorColor: AppColors.neonPurple,
                      labelColor: AppColors.textWhite,
                      unselectedLabelColor: AppColors.textGrey,
                      tabs: [
                        Tab(text: 'THEMES'),
                        Tab(text: 'KITS'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildGrid(context, CosmeticType.theme),
                          _buildGrid(context, CosmeticType.kit),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context, CosmeticType type) {
    final items = customizationRepo.items.where((i) => i.type == type).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildItemCard(context, items[index]);
      },
    );
  }

  Widget _buildItemCard(BuildContext context, CosmeticItem item) {
    final isOwned = customizationRepo.isOwned(item.id);
    final isEquipped =
        (item.type == CosmeticType.theme &&
            customizationRepo.equippedThemeId == item.id) ||
        (item.type == CosmeticType.kit &&
            customizationRepo.equippedKitId == item.id);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEquipped ? AppColors.neonBlue : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Preview
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.type == CosmeticType.theme
                  ? (item.value as Color).withOpacity(0.2)
                  : AppColors.surfaceLight,
              border: item.type == CosmeticType.theme
                  ? Border.all(color: item.value as Color, width: 2)
                  : null,
            ),
            child: item.type == CosmeticType.kit
                ? Icon(
                    item.value as IconData,
                    size: 40,
                    color: AppColors.textWhite,
                  )
                : null,
          ),
          const SizedBox(height: 16),

          // Info
          Text(
            item.name,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.bold,
              fontFamily: 'Teko',
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ),
          const Spacer(),

          // Action Button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isEquipped
                    ? null
                    : () async {
                        if (isOwned) {
                          customizationRepo.equipItem(item.id);
                        } else {
                          final success = await customizationRepo.buyItem(
                            item.id,
                          );
                          if (!success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Not enough credits!'),
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOwned
                      ? (isEquipped
                            ? AppColors.surfaceLight
                            : AppColors.neonBlue)
                      : AppColors.neonGreen,
                  foregroundColor: isOwned
                      ? AppColors.textWhite
                      : AppColors.black,
                ),
                child: Text(
                  isEquipped
                      ? 'EQUIPPED'
                      : (isOwned ? 'EQUIP' : '${item.cost} CR'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
