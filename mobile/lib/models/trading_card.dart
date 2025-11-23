enum CardRarity { common, rare, epic, legendary }

class TradingCard {
  final String id;
  final String title;
  final CardRarity rarity;
  final String imageUrl;
  final Map<String, int> stats; // e.g., {'Speed': 85, 'Power': 90}
  final DateTime dateEarned;

  const TradingCard({
    required this.id,
    required this.title,
    required this.rarity,
    required this.imageUrl,
    required this.stats,
    required this.dateEarned,
  });
}
