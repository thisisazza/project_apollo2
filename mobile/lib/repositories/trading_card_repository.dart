import 'dart:math';
import '../models/trading_card.dart';
import '../models/user_stats.dart';

class TradingCardRepository {
  static final List<TradingCard> _myCards = [];

  static List<TradingCard> getCards() {
    return List.unmodifiable(_myCards);
  }

  static TradingCard generateCard(UserStats userStats) {
    final random = Random();

    // Determine Rarity based on level (higher level = better chance)
    double roll = random.nextDouble(); // 0.0 to 1.0
    CardRarity rarity = CardRarity.common;

    // Simple probability logic
    if (roll > 0.95) {
      rarity = CardRarity.legendary;
    } else if (roll > 0.80) {
      rarity = CardRarity.epic;
    } else if (roll > 0.50) {
      rarity = CardRarity.rare;
    }

    // Generate Stats based on rarity
    int baseStat = 50 + (userStats.level * 2);
    int bonus = 0;
    switch (rarity) {
      case CardRarity.common:
        bonus = 0;
        break;
      case CardRarity.rare:
        bonus = 10;
        break;
      case CardRarity.epic:
        bonus = 20;
        break;
      case CardRarity.legendary:
        bonus = 35;
        break;
    }

    final stats = {
      'SPEED': min(99, baseStat + bonus + random.nextInt(10)),
      'AGILITY': min(99, baseStat + bonus + random.nextInt(10)),
      'POWER': min(99, baseStat + bonus + random.nextInt(10)),
      'IQ': min(99, baseStat + bonus + random.nextInt(10)),
    };

    // Titles
    final titles = [
      'Cyber Rookie',
      'Neon Sprinter',
      'Data Defender',
      'Quantum Striker',
      'Void Walker',
      'Glitch Hunter',
      'Neural Master',
      'Titanium Guard',
    ];
    String title = titles[random.nextInt(titles.length)];

    final newCard = TradingCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      rarity: rarity,
      imageUrl: 'assets/cards/placeholder.png', // Placeholder
      stats: stats,
      dateEarned: DateTime.now(),
    );

    _myCards.add(newCard);
    return newCard;
  }
}
