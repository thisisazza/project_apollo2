import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class PhaseIndicator extends StatelessWidget {
  final String instruction;
  final String phaseName;

  const PhaseIndicator({
    super.key,
    required this.instruction,
    required this.phaseName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.8),
        border: Border.all(color: AppColors.neonGreen.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGreen.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            phaseName.toUpperCase(),
            style: const TextStyle(
              color: AppColors.neonGreen,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            instruction,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Teko',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate(key: ValueKey(instruction)).fadeIn().scale();
  }
}
