import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CyberOverlay extends StatelessWidget {
  const CyberOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // Corner Brackets
          Positioned(
            top: 20,
            left: 20,
            child: _CornerBracket(isTop: true, isLeft: true),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: _CornerBracket(isTop: true, isLeft: false),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: _CornerBracket(isTop: false, isLeft: true),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _CornerBracket(isTop: false, isLeft: false),
          ),

          // Grid Lines (Subtle)
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),
        ],
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _CornerBracket({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppColors.neonBlue, width: 3)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppColors.neonBlue, width: 3)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppColors.neonBlue, width: 3)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppColors.neonBlue, width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonBlue.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += size.width / 4) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += size.height / 6) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
