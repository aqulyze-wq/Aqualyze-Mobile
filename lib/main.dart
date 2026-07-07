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
import 'models/models.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/other_screens.dart';
import 'theme/app_theme.dart';
import 'widgets/shared_widgets.dart';
import 'services/api_service.dart';

void main() {
  runApp(const AqualyzeApp());
}

class AqualyzeApp extends StatelessWidget {
  const AqualyzeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aqualyze',
      debugShowCheckedModeBanner: false,
      theme: buildAquaTheme(),
      home: const _AppRoot(),
    );
  }
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  AquaUser? _user;
  AppView _activeTab = AppView.dashboard;

  String _statusTemperature = "Normal";
  String _statusPh = "Normal";
  String _statusTurbidity = "Normal";
  // Shared telemetry state
  double _temperature = 28.5;
  double _ph = 7.2;
  int _turbidity = 12;
  String _lastSync = '10:45 AM';

  List<dynamic> _history = [];

  List<AquaNotification> _notifications = const [
    AquaNotification(
      id: 'turb-1',
      title: 'Peringatan Kekeruhan Tinggi',
      description:
          'Tingkat kekeruhan di Kolam 1 melebihi 15 NTU. Disarankan pemeriksaan sistem filtrasi.',
      time: '10m lalu',
      type: NotifType.turbidity,
      unread: true,
    ),
    AquaNotification(
      id: 'ph-1',
      title: 'Peringatan pH Rendah',
      description:
          'Tingkat pH turun menjadi 6.2 di Kolam 2. Ambang batas kritis tercapai.',
      time: '1j lalu',
      type: NotifType.ph,
      unread: true,
    ),
    AquaNotification(
      id: 'sens-1',
      title: 'Sensor Tidak Terhubung',
      description:
          'Sensor #03 luring. Periksa konektivitas nirkabel di Sektor Timur.',
      time: '3j lalu',
      type: NotifType.sensor,
      unread: false,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => n.unread).length;

  void _handleLogin(Map<String, dynamic> user) {
    setState(() {
      _user = AquaUser(
        name: user["name"],
        email: user["email"],
        role: 'Administrator',
        isVerified: true,
        avatar:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDCcVkfugEhfit5f-gTVSQAV1lCB6EemiJh60Rq6TUS5i-DaTpRPW_NQvYux3QQ28pbXmzINxMOCbdJE0Qudz_o5wc7n1Q-VMwEDxecxKHvEW_B8x2unEYIze0tQMzB0IZ5QDB-0d5It0eMWLAK3CNThz1iO7nBFw7glzjpsIF16mvwHBiaz15wGUmdJggMiYYXNGhwIAb3EbspwaSh73XyAOxREuZ5B8fR0RXkUwVW6VuQmHAmg0H5aHMeuBOk-4fRPkluxKEl2QPG',
      );
      _activeTab = AppView.dashboard;
    });

    _loadLatestSensor();
    _loadHistory();
  }

  Future<void> _loadLatestSensor() async {
    final data = await ApiService.getLatestSensor();

    print("DATA SENSOR: $data");

    if (data != null) {
      setState(() {
        _temperature = (data["suhu"] as num).toDouble();
        _ph = (data["ph"] as num).toDouble();
        _turbidity = data["kekeruhan"] as int;

        _statusTemperature = data["status_suhu"] ?? "Normal";
        _statusPh = data["status_ph"] ?? "Normal";
        _statusTurbidity = data["status_kekeruhan"] ?? "Normal";

        print("SETSTATE SUHU = $_temperature");

        final now = DateTime.now();
        final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
        final m = now.minute.toString().padLeft(2, '0');
        final ap = now.hour >= 12 ? 'PM' : 'AM';
        _lastSync = '$h:$m $ap';
      });
    }
  }

  Future<void> _loadHistory() async {
    final data = await ApiService.getHistory();

    if (data != null) {
      setState(() {
        _history = data;
      });
    }
  }

  void _handleRefresh() {
    _loadLatestSensor();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return LoginScreen(onLoginSuccess: _handleLogin);
    }

    return Scaffold(
      backgroundColor: AquaColors.bg,
      body: Stack(
        children: [
          // Wave background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AquaColors.primary.withOpacity(0.04),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              AppHeader(
                user: _user!,
                unreadCount: _unreadCount,
                onTabChange: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(
                          CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                      child: child,
                    ),
                  ),
                  child: _buildBody(),
                ),
              ),
            ],
          ),
          AquaNavBar(
            activeTab: _activeTab,
            unreadCount: _unreadCount,
            onTabChange: (tab) => setState(() => _activeTab = tab),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return switch (_activeTab) {
      AppView.dashboard => DashboardScreen(
          key: const ValueKey('dashboard'),
          user: _user!,
          temperature: _temperature,
          ph: _ph,
          turbidity: _turbidity,
          statusTemperature: _statusTemperature,
          statusPh: _statusPh,
          statusTurbidity: _statusTurbidity,
          history: _history,
          onNavigate: (tab) => setState(() => _activeTab = tab),
        ),
      AppView.monitoring => MonitoringScreen(
          temperature: _temperature,
          ph: _ph,
          turbidity: _turbidity,
          statusTemperature: _statusTemperature,
          statusPh: _statusPh,
          statusTurbidity: _statusTurbidity,
          lastSyncTime: _lastSync,
          onRefresh: _handleRefresh,
        ),
      AppView.charts => const AnalyticsScreen(
          key: ValueKey('charts'),
        ),
      AppView.notifications => NotificationsScreen(
          key: const ValueKey('notifications'),
          notifications: _notifications,
          onMarkAllRead: () => setState(() {
            _notifications =
                _notifications.map((n) => n.copyWith(unread: false)).toList();
          }),
          onDismiss: (id) => setState(() {
            _notifications = _notifications.where((n) => n.id != id).toList();
          }),
          onNavigate: (tab) => setState(() => _activeTab = tab),
        ),
      AppView.profile => ProfileScreen(
          key: const ValueKey('profile'),
          user: _user!,
          onUpdateUser: (u) => setState(() => _user = u),
          onLogout: () => setState(() => _user = null),
        ),
    };
  }
}
