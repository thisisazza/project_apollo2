import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../repositories/user_stats_repository.dart';
import '../theme/app_colors.dart';

class PerformanceLabScreen extends StatefulWidget {
  const PerformanceLabScreen({super.key});

  @override
  State<PerformanceLabScreen> createState() => _PerformanceLabScreenState();
}

class _PerformanceLabScreenState extends State<PerformanceLabScreen> {
  final _statsRepo = UserStatsRepository();
  bool _isLoading = false;
  String _aiInsight = "ANALYZING BIOMETRICS...";

  @override
  void initState() {
    super.initState();
    _generateInsight();
  }

  Future<void> _generateInsight() async {
    // Mock AI Analysis
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));

    final skills = _statsRepo.getSkillBreakdown();
    // Find lowest skill
    var lowestSkill = 'Passing';
    var lowestValue = 100;
    skills.forEach((key, value) {
      if (value < lowestValue) {
        lowestValue = value;
        lowestSkill = key;
      }
    });

    setState(() {
      _isLoading = false;
      _aiInsight =
          "COACH REPORT:\n\nYour ${lowestSkill.toUpperCase()} metrics are lagging behind projected growth curves. Recommend increasing drill frequency by 20% in this sector to maintain balanced development.";
    });
  }

  @override
  Widget build(BuildContext context) {
    final skillBreakdown = _statsRepo.getSkillBreakdown();
    final weeklyXp = _statsRepo.getLast7DaysXp();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text(
          'PERFORMANCE LAB',
          style: TextStyle(fontFamily: 'Teko', fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. AI Insight Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.neonBlue),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "AI INSIGHTS",
                    style: TextStyle(
                      color: AppColors.neonBlue,
                      fontFamily: 'Teko',
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _aiInsight,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Courier', // Monospace for terminal feel
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. The Hexagon (Radar Chart)
            const Text(
              "SKILL MATRIX",
              style: TextStyle(
                color: AppColors.neonGreen,
                fontFamily: 'Teko',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: RadarChart(
                RadarChartData(
                  radarTouchData: RadarTouchData(enabled: false),
                  dataSets: [
                    RadarDataSet(
                      fillColor: AppColors.neonGreen.withOpacity(0.2),
                      borderColor: AppColors.neonGreen,
                      entryRadius: 3,
                      dataEntries: [
                        RadarEntry(
                          value: skillBreakdown['Passing']?.toDouble() ?? 0,
                        ),
                        RadarEntry(
                          value: skillBreakdown['Shooting']?.toDouble() ?? 0,
                        ),
                        RadarEntry(
                          value: skillBreakdown['Dribbling']?.toDouble() ?? 0,
                        ),
                        RadarEntry(
                          value: skillBreakdown['Physical']?.toDouble() ?? 0,
                        ),
                        RadarEntry(
                          value: skillBreakdown['Mental']?.toDouble() ?? 0,
                        ),
                      ],
                      borderWidth: 2,
                    ),
                  ],
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData: const BorderSide(color: Colors.white24),
                  titlePositionPercentageOffset: 0.2,
                  titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  getTitle: (index, angle) {
                    switch (index) {
                      case 0:
                        return const RadarChartTitle(text: 'PASSING');
                      case 1:
                        return const RadarChartTitle(text: 'SHOOTING');
                      case 2:
                        return const RadarChartTitle(text: 'DRIBBLING');
                      case 3:
                        return const RadarChartTitle(text: 'PHYSICAL');
                      case 4:
                        return const RadarChartTitle(text: 'MENTAL');
                      default:
                        return const RadarChartTitle(text: '');
                    }
                  },
                  tickCount: 1,
                  ticksTextStyle: const TextStyle(color: Colors.transparent),
                  tickBorderData: const BorderSide(color: Colors.transparent),
                  gridBorderData: const BorderSide(
                    color: Colors.white12,
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. The Pulse (Line Chart)
            const Text(
              "ACTIVITY PULSE (7 DAYS)",
              style: TextStyle(
                color: AppColors.neonPink,
                fontFamily: 'Teko',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: (weeklyXp.reduce((a, b) => a > b ? a : b) + 100)
                      .toDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weeklyXp.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: AppColors.neonPink,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.neonPink.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
