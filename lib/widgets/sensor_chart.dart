// ================================================================
// Nama Sistem  : Aqualyze - Smart Water Monitoring System
// Author       : Refan Rustoni Putra
// NIM          : 10824005
// Versi        : 1.3.0
// Tahun        : 2026
// Ownership    : Capstone Project - Universitas
// Deskripsi    : Sistem monitoring kualitas air berbasis IoT
//                yang menampilkan data suhu, pH, dan kekeruhan
//                secara realtime melalui aplikasi mobile dan web.
// ================================================================

// ======================= Library ================================
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatelessWidget {
  final List<dynamic> history;
  final String field;
  final Color color;
  final double minY;
  final double maxY;
  final double interval;

  const SensorChart({
    super.key,
    required this.history,
    required this.field,
    required this.color,
    required this.minY,
    required this.maxY,
    required this.interval,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: LineChart(LineChartData(
        minX: 0,
        maxX: history.length.toDouble() - 1,
        minY: minY,
        maxY: maxY,
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              interval: interval,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.15),
            ),
            spots: List.generate(
              history.length,
              (index) => FlSpot(
                index.toDouble(),
                (history[index][field] as num).toDouble(),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
