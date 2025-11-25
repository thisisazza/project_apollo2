import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'models/club.dart';
import 'screens/workout_logger_screen.dart';
import 'screens/drill_view_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/club_selection_screen.dart';

import 'repositories/customization_repository.dart';

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
        // If a club is selected, it overrides the cosmetic theme for primary color
        // But for this phase, let's let the cosmetic theme take precedence or mix them
        // Let's use the Cosmetic Theme as the "Accent" and Club as "Primary" if set,
        // or just use Cosmetic Theme if no club.

        final themeColor = _customizationRepo.currentThemeColor;

        return MaterialApp(
          title: 'Project Apollo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme.copyWith(
            colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
              primary: themeColor,
              secondary: themeColor,
            ),
            // We might need to update other theme properties if AppTheme relies on static colors
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const DashboardScreen(),
            '/workout_logger': (context) => const WorkoutLoggerScreen(),
            '/drill_view': (context) => const DrillViewScreen(),
            '/club_selection': (context) => const ClubSelectionScreen(),
          },
        );
      },
    );
  }
}
