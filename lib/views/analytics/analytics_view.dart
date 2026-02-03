import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/app_theme.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmall = constraints.maxWidth < 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Live Analytics',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Track growth, engagement, and campus trends in real-time.',
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
              const SizedBox(height: 40),
              Flex(
                direction: isSmall ? Axis.vertical : Axis.horizontal,
                children: [
                  // Activity Chart
                  Flexible(
                    flex: isSmall ? 0 : 2,
                    child: Container(
                      height: 400,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Network Activity (24h)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Expanded(child: _buildLineChart()),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: isSmall ? 0 : 24, height: isSmall ? 24 : 0),
                  // Campus Distribution
                  Flexible(
                    flex: isSmall ? 0 : 1,
                    child: Container(
                      height: 400,
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Popular Campuses',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Expanded(child: _buildPieChart()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3),
              FlSpot(2.6, 2),
              FlSpot(4.9, 5),
              FlSpot(6.8, 3.1),
              FlSpot(8, 4),
              FlSpot(9.5, 3),
              FlSpot(11, 7),
            ],
            isCurved: true,
            color: AppTheme.primaryColor,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: Colors.blueAccent,
            value: 35,
            title: 'Harvard',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
          ),
          PieChartSectionData(
            color: AppTheme.primaryColor,
            value: 25,
            title: 'NYU',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 10, color: Colors.black),
          ),
          PieChartSectionData(
            color: Colors.redAccent,
            value: 20,
            title: 'TAMU',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
          ),
          PieChartSectionData(
            color: Colors.purpleAccent,
            value: 20,
            title: 'OSU',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
