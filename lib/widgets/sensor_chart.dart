import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatelessWidget {
  final List<dynamic> history;

  const SensorChart({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: List.generate(history.length, (index) {
                return FlSpot(
                  index.toDouble(),
                  (history[index]["suhu"] as num).toDouble(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}