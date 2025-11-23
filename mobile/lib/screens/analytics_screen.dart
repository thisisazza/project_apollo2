import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import '../repositories/analytics_repository.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AnalyticsRepository();
    final dna = repo.getPlayerDNA();
    final xpHistory = repo.getXpHistory();
    final insights = repo.getAiInsights();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('PERFORMANCE DNA'),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        titleTextStyle: const TextStyle(
          color: AppColors.textWhite,
          fontFamily: 'Teko',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Radar Chart (Player DNA)
            const Text(
              'ATHLETIC PROFILE',
              style: TextStyle(
                color: AppColors.textWhite,
                fontFamily: 'Teko',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      fillColor: AppColors.neonBlue.withOpacity(0.2),
                      borderColor: AppColors.neonBlue,
                      entryRadius: 3,
                      dataEntries: dna
                          .map((e) => RadarEntry(value: e.value))
                          .toList(),
                      borderWidth: 2,
                    ),
                  ],
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData: const BorderSide(color: AppColors.textGrey),
                  titlePositionPercentageOffset: 0.2,
                  titleTextStyle: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 12,
                  ),
                  getTitle: (index, angle) {
                    if (index < dna.length) {
                      return RadarChartTitle(text: dna[index].name);
                    }
                    return const RadarChartTitle(text: '');
                  },
                  tickCount: 1,
                  ticksTextStyle: const TextStyle(color: Colors.transparent),
                  gridBorderData: const BorderSide(
                    color: AppColors.textGrey,
                    width: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 2. Line Chart (XP History)
            const Text(
              'XP PROGRESSION',
              style: TextStyle(
                color: AppColors.textWhite,
                fontFamily: 'Teko',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          if (value.toInt() >= 0 &&
                              value.toInt() < days.length) {
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(color: AppColors.textGrey),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: xpHistory
                          .map((e) => FlSpot(e.dayIndex.toDouble(), e.xp))
                          .toList(),
                      isCurved: true,
                      color: AppColors.neonGreen,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.neonGreen.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 3. AI Insights
            const Text(
              'AI COACH INSIGHTS',
              style: TextStyle(
                color: AppColors.textWhite,
                fontFamily: 'Teko',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...insights.map(
              (insight) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(color: AppColors.neonPurple, width: 4),
                  ),
                ),
                child: Text(
                  insight,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
