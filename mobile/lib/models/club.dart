import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class Club {
  final String id;
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final String assetPath; // For local assets (legacy)
  final String? logoUrl; // For remote images
  final int? externalId; // For API-Football ID

  const Club({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.assetPath,
    this.logoUrl,
    this.externalId,
  });
}
