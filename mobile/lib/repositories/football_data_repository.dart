import 'dart:async';
import 'package:flutter/material.dart';
import '../models/club.dart';

class FootballDataRepository {
  // Singleton
  static final FootballDataRepository _instance =
      FootballDataRepository._internal();
  factory FootballDataRepository() => _instance;
  FootballDataRepository._internal();

  // Mock Data (Fallback when no API Key)
  // Using Wikipedia/Public domain logos for demo purposes
  final List<Club> _mockClubs = [
    const Club(
      id: 'liverpool',
      name: 'Liverpool FC',
      primaryColor: Color(0xFFC8102E), // Liverpool Red
      secondaryColor: Color(0xFFF6EB61), // Gold
      assetPath: '',
      externalId: 40,
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/0/0c/Liverpool_FC.svg/1200px-Liverpool_FC.svg.png',
    ),
    const Club(
      id: 'real_madrid',
      name: 'Real Madrid',
      primaryColor: Colors.white,
      secondaryColor: Color(0xFFFEBE10), // Gold
      assetPath: '',
      externalId: 541,
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/5/56/Real_Madrid_CF.svg/1200px-Real_Madrid_CF.svg.png',
    ),
    const Club(
      id: 'man_city',
      name: 'Manchester City',
      primaryColor: Color(0xFF6CABDD), // Sky Blue
      secondaryColor: Colors.white,
      assetPath: '',
      externalId: 50,
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/e/eb/Manchester_City_FC_badge.svg/1200px-Manchester_City_FC_badge.svg.png',
    ),
    const Club(
      id: 'barcelona',
      name: 'FC Barcelona',
      primaryColor: Color(0xFF004D98), // Blau
      secondaryColor: Color(0xFFA50044), // Grana
      assetPath: '',
      externalId: 529,
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/4/47/FC_Barcelona_%28crest%29.svg/1200px-FC_Barcelona_%28crest%29.svg.png',
    ),
    const Club(
      id: 'psg',
      name: 'Paris Saint-Germain',
      primaryColor: Color(0xFF004170), // Navy
      secondaryColor: Color(0xFFDA291C), // Red
      assetPath: '',
      externalId: 85,
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/a/a7/Paris_Saint-Germain_F.C..svg/1200px-Paris_Saint-Germain_F.C..svg.png',
    ),
  ];

  Future<List<Club>> searchClubs(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (query.isEmpty) {
      return _mockClubs;
    }

    return _mockClubs
        .where((club) => club.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Club>> getPopularClubs() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockClubs;
  }
}
