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
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/sensor_chart.dart';

class DashboardScreen extends StatefulWidget {
  final AquaUser user;
  final double temperature;
  final double ph;
  final int turbidity;
  final List<dynamic> history;
  final ValueChanged<AppView> onNavigate;

  const DashboardScreen({
    super.key,
    required this.user,
    required this.temperature,
    required this.ph,
    required this.turbidity,
    required this.history,
    required this.onNavigate,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late double _liveTemp;
  late double _livePh;
  bool _activeCamera = true; // true = west, false = east
  bool _isFullscreen = false;
  Timer? _timer;

  static const _camWest =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDyhAbQt0WO95r9iPXV4yn7UJnrVdOsAouP2agR3a2P1R9kdDWyZJ8-njoki9FAsuWx-9Llt8kwTvRWAWjIQ53P2oMVJ7DOASsqbMPzidFY6vWTSzS7XPNQ9eKtykyiTJivSwJSV9tdpazpjwPiVeUlSN5yvOU0VNeNErBT-PAXR0HhgJoBT-oRtqrEyrK-WRzYOl87e_khe_qCunT_N0d9BV7YI2zds4TrXIcHfFULwy0ZbsYkI12R9gppYAAuLQBPkwnE2X6ZrRzT';
  static const _camEast =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAbADUETPIeaLnoTWzX3rH8fD88DCLIDOuuSc7SVAm6bR8sDMkiYh__k2GzlfhQBl1SBHzFYWKlPu2Z3ZpbxIXYKcfM9XzU5v1gR89758SYvj81Sg5AxLVShCdvDdVpidVYU_t9YSlRattDR7cs8eN0nR5XyirVg9xJwUP5vCnCu-bxs11szAHnQhGR-8aaiePs-wvzNHS8TNAJ99VdrSHQqVUAPit7xOxE_KcWptvYWKc1wzD-wXZN_9xHeS_5O5443NUyJllcW64W';

  @override
  void initState() {
    super.initState();
    _liveTemp = widget.temperature;
    _livePh = widget.ph;
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.temperature != widget.temperature ||
        oldWidget.ph != widget.ph) {
      setState(() {
        _liveTemp = widget.temperature;
        _livePh = widget.ph;
      });
    }
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Selamat Pagi';
    if (h < 15) return 'Selamat Siang';
    if (h < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    print(widget.history.length);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
          children: [
            // Greeting
            Text(
              'Ringkasan Dashboard'.toUpperCase(),
              style: AquaText.label.copyWith(color: AquaColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              '${_greeting()}, ${widget.user.name.split(' ').first}',
              style: AquaText.display,
            ),
            const SizedBox(height: 24),

            // Main status card
            _StatusCard(),
            const SizedBox(height: 16),

            // Metrics grid
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.thermostat_rounded,
                    iconColor: AquaColors.primary,
                    iconBg: const Color(0xFFEFF6FF),
                    value: '$_liveTemp',
                    unit: '°C',
                    label: 'Suhu Air',
                    badge: StatusBadge.normal(),
                    onTap: () => widget.onNavigate(AppView.monitoring),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.science_outlined,
                    iconColor: AquaColors.primary,
                    iconBg: const Color(0xFFEFF6FF),
                    value: '$_livePh',
                    unit: 'pH',
                    label: 'Tingkat pH',
                    badge: StatusBadge.normal(),
                    onTap: () => widget.onNavigate(AppView.monitoring),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Turbidity card
            GlassCard(
              borderLeft: AquaColors.warning,
              padding: const EdgeInsets.all(16),
              onTap: () => widget.onNavigate(AppView.monitoring),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.waves_rounded,
                        color: AquaColors.warning, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${widget.turbidity} ',
                              style: const TextStyle(
                                fontFamily: AquaText.font,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AquaColors.textMain,
                              ),
                            ),
                            const TextSpan(
                              text: 'NTU',
                              style: TextStyle(
                                fontFamily: AquaText.font,
                                fontSize: 12,
                                color: AquaColors.textSubtle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('Kekeruhan Air', style: AquaText.body),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge.warning(),
                      const SizedBox(height: 4),
                      Text('2m lalu', style: AquaText.micro),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // System health chips
            Text(
              'KESEHATAN SISTEM',
              style: AquaText.label,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _HealthChip(
                    leading: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AquaColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    label: 'Sistem: Online',
                  ),
                  const SizedBox(width: 8),
                  _HealthChip(
                    leading: const Icon(Icons.battery_full_rounded,
                        size: 16, color: AquaColors.textSubtle),
                    label: 'Sensor: 100%',
                  ),
                  const SizedBox(width: 8),
                  _HealthChip(
                    leading: const Icon(Icons.shield_outlined,
                        size: 16, color: AquaColors.primary),
                    label: 'Kualitas: Baik',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Grafik Suhu", style: AquaText.title),
                  const SizedBox(height: 16),
                  SensorChart(
                    history: widget.history,
                    field: "suhu",
                    color: Colors.red,
                    minY: 10,
                    maxY: 35,
                    interval: 5,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Grafik pH", style: AquaText.title),
                  const SizedBox(height: 16),
                  SensorChart(
                    history: widget.history,
                    field: "ph",
                    color: Colors.blue,
                    minY: 6.5,
                    maxY: 9,
                    interval: 0.5,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Grafik Kekeruhan", style: AquaText.title),
                  const SizedBox(height: 16),
                  SensorChart(
                    history: widget.history,
                    field: "kekeruhan",
                    color: Colors.orange,
                    minY: 0,
                    maxY: 10,
                    interval: 2,
                  ),
                ],
              ),
            ),

            // Camera
            Text('KAMERA PEMANTAU', style: AquaText.label),
            const SizedBox(height: 8),
            _CameraCard(
              isWest: _activeCamera,
              camWest: _camWest,
              camEast: _camEast,
              onSwitch: () => setState(() => _activeCamera = !_activeCamera),
              onFullscreen: () => setState(() => _isFullscreen = true),
            ),
          ],
        ),

        // Fullscreen modal
        if (_isFullscreen)
          _FullscreenModal(
            isWest: _activeCamera,
            camWest: _camWest,
            camEast: _camEast,
            onSwitch: () => setState(() => _activeCamera = !_activeCamera),
            onClose: () => setState(() => _isFullscreen = false),
          ),
      ],
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AquaColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STATUS KOLAM A-01',
                        style: AquaText.micro,
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: AquaText.font,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AquaColors.textMain,
                          ),
                          children: [
                            TextSpan(text: 'Kualitas: '),
                            TextSpan(
                              text: 'Sangat Baik',
                              style: TextStyle(color: AquaColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_rounded,
                            size: 14, color: AquaColors.success),
                        SizedBox(width: 4),
                        Text('STABIL',
                            style: TextStyle(
                              fontFamily: AquaText.font,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AquaColors.success,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Skor Efisiensi', style: AquaText.body),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: '98.4',
                              style: TextStyle(
                                fontFamily: AquaText.font,
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: AquaColors.textMain,
                              ),
                            ),
                            TextSpan(
                              text: '%',
                              style: TextStyle(
                                fontFamily: AquaText.font,
                                fontSize: 16,
                                color: AquaColors.textSubtle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 120,
                    height: 56,
                    child: CustomPaint(
                      painter: SparklinePainter(
                        color: AquaColors.primary,
                        points: const [
                          Offset(0, 0.9),
                          Offset(0.25, 0.75),
                          Offset(0.5, 0.5),
                          Offset(0.75, 0.35),
                          Offset(1.0, 0.15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String unit;
  final String label;
  final Widget badge;
  final VoidCallback onTap;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.unit,
    required this.label,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: SizedBox(
        height: 136,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                badge,
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        ),
                      ),
                      TextSpan(
                        text: ' $unit',
                        style: const TextStyle(
                          fontFamily: AquaText.font,
                          fontSize: 12,
                          color: AquaColors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(label, style: AquaText.body),
              ],
            ),
            Text('Diperbarui 2m lalu', style: AquaText.micro),
          ],
        ),
      ),
    );
  }
}

class _HealthChip extends StatelessWidget {
  final Widget leading;
  final String label;

  const _HealthChip({required this.leading, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 6),
          Text(label,
              style: AquaText.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AquaColors.textMain,
                  fontSize: 12)),
        ],
      ),
    );
  }
}

class _CameraCard extends StatelessWidget {
  final bool isWest;
  final String camWest;
  final String camEast;
  final VoidCallback onSwitch;
  final VoidCallback onFullscreen;

  const _CameraCard({
    required this.isWest,
    required this.camWest,
    required this.camEast,
    required this.onSwitch,
    required this.onFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(isWest ? camWest : camEast,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey[200])),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 14,
              left: 14,
              right: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isWest
                            ? 'Kolam Sayap Barat A-01'
                            : 'Kolam Sektor Timur B-03',
                        style: const TextStyle(
                          fontFamily: AquaText.font,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Siaran visual aktif • 1080p • ${isWest ? "Cam A" : "Cam B"}',
                        style: TextStyle(
                          fontFamily: AquaText.font,
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onSwitch,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.tv_rounded, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Pindah Cam',
                              style: TextStyle(
                                  fontFamily: AquaText.font,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: onFullscreen,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.fullscreen_rounded,
                      size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullscreenModal extends StatelessWidget {
  final bool isWest;
  final String camWest;
  final String camEast;
  final VoidCallback onSwitch;
  final VoidCallback onClose;

  const _FullscreenModal({
    required this.isWest,
    required this.camWest,
    required this.camEast,
    required this.onSwitch,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.95),
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(isWest ? camWest : camEast,
                        fit: BoxFit.cover),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('LIVE',
                                      style: TextStyle(
                                          fontFamily: AquaText.font,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isWest
                                      ? 'Kolam Sayap Barat A-01'
                                      : 'Kolam Sektor Timur B-03',
                                  style: const TextStyle(
                                      fontFamily: AquaText.font,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: onSwitch,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('Pindah Aliran',
                                    style: TextStyle(
                                        fontFamily: AquaText.font,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 48,
            right: 16,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.fullscreen_exit_rounded,
                    color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
