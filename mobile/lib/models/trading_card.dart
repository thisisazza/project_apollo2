import 'package:flutter/material.dart';

enum CardRarity { common, rare, epic, legendary, cyber }

class TradingCard {
  final String id;
  final String name;
  final CardRarity rarity;
  final String imageUrl;
  final Map<String, int> stats; // Pace, Shooting, etc.
  final String description;

  TradingCard({
    required this.id,
    required this.name,
    required this.rarity,
    required this.imageUrl,
    required this.stats,
    required this.description,
  });

  Color get color {
    switch (rarity) {
      case CardRarity.common:
        return Colors.grey;
      case CardRarity.rare:
        return Colors.cyanAccent;
      case CardRarity.epic:
        return Colors.purpleAccent;
      case CardRarity.legendary:
        return Colors.orangeAccent;
      case CardRarity.cyber:
        return Colors.tealAccent; // Rainbow logic handled in UI
    }
  }

  // Factory for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rarity': rarity.toString(),
      'imageUrl': imageUrl,
      'stats': stats,
      'description': description,
    };
  }

  factory TradingCard.fromJson(Map<String, dynamic> json) {
    return TradingCard(
      id: json['id'],
      name: json['name'],
      rarity: CardRarity.values.firstWhere(
        (e) => e.toString() == json['rarity'],
      ),
      imageUrl: json['imageUrl'],
      stats: Map<String, int>.from(json['stats']),
      description: json['description'],
    );
  }
}
