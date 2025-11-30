import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/club.dart';
import 'repositories/customization_repository.dart';
import 'screens/dashboard_screen.dart';
import 'screens/workout_logger_screen.dart';
import 'screens/drill_selection_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cyber_market_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Static method to change club from anywhere
  static void setClub(BuildContext context, Club club) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.setClub(club);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Club? _selectedClub;
  final _customizationRepo = CustomizationRepository();

  void setClub(Club club) {
    setState(() {
      _selectedClub = club;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _customizationRepo,
      builder: (context, child) {
        final themeColor = _customizationRepo.currentThemeColor;

        return MaterialApp(
          title: 'Project Apollo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme.copyWith(
            colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
              primary: themeColor,
              secondary: themeColor,
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const DashboardScreen(),
            '/workout_logger': (context) => const WorkoutLoggerScreen(),
            '/drill_selection': (context) => const DrillSelectionScreen(),
            '/camera': (context) => const CameraScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/cyber_market': (context) => const CyberMarketScreen(),
          },
        );
      },
    );
  }
}
