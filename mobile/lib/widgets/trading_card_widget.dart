import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import '../models/trading_card.dart';
import '../theme/app_colors.dart';

class TradingCardWidget extends StatefulWidget {
  final TradingCard card;
  final bool isLocked;

  const TradingCardWidget({
    super.key,
    required this.card,
    this.isLocked = false,
  });

  @override
  State<TradingCardWidget> createState() => _TradingCardWidgetState();
}

class _TradingCardWidgetState extends State<TradingCardWidget> {
  double _x = 0;
  double _y = 0;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;

  @override
  void initState() {
    super.initState();
    _initGyro();
  }

  void _initGyro() {
    _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (mounted) {
        setState(() {
          // Accumulate rotation for parallax effect
          _x += event.y * 0.5; // Tilt up/down
          _y += event.x * 0.5; // Tilt left/right

          // Clamp values
          _x = _x.clamp(-0.2, 0.2);
          _y = _y.clamp(-0.2, 0.2);
        });
      }
    });
  }

  @override
  void dispose() {
    _gyroSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perspective
        ..rotateX(_x)
        ..rotateY(_y),
      alignment: Alignment.center,
      child: Container(
        width: 300,
        height: 450,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.card.color, width: 4),
          boxShadow: [
            BoxShadow(
              color: widget.card.color.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // 1. Background (Gradient)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.black, AppColors.surface, Colors.black],
                  ),
                ),
              ),

              // 2. Image (Placeholder)
              Center(
                child: Icon(
                  Icons.person,
                  size: 150,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),

              // 3. Stats Overlay
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.card.name.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Teko',
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStat('PAC', widget.card.stats['PACE']!),
                        _buildStat('SHO', widget.card.stats['SHOOT']!),
                        _buildStat('PAS', widget.card.stats['PASS']!),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStat('DRI', widget.card.stats['DRIBBLE']!),
                        _buildStat('DEF', widget.card.stats['DEFENSE']!),
                        _buildStat('PHY', widget.card.stats['PHYSICAL']!),
                      ],
                    ),
                  ],
                ),
              ),

              // 4. Holo Shader (Simple Gradient Overlay that moves)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-_y * 5, -_x * 5),
                      end: Alignment(_y * 5, _x * 5),
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // 5. Rarity Badge
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.card.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.card.rarity.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: widget.card.color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Teko',
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}
