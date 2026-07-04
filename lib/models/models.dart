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
class AquaUser {
  final String name;
  final String email;
  final String role;
  final bool isVerified;
  final String avatar;

  const AquaUser({
    required this.name,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.avatar,
  });

  AquaUser copyWith({String? name, String? email, String? role}) => AquaUser(
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
        isVerified: isVerified,
        avatar: avatar,
      );
}

enum NotifType { turbidity, ph, sensor }

class AquaNotification {
  final String id;
  final String title;
  final String description;
  final String time;
  final NotifType type;
  final bool unread;

  const AquaNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    required this.unread,
  });

  AquaNotification copyWith({bool? unread}) => AquaNotification(
        id: id,
        title: title,
        description: description,
        time: time,
        type: type,
        unread: unread ?? this.unread,
      );
}

enum AppView { dashboard, monitoring, charts, notifications, profile }

enum MetricType { temp, ph, turbidity }
enum PeriodType { daily, weekly, monthly }
