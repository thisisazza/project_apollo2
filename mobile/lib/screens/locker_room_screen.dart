import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../repositories/customization_repository.dart';
import '../repositories/economy_repository.dart';

class LockerRoomScreen extends StatelessWidget {
  const LockerRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customizationRepo = CustomizationRepository();
    final economyRepo = EconomyRepository();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('THE LOCKER ROOM'),
        backgroundColor: Colors.transparent,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: AnimatedBuilder(
                animation: economyRepo,
                builder: (context, _) => Text(
                  '${economyRepo.credits} CR',
                  style: const TextStyle(
                    color: AppColors.neonBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: customizationRepo,
        builder: (context, child) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: AppColors.neonBlue,
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
                      _buildGrid(
                        context,
                        customizationRepo,
                        CosmeticType.theme,
                      ),
                      _buildGrid(context, customizationRepo, CosmeticType.kit),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    CustomizationRepository repo,
    CosmeticType type,
  ) {
    final items = repo.items.where((i) => i.type == type).toList();

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
        return _buildItemCard(context, items[index], repo);
      },
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    CosmeticItem item,
    CustomizationRepository repo,
  ) {
    final isOwned = repo.isOwned(item.id);
    final isEquipped =
        (item.type == CosmeticType.theme && repo.equippedThemeId == item.id) ||
        (item.type == CosmeticType.kit && repo.equippedKitId == item.id);

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
                          repo.equipItem(item.id);
                        } else {
                          final success = await repo.buyItem(item.id);
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
