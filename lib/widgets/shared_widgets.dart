import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

// ─── Glass Card ───────────────────────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? borderLeft;
  final double radius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderLeft,
    this.radius = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: glassCard(radius: radius, borderLeft: borderLeft),
      child: child,
    );
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}

// ─── App Header ───────────────────────────────────────────────────────────────
class AppHeader extends StatelessWidget {
  final AquaUser user;
  final int unreadCount;
  final ValueChanged<AppView> onTabChange;

  const AppHeader({
    super.key,
    required this.user,
    required this.unreadCount,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 20,
        right: 20,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        boxShadow: [
          BoxShadow(
            color: AquaColors.primary.withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Brand logo
          GestureDetector(
            onTap: () => onTabChange(AppView.dashboard),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.water_drop_rounded,
                      color: AquaColors.primary, size: 26),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Aqualyze',
                  style: TextStyle(
                    fontFamily: AquaText.font,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AquaColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () => onTabChange(AppView.notifications),
                icon: const Icon(Icons.notifications_outlined,
                    color: AquaColors.textSubtle, size: 24),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AquaColors.danger,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
          // Avatar
          GestureDetector(
            onTap: () => onTabChange(AppView.profile),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(user.avatar),
              backgroundColor: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Nav Bar ───────────────────────────────────────────────────────────
class AquaNavBar extends StatelessWidget {
  final AppView activeTab;
  final int unreadCount;
  final ValueChanged<AppView> onTabChange;

  const AquaNavBar({
    super.key,
    required this.activeTab,
    required this.unreadCount,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(AppView.dashboard,     'Dashboard', Icons.grid_view_rounded),
      _NavItem(AppView.monitoring,    'Monitoring', Icons.waves_rounded),
      _NavItem(AppView.charts,        'Grafik',    Icons.show_chart_rounded),
      _NavItem(AppView.notifications, 'Notifikasi', Icons.notifications_rounded),
      _NavItem(AppView.profile,       'Profil',    Icons.person_rounded),
    ];

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 8,
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).padding.bottom + 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          boxShadow: [
            BoxShadow(
              color: AquaColors.primary.withOpacity(0.06),
              blurRadius: 32,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            final isActive = activeTab == item.view;
            final showBadge = item.view == AppView.notifications
                && unreadCount > 0
                && !isActive;
            return GestureDetector(
              onTap: () => onTabChange(item.view),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? AquaColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.icon,
                            size: 22,
                            color: isActive ? Colors.white : Colors.grey[400]),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: AquaText.font,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isActive ? Colors.white : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    if (showBadge)
                      Positioned(
                        top: -2,
                        right: -4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AquaColors.danger,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final AppView view;
  final String label;
  final IconData icon;
  const _NavItem(this.view, this.label, this.icon);
}

// ─── Text Field ───────────────────────────────────────────────────────────────
class AquaTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType keyboardType;

  const AquaTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 5),
          child: Text(label.toUpperCase(), style: AquaText.label),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: AquaText.font,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AquaColors.textMain,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontFamily: AquaText.font,
              fontSize: 14,
            ),
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final Color? borderColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.bg,
    required this.fg,
    this.borderColor,
  });

  factory StatusBadge.normal() => const StatusBadge(
    label: 'Normal',
    bg: Color(0xFFF0FDF4),
    fg: Color(0xFF16A34A),
    borderColor: Color(0xFFBBF7D0),
  );

  factory StatusBadge.warning() => const StatusBadge(
    label: 'Peringatan',
    bg: Color(0xFFFFF7ED),
    fg: Color(0xFFEA580C),
    borderColor: Color(0xFFFED7AA),
  );

  factory StatusBadge.danger() => const StatusBadge(
    label: 'Kritis',
    bg: Color(0xFFFEF2F2),
    fg: Color(0xFFDC2626),
    borderColor: Color(0xFFFECACA),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor ?? bg),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AquaText.font,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}

// ─── Sparkline Painter ────────────────────────────────────────────────────────
class SparklinePainter extends CustomPainter {
  final Color color;
  final List<Offset> points;
  final bool fill;

  SparklinePainter({
    required this.color,
    required this.points,
    this.fill = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = points[i].dx * size.width;
      final y = points[i].dy * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = points[i - 1].dx * size.width;
        final prevY = points[i - 1].dy * size.height;
        final midX = (prevX + x) / 2;
        path.cubicTo(midX, prevY, midX, y, x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    if (fill) {
      final fillPath = Path.from(path);
      fillPath.lineTo(points.last.dx * size.width, size.height);
      fillPath.lineTo(0, size.height);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.15), color.withOpacity(0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      canvas.drawPath(fillPath, fillPaint);
    }
  }

  @override
  bool shouldRepaint(SparklinePainter old) => old.color != color;
}
