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
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

// ══════════════════════════════════════════════════════════════════════════════
// MONITORING SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class MonitoringScreen extends StatefulWidget {
  final double temperature;
  final double ph;
  final int turbidity;
  final String lastSyncTime;
  final VoidCallback onRefresh;
  final String statusTemperature;
  final String statusPh;
  final String statusTurbidity;

  const MonitoringScreen({
    super.key,
    required this.temperature,
    required this.ph,
    required this.turbidity,
    required this.lastSyncTime,
    required this.onRefresh,
    required this.statusTemperature,
    required this.statusPh,
    required this.statusTurbidity,
  });

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    widget.onRefresh();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() => _isRefreshing = false);
  }

  Widget _buildStatusBadge(String status) {
    switch (status.toLowerCase()) {
      case "normal":
        return StatusBadge.normal();
      case "warning":
        return StatusBadge.warning();
      case "danger":
        return StatusBadge.danger();
      default:
        return StatusBadge.normal();
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "normal":
        return AquaColors.success;
      case "warning":
        return AquaColors.warning;
      case "danger":
        return AquaColors.danger;
      default:
        return AquaColors.primary;
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case "normal":
        return const Color(0xFFF0FDF4);
      case "warning":
        return const Color(0xFFFFF7ED);
      case "danger":
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFEFF6FF);
    }
  }

  String _temperatureDescription(String status) {
    switch (status.toLowerCase()) {
      case "normal":
        return "Suhu Ideal";

      case "warning":
        return "Suhu Perlu Perhatian";

      case "danger":
        return "Suhu Tidak Aman";

      default:
        return "Tidak diketahui";
    }
  }

  String _phDescription(String status) {
    switch (status.toLowerCase()) {
      case "normal":
        return "pH Stabil";

      case "warning":
        return "pH Perlu Perhatian";

      case "danger":
        return "pH Tidak Aman";

      default:
        return "Tidak diketahui";
    }
  }

  String _turbidityDescription(String status) {
    switch (status.toLowerCase()) {
      case "normal":
        return "Kualitas Air Baik";

      case "warning":
        return "Air Mulai Keruh";

      case "danger":
        return "Air Sangat Keruh";

      default:
        return "Tidak diketahui";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
      children: [
        const Text('Monitoring Kolam', style: AquaText.headline),
        const SizedBox(height: 4),
        Text('Telemetri waktu nyata untuk Kolam #04 - Unit Bio-Filter',
            style: AquaText.body),
        const SizedBox(height: 24),

        // Temperature
        _SensorCard(
          icon: Icons.thermostat_rounded,
          iconBg: _statusBackground(widget.statusTemperature),
          iconColor: _statusColor(widget.statusTemperature),
          title: 'Suhu Air',
          value: '${widget.temperature}',
          unit: '°C',
          rangeText: _temperatureDescription(widget.statusTemperature),
          rangeColor: _statusColor(widget.statusTemperature),
          badge: _buildStatusBadge(widget.statusTemperature),
          sparkColor: _statusColor(widget.statusTemperature),
          sparkPoints: const [
            Offset(0, 0.8),
            Offset(0.2, 0.4),
            Offset(0.4, 0.6),
            Offset(0.6, 0.85),
            Offset(0.8, 0.35),
            Offset(1.0, 0.55),
          ],
        ),
        const SizedBox(height: 16),

        // pH
        _SensorCard(
          icon: Icons.science_outlined,
          iconBg: _statusBackground(widget.statusPh),
          iconColor: _statusColor(widget.statusPh),
          title: 'Tingkat pH',
          value: '${widget.ph}',
          unit: 'pH',
          rangeText: _phDescription(widget.statusPh),
          rangeColor: _statusColor(widget.statusPh),
          badge: _buildStatusBadge(widget.statusPh),
          sparkColor: _statusColor(widget.statusPh),
          sparkPoints: const [
            Offset(0, 0.5),
            Offset(0.2, 0.6),
            Offset(0.4, 0.4),
            Offset(0.6, 0.5),
            Offset(0.8, 0.6),
            Offset(1.0, 0.5),
          ],
        ),
        const SizedBox(height: 16),

        // Turbidity
        _SensorCard(
          icon: Icons.waves_rounded,
          iconBg: _statusBackground(widget.statusTurbidity),
          iconColor: _statusColor(widget.statusTurbidity),
          title: 'Kekeruhan',
          value: '${widget.turbidity}',
          unit: 'NTU',
          rangeText: _turbidityDescription(widget.statusTurbidity),
          rangeColor: _statusColor(widget.statusTurbidity),
          badge: _buildStatusBadge(widget.statusTurbidity),
          sparkColor: _statusColor(widget.statusTurbidity),
          borderLeft: _statusColor(widget.statusTurbidity),
          sparkPoints: const [
            Offset(0, 0.1),
            Offset(0.15, 0.75),
            Offset(0.3, 0.25),
            Offset(0.45, 0.9),
            Offset(0.6, 0.4),
            Offset(0.75, 0.8),
            Offset(1.0, 0.5),
          ],
        ),
        const SizedBox(height: 16),

        // Live image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAbADUETPIeaLnoTWzX3rH8fD88DCLIDOuuSc7SVAm6bR8sDMkiYh__k2GzlfhQBl1SBHzFYWKlPu2Z3ZpbxIXYKcfM9XzU5v1gR89758SYvj81Sg5AxLVShCdvDdVpidVYU_t9YSlRattDR7cs8eN0nR5XyirVg9xJwUP5vCnCu-bxs11szAHnQhGR-8aaiePs-wvzNHS8TNAJ99VdrSHQqVUAPit7xOxE_KcWptvYWKc1wzD-wXZN_9xHeS_5O5443NUyJllcW64W',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey[200]),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AquaColors.primaryDark.withOpacity(0.7),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        color: AquaColors.primary,
                        child: const Text('SIARAN LANGSUNG',
                            style: TextStyle(
                              fontFamily: AquaText.font,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFDAE5FF),
                              letterSpacing: 1.0,
                            )),
                      ),
                      const SizedBox(height: 4),
                      const Text('Main Raceway Alpha',
                          style: TextStyle(
                            fontFamily: AquaText.font,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Refresh button
        ElevatedButton.icon(
          onPressed: _isRefreshing ? null : _handleRefresh,
          icon: _isRefreshing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5))
              : const Icon(Icons.refresh_rounded, size: 20),
          label: Text(_isRefreshing ? 'Menyegarkan Data...' : 'Segarkan Data'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.language_rounded,
                size: 16, color: AquaColors.primary),
            const SizedBox(width: 4),
            Text('Sinkronisasi Terakhir: ${widget.lastSyncTime}',
                style: AquaText.body.copyWith(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class _SensorCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String value;
  final String unit;
  final String rangeText;
  final Color rangeColor;
  final Widget badge;
  final Color sparkColor;
  final Color? borderLeft;
  final List<Offset> sparkPoints;

  const _SensorCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.unit,
    required this.rangeText,
    required this.rangeColor,
    required this.badge,
    required this.sparkColor,
    required this.sparkPoints,
    this.borderLeft,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderLeft: borderLeft,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title.toUpperCase(), style: AquaText.micro),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: value,
                              style: const TextStyle(
                                fontFamily: AquaText.font,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AquaColors.textMain,
                              )),
                          TextSpan(
                              text: ' $unit',
                              style: const TextStyle(
                                fontFamily: AquaText.font,
                                fontSize: 14,
                                color: AquaColors.textSubtle,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              badge,
            ],
          ),
          const SizedBox(height: 8),
          Text(rangeText,
              style: AquaText.body.copyWith(color: rangeColor, fontSize: 12)),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: CustomPaint(
              painter: SparklinePainter(color: sparkColor, points: sparkPoints),
              size: const Size(double.infinity, 56),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ANALYTICS SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  MetricType _metric = MetricType.temp;
  PeriodType _period = PeriodType.daily;

  // Dataset: metric → period → data
  final _data = const {
    MetricType.temp: {
      PeriodType.daily: _ChartData(
          'Tren Suhu', '24 jam terakhir', '24.5', '°C', '0.8%', true, [
        Offset(0, 0.88),
        Offset(0.25, 0.63),
        Offset(0.5, 0.38),
        Offset(0.75, 0.25),
        Offset(1.0, 0.3)
      ], [
        '00:00',
        '06:00',
        '12:00',
        '18:00',
        'Skrg'
      ]),
      PeriodType.weekly: _ChartData('Rerata Suhu Mingguan', '7 hari terakhir',
          '26.2', '°C', '1.4%', true, [
        Offset(0, 0.63),
        Offset(0.3, 0.88),
        Offset(0.6, 0.3),
        Offset(0.9, 0.7),
        Offset(1.0, 0.45)
      ], [
        'Sen',
        'Rab',
        'Jum',
        'Min',
        'Skrg'
      ]),
      PeriodType.monthly: _ChartData(
          'Log Suhu Bulanan', '30 hari terakhir', '25.8', '°C', '0.3%', false, [
        Offset(0, 0.38),
        Offset(0.25, 0.63),
        Offset(0.5, 0.45),
        Offset(0.75, 0.75),
        Offset(1.0, 0.63)
      ], [
        'W1',
        'W2',
        'W3',
        'W4',
        'Skrg'
      ]),
    },
    MetricType.ph: {
      PeriodType.daily:
          _ChartData('Tren pH', '24 jam terakhir', '7.18', 'pH', '0.2%', true, [
        Offset(0, 0.63),
        Offset(0.3, 0.5),
        Offset(0.6, 0.38),
        Offset(0.8, 0.55),
        Offset(1.0, 0.45)
      ], [
        '00:00',
        '06:00',
        '12:00',
        '18:00',
        'Skrg'
      ]),
      PeriodType.weekly: _ChartData(
          'Rerata pH Mingguan', '7 hari terakhir', '7.20', 'pH', '0.5%', true, [
        Offset(0, 0.5),
        Offset(0.25, 0.25),
        Offset(0.5, 0.65),
        Offset(0.75, 0.45),
        Offset(1.0, 0.38)
      ], [
        'Sen',
        'Rab',
        'Jum',
        'Min',
        'Skrg'
      ]),
      PeriodType.monthly: _ChartData(
          'Log pH Bulanan', '30 hari terakhir', '7.14', 'pH', '0.1%', false, [
        Offset(0, 0.25),
        Offset(0.25, 0.45),
        Offset(0.5, 0.3),
        Offset(0.75, 0.5),
        Offset(1.0, 0.4)
      ], [
        'W1',
        'W2',
        'W3',
        'W4',
        'Skrg'
      ]),
    },
    MetricType.turbidity: {
      PeriodType.daily: _ChartData(
          'Tren Kekeruhan', '24 jam terakhir', '12.0', 'NTU', '1.5%', false, [
        Offset(0, 0.38),
        Offset(0.25, 0.25),
        Offset(0.5, 0.75),
        Offset(0.75, 0.3),
        Offset(1.0, 0.55)
      ], [
        '00:00',
        '06:00',
        '12:00',
        '18:00',
        'Skrg'
      ]),
      PeriodType.weekly: _ChartData('Rerata Kekeruhan Mingguan',
          '7 hari terakhir', '13.5', 'NTU', '4.2%', true, [
        Offset(0, 0.88),
        Offset(0.25, 0.63),
        Offset(0.5, 0.75),
        Offset(0.75, 0.3),
        Offset(1.0, 0.2)
      ], [
        'Sen',
        'Rab',
        'Jum',
        'Min',
        'Skrg'
      ]),
      PeriodType.monthly: _ChartData('Log Kekeruhan Bulanan',
          '30 hari terakhir', '11.2', 'NTU', '8.5%', false, [
        Offset(0, 0.75),
        Offset(0.25, 0.3),
        Offset(0.5, 0.63),
        Offset(0.75, 0.45),
        Offset(1.0, 0.3)
      ], [
        'W1',
        'W2',
        'W3',
        'W4',
        'Skrg'
      ]),
    },
  };

  @override
  Widget build(BuildContext context) {
    final d = _data[_metric]![_period]!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
      children: [
        // Header + period toggle
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DATA HISTORIS',
                      style:
                          AquaText.label.copyWith(color: AquaColors.primary)),
                  const SizedBox(height: 4),
                  const Text('Analitik Dashboard', style: AquaText.headline),
                ],
              ),
            ),
            // Period selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  for (final p in PeriodType.values)
                    GestureDetector(
                      onTap: () => setState(() => _period = p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _period == p
                              ? AquaColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          {
                            PeriodType.daily: 'Harian',
                            PeriodType.weekly: 'Mingguan',
                            PeriodType.monthly: 'Bulanan'
                          }[p]!,
                          style: TextStyle(
                            fontFamily: AquaText.font,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color:
                                _period == p ? Colors.white : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Metric tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final m in MetricType.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _metric = m),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: _metric == m
                            ? const Color(0xFFEFF6FF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _metric == m
                              ? AquaColors.primary.withOpacity(0.3)
                              : Colors.grey[200]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            [
                              Icons.thermostat_rounded,
                              Icons.science_outlined,
                              Icons.waves_rounded
                            ][MetricType.values.indexOf(m)],
                            size: 16,
                            color: _metric == m
                                ? AquaColors.primary
                                : Colors.grey[500],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            [
                              'Suhu',
                              'pH',
                              'Kekeruhan'
                            ][MetricType.values.indexOf(m)],
                            style: TextStyle(
                              fontFamily: AquaText.font,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _metric == m
                                  ? AquaColors.primary
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Chart card
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.title, style: AquaText.title),
                      Text(d.sub, style: AquaText.body.copyWith(fontSize: 11)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: d.value,
                                style: const TextStyle(
                                    fontFamily: AquaText.font,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AquaColors.primary)),
                            TextSpan(
                                text: ' ${d.unit}',
                                style: const TextStyle(
                                    fontFamily: AquaText.font,
                                    fontSize: 12,
                                    color: AquaColors.textSubtle)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                              d.trendUp
                                  ? Icons.trending_up_rounded
                                  : Icons.trending_down_rounded,
                              size: 14,
                              color: d.trendUp
                                  ? AquaColors.success
                                  : AquaColors.primary),
                          const SizedBox(width: 2),
                          Text(d.trend,
                              style: TextStyle(
                                fontFamily: AquaText.font,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: d.trendUp
                                    ? AquaColors.success
                                    : AquaColors.primary,
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Chart
              SizedBox(
                key: ValueKey('${_metric.name}-${_period.name}'),
                height: 200,
                child: Stack(
                  children: [
                    // Grid lines
                    for (var i = 0; i < 5; i++)
                      Positioned(
                        top: i * 40.0,
                        left: 0,
                        right: 0,
                        child: Container(height: 1, color: Colors.grey[100]),
                      ),
                    // Sparkline
                    CustomPaint(
                      painter: SparklinePainter(
                        color: AquaColors.primary,
                        points: d.points,
                      ),
                      size: const Size(double.infinity, 200),
                    ),
                    // Live dot
                    Positioned(
                      right: 0,
                      top: d.points.last.dy * 200,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AquaColors.cyan,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // X labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: d.labels
                    .map((l) => Text(l,
                        style: TextStyle(
                          fontFamily: AquaText.font,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: l == d.labels.last
                              ? AquaColors.primary
                              : Colors.grey[400],
                        )))
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Insight cards
        Row(
          children: [
            Expanded(
                child: GlassCard(
              borderLeft: AquaColors.cyan,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Color(0xFFECFEFF), shape: BoxShape.circle),
                      child: const Icon(Icons.emoji_events_rounded,
                          size: 20, color: Color(0xFF0E7490))),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RATING STABILITAS',
                          style: TextStyle(
                              fontFamily: AquaText.font,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AquaColors.textSubtle,
                              letterSpacing: 1.0)),
                      SizedBox(height: 2),
                      Text('Tinggi (98.2%)',
                          style: TextStyle(
                              fontFamily: AquaText.font,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AquaColors.textMain)),
                    ],
                  )),
                ],
              ),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: GlassCard(
              borderLeft: AquaColors.primary,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.menu_book_outlined,
                          size: 20, color: AquaColors.primary)),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RERATA pH (MINGGUAN)',
                          style: TextStyle(
                              fontFamily: AquaText.font,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AquaColors.textSubtle,
                              letterSpacing: 1.0)),
                      SizedBox(height: 2),
                      Text('7.1 pH',
                          style: TextStyle(
                              fontFamily: AquaText.font,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AquaColors.textMain)),
                    ],
                  )),
                ],
              ),
            )),
          ],
        ),
        const SizedBox(height: 16),

        // Anomaly log
        Text('LOG ANOMALI', style: AquaText.label),
        const SizedBox(height: 8),
        GlassCard(
          borderLeft: AquaColors.danger,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: AquaColors.danger, shape: BoxShape.circle)),
              const SizedBox(width: 12),
              const Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Penurunan pH Mendadak',
                      style: TextStyle(
                          fontFamily: AquaText.font,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AquaColors.textMain)),
                  SizedBox(height: 2),
                  Text('Hari ini, 02:15 AM • Tangki #02',
                      style: TextStyle(
                          fontFamily: AquaText.font,
                          fontSize: 11,
                          color: AquaColors.textSubtle)),
                ],
              )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Kritis',
                    style: TextStyle(
                        fontFamily: AquaText.font,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AquaColors.danger)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GlassCard(
          borderLeft: AquaColors.cyan,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: AquaColors.cyan, shape: BoxShape.circle)),
              const SizedBox(width: 12),
              const Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Normalisasi Suhu',
                      style: TextStyle(
                          fontFamily: AquaText.font,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AquaColors.textMain)),
                  SizedBox(height: 2),
                  Text('Kemarin, 11:40 PM • Semua Tangki',
                      style: TextStyle(
                          fontFamily: AquaText.font,
                          fontSize: 11,
                          color: AquaColors.textSubtle)),
                ],
              )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20)),
                child: Text('Info',
                    style: TextStyle(
                        fontFamily: AquaText.font,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[600])),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartData {
  final String title, sub, value, unit, trend;
  final bool trendUp;
  final List<Offset> points;
  final List<String> labels;

  const _ChartData(this.title, this.sub, this.value, this.unit, this.trend,
      this.trendUp, this.points, this.labels);
}

// ══════════════════════════════════════════════════════════════════════════════
// NOTIFICATIONS SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class NotificationsScreen extends StatefulWidget {
  final List<AquaNotification> notifications;
  final VoidCallback onMarkAllRead;
  final ValueChanged<String> onDismiss;
  final ValueChanged<AppView> onNavigate;

  const NotificationsScreen({
    super.key,
    required this.notifications,
    required this.onMarkAllRead,
    required this.onDismiss,
    required this.onNavigate,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Map<String, String> _actionTaken = {};

  void _handleAction(String id, String action) {
    setState(() => _actionTaken[id] = action);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) widget.onDismiss(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = widget.notifications.any((n) => n.unread);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AKTIVITAS REAL-TIME',
                    style: TextStyle(
                        fontFamily: AquaText.font,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AquaColors.textSubtle,
                        letterSpacing: 1.2)),
                SizedBox(height: 4),
                Text('Notifikasi', style: AquaText.headline),
              ],
            )),
            if (hasUnread)
              TextButton(
                onPressed: widget.onMarkAllRead,
                child: const Text('Tandai sudah dibaca',
                    style: TextStyle(
                        fontFamily: AquaText.font,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AquaColors.primary)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.notifications.isEmpty)
          GlassCard(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                        color: Color(0xFFEFF6FF), shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle_outlined,
                        size: 26, color: AquaColors.primary)),
                const SizedBox(height: 12),
                const Text('Semua Sistem Terkendali',
                    style: TextStyle(
                        fontFamily: AquaText.font,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AquaColors.textMain)),
                const SizedBox(height: 4),
                Text('Tidak ada peringatan aktif.',
                    style: AquaText.body, textAlign: TextAlign.center),
              ],
            ),
          )
        else
          for (final notif in widget.notifications)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimatedOpacity(
                opacity: _actionTaken.containsKey(notif.id) ? 0.4 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: _NotifCard(
                  notif: notif,
                  actionTaken: _actionTaken[notif.id],
                  onNavigate: widget.onNavigate,
                  onAction: _handleAction,
                ),
              ),
            ),
      ],
    );
  }
}

class _NotifCard extends StatelessWidget {
  final AquaNotification notif;
  final String? actionTaken;
  final ValueChanged<AppView> onNavigate;
  final void Function(String id, String action) onAction;

  const _NotifCard({
    required this.notif,
    required this.actionTaken,
    required this.onNavigate,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final (iconBg, iconColor, icon) = switch (notif.type) {
      NotifType.turbidity => (
          const Color(0xFFFEE2E2),
          AquaColors.danger,
          Icons.water_drop_rounded
        ),
      NotifType.ph => (AquaColors.danger, Colors.white, Icons.warning_rounded),
      NotifType.sensor => (
          const Color(0xFFEFF6FF),
          AquaColors.primary,
          Icons.wifi_off_rounded
        ),
    };

    return GlassCard(
      borderLeft: notif.type == NotifType.ph ? AquaColors.danger : null,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                  width: 44,
                  height: 44,
                  decoration:
                      BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(icon, size: 22, color: iconColor)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(notif.title,
                                style: const TextStyle(
                                    fontFamily: AquaText.font,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AquaColors.textMain))),
                        if (notif.unread)
                          Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  color: AquaColors.primary,
                                  shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text(notif.time, style: AquaText.micro),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notif.description,
                        style: AquaText.body.copyWith(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          if (actionTaken != null) ...[
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.check_circle_rounded,
                  size: 16, color: AquaColors.success),
              const SizedBox(width: 4),
              Text(actionTaken == 'ignore' ? 'Diabaikan' : 'Diproses...',
                  style: const TextStyle(
                      fontFamily: AquaText.font,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AquaColors.success)),
            ]),
          ] else ...[
            const SizedBox(height: 10),
            Row(children: [
              if (notif.type == NotifType.turbidity) ...[
                ElevatedButton(
                  onPressed: () => onNavigate(AppView.monitoring),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Periksa Kolam',
                      style: TextStyle(fontSize: 11)),
                ),
                const SizedBox(width: 8),
                _ghostBtn('Abaikan', () => onAction(notif.id, 'ignore')),
              ],
              if (notif.type == NotifType.ph) ...[
                ElevatedButton(
                  onPressed: () => onAction(notif.id, 'darurat'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AquaColors.danger,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Tindakan Darurat',
                      style: TextStyle(fontSize: 11)),
                ),
                const SizedBox(width: 8),
                _ghostBtn('Abaikan', () => onAction(notif.id, 'ignore')),
              ],
              if (notif.type == NotifType.sensor)
                _ghostBtn(
                    'Perbaiki Koneksi', () => onAction(notif.id, 'repair'),
                    outlined: true),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _ghostBtn(String label, VoidCallback onTap, {bool outlined = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: outlined ? Border.all(color: AquaColors.primary) : null,
        ),
        child: Text(label,
            style: TextStyle(
              fontFamily: AquaText.font,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: outlined ? AquaColors.primary : Colors.grey[700],
            )),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PROFILE SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class ProfileScreen extends StatefulWidget {
  final AquaUser user;
  final ValueChanged<AquaUser> onUpdateUser;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.onUpdateUser,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showEditModal = false;
  bool _showNotifModal = false;
  bool _showFaqModal = false;
  bool _pushEnabled = true;
  bool _emailAlertsEnabled = true;
  int? _activeFaq;

  final _faqs = const [
    (
      'Bagaimana cara kalibrasi sensor pH?',
      'Bilas probe dengan air suling terlebih dahulu, rendam dalam larutan buffer standard pH 7.00, lalu sesuaikan nilai kalibrasi di menu konfigurasi.'
    ),
    (
      'Mengapa kekeruhan air NTU melonjak tinggi?',
      'NTU tinggi menunjukkan adanya partikel tersuspensi yang berlebih. Periksa filter biologis Raceway dan laju sirkulasi air sesegera mungkin.'
    ),
    (
      'Berapa lama daya tahan baterai sensor?',
      'Sensor Aqualyze LoraWan dirancang hemat daya dengan masa pakai baterai internal hingga 18 bulan dalam interval pengiriman data 10 menit.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
          children: [
            // Avatar
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundImage: NetworkImage(widget.user.avatar),
                    backgroundColor: Colors.grey[200],
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showEditModal = true),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: AquaColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.edit_rounded,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.user.name,
                style: AquaText.display.copyWith(fontSize: 24),
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(widget.user.email,
                style: AquaText.body, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _badge(widget.user.role, AquaColors.primary,
                    const Color(0xFFEFF6FF)),
                if (widget.user.isVerified) ...[
                  const SizedBox(width: 8),
                  _badge('Verified', const Color(0xFF4338CA),
                      const Color(0xFFEEF2FF)),
                ],
              ],
            ),
            const SizedBox(height: 28),

            // Account section
            Text('RINGKASAN AKUN', style: AquaText.label),
            const SizedBox(height: 8),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _MenuItem(
                    iconBg: const Color(0xFFEFF6FF),
                    icon: Icons.manage_accounts_outlined,
                    iconColor: AquaColors.primary,
                    title: 'Pengaturan Akun',
                    titleColor: AquaColors.primary,
                    sub: 'Kelola informasi pribadi Anda',
                    onTap: () => setState(() => _showEditModal = true),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _MenuItem(
                    iconBg: const Color(0xFFECFEFF),
                    icon: Icons.settings_outlined,
                    iconColor: const Color(0xFF0E7490),
                    title: 'Pengaturan Notifikasi',
                    titleColor: const Color(0xFF0E7490),
                    sub: 'Ambang batas peringatan dan preferensi push',
                    onTap: () => setState(() => _showNotifModal = true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Support section
            Text('DUKUNGAN & INFORMASI', style: AquaText.label),
            const SizedBox(height: 8),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _MenuItem(
                    iconBg: Colors.grey[100]!,
                    icon: Icons.info_outline_rounded,
                    iconColor: Colors.grey[500]!,
                    title: 'Tentang Aqualyze',
                    sub: 'Versi 2.4.0 (Industrial Build)',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: const Text('TERBARU',
                          style: TextStyle(
                            fontFamily: AquaText.font,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AquaColors.primary,
                            letterSpacing: 0.8,
                          )),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _MenuItem(
                    iconBg: Colors.grey[100]!,
                    icon: Icons.help_outline_rounded,
                    iconColor: Colors.grey[500]!,
                    title: 'Bantuan & Dukungan',
                    sub: 'Dokumentasi dan dukungan chat langsung',
                    onTap: () => setState(() => _showFaqModal = true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout
            GestureDetector(
              onTap: widget.onLogout,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFCDD2)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded,
                        size: 20, color: Color(0xFFBE123C)),
                    SizedBox(width: 8),
                    Text('Keluar',
                        style: TextStyle(
                            fontFamily: AquaText.font,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFBE123C))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('Sesi aktif selama 4 jam',
                style: AquaText.micro, textAlign: TextAlign.center),
          ],
        ),

        // Edit modal
        if (_showEditModal)
          _EditModal(
            user: widget.user,
            onClose: () => setState(() => _showEditModal = false),
            onSave: (u) {
              widget.onUpdateUser(u);
              setState(() => _showEditModal = false);
            },
          ),

        // Notif modal
        if (_showNotifModal)
          _NotifSettingsModal(
            pushEnabled: _pushEnabled,
            emailEnabled: _emailAlertsEnabled,
            onPushChanged: (v) => setState(() => _pushEnabled = v),
            onEmailChanged: (v) => setState(() => _emailAlertsEnabled = v),
            onClose: () => setState(() => _showNotifModal = false),
          ),

        // FAQ modal
        if (_showFaqModal)
          _FaqModal(
            faqs: _faqs,
            activeFaq: _activeFaq,
            onToggle: (i) =>
                setState(() => _activeFaq = _activeFaq == i ? null : i),
            onClose: () => setState(() {
              _showFaqModal = false;
              _activeFaq = null;
            }),
          ),
      ],
    );
  }

  Widget _badge(String label, Color fg, Color bg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: fg.withOpacity(0.2)),
        ),
        child: Text(label.toUpperCase(),
            style: TextStyle(
                fontFamily: AquaText.font,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: fg,
                letterSpacing: 0.8)),
      );
}

class _MenuItem extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final String sub;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _MenuItem({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.sub,
    this.titleColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 20, color: iconColor)),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontFamily: AquaText.font,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: titleColor ?? AquaColors.textMain)),
                const SizedBox(height: 2),
                Text(sub, style: AquaText.body.copyWith(fontSize: 11)),
              ],
            )),
            trailing ??
                (onTap != null
                    ? const Icon(Icons.chevron_right_rounded,
                        color: AquaColors.textSubtle, size: 20)
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}

class _EditModal extends StatefulWidget {
  final AquaUser user;
  final VoidCallback onClose;
  final ValueChanged<AquaUser> onSave;

  const _EditModal(
      {required this.user, required this.onClose, required this.onSave});

  @override
  State<_EditModal> createState() => _EditModalState();
}

class _EditModalState extends State<_EditModal> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  String _role = 'Administrator';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _emailCtrl = TextEditingController(text: widget.user.email);
    _role = widget.user.role;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ModalOverlay(
      onClose: widget.onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModalHeader(title: 'Edit Profil', onClose: widget.onClose),
          const SizedBox(height: 20),
          AquaTextField(label: 'Nama Lengkap', hint: '', controller: _nameCtrl),
          const SizedBox(height: 14),
          AquaTextField(
              label: 'Alamat Email',
              hint: '',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 14),
          Text('PERAN AKSES', style: AquaText.label),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _role,
            items: ['Administrator', 'Teknisi Lapangan', 'Pemilik Tambak']
                .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                .toList(),
            onChanged: (v) => setState(() => _role = v ?? _role),
            decoration: const InputDecoration(),
            style: const TextStyle(
                fontFamily: AquaText.font,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AquaColors.textMain),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => widget.onSave(widget.user.copyWith(
                name: _nameCtrl.text, email: _emailCtrl.text, role: _role)),
            icon: const Icon(Icons.save_rounded, size: 18),
            label: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }
}

class _NotifSettingsModal extends StatelessWidget {
  final bool pushEnabled;
  final bool emailEnabled;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEmailChanged;
  final VoidCallback onClose;

  const _NotifSettingsModal({
    required this.pushEnabled,
    required this.emailEnabled,
    required this.onPushChanged,
    required this.onEmailChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalOverlay(
      onClose: onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ModalHeader(title: 'Notifikasi Pustaka', onClose: onClose),
          const SizedBox(height: 20),
          _SwitchRow(
              label: 'Pemberitahuan Push',
              sub: 'Kirim langsung ke perangkat seluler',
              value: pushEnabled,
              onChanged: onPushChanged),
          const SizedBox(height: 14),
          _SwitchRow(
              label: 'Pemberitahuan Email',
              sub: 'Ringkasan harian dan notifikasi kritis',
              value: emailEnabled,
              onChanged: onEmailChanged),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: onClose, child: const Text('Simpan Preferensi')),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label, sub;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow(
      {required this.label,
      required this.sub,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontFamily: AquaText.font,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AquaColors.textMain)),
            const SizedBox(height: 2),
            Text(sub, style: AquaText.body.copyWith(fontSize: 11)),
          ],
        )),
        Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AquaColors.primary),
      ],
    );
  }
}

class _FaqModal extends StatelessWidget {
  final List<(String, String)> faqs;
  final int? activeFaq;
  final ValueChanged<int> onToggle;
  final VoidCallback onClose;

  const _FaqModal(
      {required this.faqs,
      required this.activeFaq,
      required this.onToggle,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    return _ModalOverlay(
      onClose: onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ModalHeader(title: 'Bantuan & Dukungan FAQ', onClose: onClose),
          const SizedBox(height: 16),
          for (var i = 0; i < faqs.length; i++) ...[
            GestureDetector(
              onTap: () => onToggle(i),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[100]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(faqs[i].$1,
                                  style: const TextStyle(
                                      fontFamily: AquaText.font,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AquaColors.textMain))),
                          Icon(
                              activeFaq == i
                                  ? Icons.expand_less_rounded
                                  : Icons.chevron_right_rounded,
                              size: 18,
                              color: activeFaq == i
                                  ? AquaColors.primary
                                  : Colors.grey[400]),
                        ],
                      ),
                    ),
                    if (activeFaq == i)
                      Container(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                        child: Text(faqs[i].$2,
                            style: AquaText.body
                                .copyWith(fontSize: 12, height: 1.6)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          Text('Butuh bantuan lebih mendalam?',
              style: AquaText.body, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: () {}, child: const Text('Dukungan Obrolan Lapangan')),
        ],
      ),
    );
  }
}

class _ModalOverlay extends StatelessWidget {
  final Widget child;
  final VoidCallback onClose;

  const _ModalOverlay({required this.child, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: GestureDetector(
          onTap: () {},
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModalHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _ModalHeader({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AquaText.title),
        GestureDetector(
          onTap: onClose,
          child: Container(
            width: 32,
            height: 32,
            decoration:
                BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: const Icon(Icons.close_rounded,
                size: 16, color: AquaColors.textSubtle),
          ),
        ),
      ],
    );
  }
}
