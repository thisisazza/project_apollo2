import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import '../models/trading_card.dart';
import '../services/pack_service.dart';
import '../widgets/trading_card_widget.dart';
import '../theme/app_colors.dart';
import '../repositories/economy_repository.dart';
import '../managers/haptics_manager.dart';

class PackOpeningScreen extends StatefulWidget {
  const PackOpeningScreen({super.key});

  @override
  State<PackOpeningScreen> createState() => _PackOpeningScreenState();
}

class _PackOpeningScreenState extends State<PackOpeningScreen> {
  final _packService = PackService();
  final _economyRepo = EconomyRepository();

  List<TradingCard> _cards = [];
  bool _isOpening = false;
  bool _isRevealed = false;

  // Shake detection
  StreamSubscription? _accelerometerSubscription;
  static const double _shakeThreshold = 15.0;

  @override
  void initState() {
    super.initState();
    _initShakeDetection();
  }

  void _initShakeDetection() {
    _accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) {
      if (!_isOpening && !_isRevealed) {
        if (event.x.abs() > _shakeThreshold ||
            event.y.abs() > _shakeThreshold ||
            event.z.abs() > _shakeThreshold) {
          _openPack();
        }
      }
    });
  }

  void _openPack() async {
    if (_isOpening) return;

    // Deduct cost (Mock check)
    if (_economyRepo.credits < 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("INSUFFICIENT CREDITS (500 CR REQUIRED)")),
      );
      return;
    }
    _economyRepo.addCredits(-500);

    setState(() {
      _isOpening = true;
    });

    // Simulate network/generation delay
    await Future.delayed(const Duration(seconds: 2));

    final newCards = _packService.openPack();
    HapticManager().heavyImpact(); // Impact when pack opens

    if (mounted) {
      setState(() {
        _cards = newCards;
        _isOpening = false;
        _isRevealed = true;
      });
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(child: _isRevealed ? _buildRevealView() : _buildPackView()),
    );
  }

  Widget _buildPackView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _openPack,
          child:
              Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.neonPurple, AppColors.neonBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonPurple.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.flash_on,
                            size: 60,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "CYBER PACK",
                            style: TextStyle(
                              fontFamily: 'Teko',
                              fontSize: 32,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.05, 1.05),
                    duration: 1000.ms,
                  )
                  .shimmer(
                    duration: 2000.ms,
                    color: Colors.white.withOpacity(0.5),
                  ),
        ),
        const SizedBox(height: 40),
        if (_isOpening)
          const Text(
            "DECRYPTING ASSETS...",
            style: TextStyle(
              color: AppColors.neonBlue,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().listen(
            callback: (value) {},
          ) // Dummy listen to fix lint? No, animate is fine.
        else
          const Text(
            "SHAKE TO OPEN\n(OR TAP)",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontFamily: 'Teko',
              fontSize: 24,
            ),
          ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }

  Widget _buildRevealView() {
    return SizedBox(
      height: 500,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TradingCardWidget(card: _cards[index])
                .animate()
                .fadeIn(duration: 500.ms, delay: (index * 200).ms)
                .slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                )
                .shimmer(delay: (index * 200 + 500).ms, duration: 1000.ms),
          );
        },
      ),
    );
  }
}
