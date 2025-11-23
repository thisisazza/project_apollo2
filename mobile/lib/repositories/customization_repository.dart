import 'package:flutter/material.dart';
import 'economy_repository.dart';

enum CosmeticType { theme, kit }

class CosmeticItem {
  final String id;
  final String name;
  final CosmeticType type;
  final int cost;
  final dynamic value; // Color for theme, Asset path for kit
  final String description;

  const CosmeticItem({
    required this.id,
    required this.name,
    required this.type,
    required this.cost,
    required this.value,
    required this.description,
  });
}

class CustomizationRepository extends ChangeNotifier {
  static final CustomizationRepository _instance =
      CustomizationRepository._internal();
  factory CustomizationRepository() => _instance;
  CustomizationRepository._internal();

  // Available Items
  final List<CosmeticItem> items = [
    // Themes
    const CosmeticItem(
      id: 'theme_neon_blue',
      name: 'CYBER BLUE',
      type: CosmeticType.theme,
      cost: 0,
      value: Color(0xFF00F0FF),
      description: 'The classic Apollo look.',
    ),
    const CosmeticItem(
      id: 'theme_magma_red',
      name: 'MAGMA RED',
      type: CosmeticType.theme,
      cost: 500,
      value: Color(0xFFFF3333),
      description: 'Aggressive and fiery.',
    ),
    const CosmeticItem(
      id: 'theme_toxic_green',
      name: 'TOXIC GREEN',
      type: CosmeticType.theme,
      cost: 1000,
      value: Color(0xFF39FF14),
      description: 'Radioactive energy.',
    ),
    const CosmeticItem(
      id: 'theme_void_purple',
      name: 'VOID PURPLE',
      type: CosmeticType.theme,
      cost: 2000,
      value: Color(0xFFBD00FF),
      description: 'Deep space vibes.',
    ),

    // Kits (Avatars)
    const CosmeticItem(
      id: 'kit_default',
      name: 'ROOKIE KIT',
      type: CosmeticType.kit,
      cost: 0,
      value: Icons.person,
      description: 'Standard issue gear.',
    ),
    const CosmeticItem(
      id: 'kit_striker',
      name: 'STRIKER BOT',
      type: CosmeticType.kit,
      cost: 1500,
      value: Icons.sports_soccer,
      description: 'Optimized for goals.',
    ),
    const CosmeticItem(
      id: 'kit_ninja',
      name: 'SHADOW OPS',
      type: CosmeticType.kit,
      cost: 3000,
      value: Icons.security,
      description: 'Stealth training gear.',
    ),
  ];

  // User State
  final List<String> _ownedItemIds = ['theme_neon_blue', 'kit_default'];
  String _equippedThemeId = 'theme_neon_blue';
  String _equippedKitId = 'kit_default';

  List<String> get ownedItemIds => _ownedItemIds;
  String get equippedThemeId => _equippedThemeId;
  String get equippedKitId => _equippedKitId;

  Color get currentThemeColor {
    final item = items.firstWhere(
      (i) => i.id == _equippedThemeId,
      orElse: () => items.first,
    );
    return item.value as Color;
  }

  IconData get currentKitIcon {
    final item = items.firstWhere(
      (i) => i.id == _equippedKitId,
      orElse: () => items.firstWhere((i) => i.type == CosmeticType.kit),
    );
    return item.value as IconData;
  }

  bool isOwned(String itemId) => _ownedItemIds.contains(itemId);

  Future<bool> buyItem(String itemId) async {
    if (isOwned(itemId)) return true;

    final item = items.firstWhere((i) => i.id == itemId);
    final economy = EconomyRepository();

    if (economy.credits >= item.cost) {
      economy.spendCredits(item.cost);
      _ownedItemIds.add(itemId);
      notifyListeners();
      return true;
    }
    return false;
  }

  void equipItem(String itemId) {
    if (!isOwned(itemId)) return;

    final item = items.firstWhere((i) => i.id == itemId);
    if (item.type == CosmeticType.theme) {
      _equippedThemeId = itemId;
    } else {
      _equippedKitId = itemId;
    }
    notifyListeners();
  }
}
