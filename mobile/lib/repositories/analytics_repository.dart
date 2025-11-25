import 'package:flutter/material.dart';

class PlayerStat {
  final String name;
  final double value; // 0-100
  final Color color;

  PlayerStat(this.name, this.value, this.color);
}

class XpDataPoint {
  final int dayIndex; // 0 = Mon, 6 = Sun
  final double xp;

  XpDataPoint(this.dayIndex, this.xp);
}

class AnalyticsRepository {
  // Mock Data for "Player DNA"
  List<PlayerStat> getPlayerDNA() {
    return [
      PlayerStat('SPEED', 75, Colors.cyan),
      PlayerStat('POWER', 60, Colors.redAccent),
      PlayerStat('TECHNIQUE', 85, Colors.purpleAccent),
      PlayerStat('IQ', 90, Colors.greenAccent),
    ];
  }

  // Mock Data for XP History (Last 7 Days)
  List<XpDataPoint> getXpHistory() {
    return [
      XpDataPoint(0, 500),
      XpDataPoint(1, 1200),
      XpDataPoint(2, 800),
      XpDataPoint(3, 1500),
      XpDataPoint(4, 2000), // Peak performance
      XpDataPoint(5, 1000),
      XpDataPoint(6, 1800),
    ];
  }

  // AI Insights
  List<String> getAiInsights() {
    return [
      "🚀 Your **Speed** has increased by 5% this week.",
      "💡 **Tactical IQ** is your strongest asset. Keep studying the game.",
      "⚠️ **Power** is lagging behind. Recommended: Explosive Squats.",
    ];
  }
}
