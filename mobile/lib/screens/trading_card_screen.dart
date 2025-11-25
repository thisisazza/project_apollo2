import 'package:flutter/material.dart';
import 'dart:math';
import '../models/trading_card.dart';
import '../theme/app_colors.dart';

class TradingCardScreen extends StatefulWidget {
  final TradingCard card;

  const TradingCardScreen({super.key, required this.card});

  @override
  State<TradingCardScreen> createState() => _TradingCardScreenState();
}

class _TradingCardScreenState extends State<TradingCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getRarityColor(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.common:
        return AppColors.textGrey;
      case CardRarity.rare:
        return AppColors.electricBlue;
      case CardRarity.epic:
        return AppColors.neonPink;
      case CardRarity.legendary:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rarityColor = _getRarityColor(widget.card.rarity);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'NEW ASSET ACQUIRED',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Simulate a subtle holographic tilt/shimmer
            final shimmerValue = _controller.value;

            return Container(
              width: 300,
              height: 500,
              decoration: BoxDecoration(
                color: AppColors.surfaceBlack,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: rarityColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: rarityColor.withOpacity(0.5 * shimmerValue),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surfaceBlack,
                    AppColors.surfaceLight,
                    AppColors.surfaceBlack,
                  ],
                  stops: [
                    0.0,
                    shimmerValue, // Moving gradient highlight
                    1.0,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.nfc, color: rarityColor),
                        Text(
                          widget.card.rarity.name.toUpperCase(),
                          style: TextStyle(
                            color: rarityColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Image Placeholder
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: rarityColor.withOpacity(0.5)),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person_4,
                          size: 80,
                          color: rarityColor,
                        ),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    widget.card.title.toUpperCase(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Stats Grid
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 16,
                        children: widget.card.stats.entries.map((e) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.textGrey.withOpacity(0.3),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.key,
                                  style: const TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  e.value.toString(),
                                  style: TextStyle(
                                    color: rarityColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
