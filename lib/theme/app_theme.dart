import 'package:flutter/material.dart';

class AquaColors {
  AquaColors._();
  static const primary = Color(0xFF1565C0);
  static const primaryDark = Color(0xFF004D99);
  static const primaryLight = Color(0xFFDAE5FF);
  static const surface = Colors.white;
  static const bg = Color(0xFFF9F9FF);
  static const textMain = Color(0xFF191C21);
  static const textSubtle = Color(0xFF64748B);
  static const danger = Color(0xFFBA1A1A);
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFEA580C);
  static const cyan = Color(0xFF26C6DA);
}

class AquaText {
  AquaText._();
  static const String font = 'PlusJakartaSans';

  static const display = TextStyle(
    fontFamily: font,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AquaColors.textMain,
    letterSpacing: -0.8,
  );
  static const headline = TextStyle(
    fontFamily: font,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AquaColors.textMain,
    letterSpacing: -0.5,
  );
  static const title = TextStyle(
    fontFamily: font,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AquaColors.textMain,
  );
  static const body = TextStyle(
    fontFamily: font,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AquaColors.textSubtle,
  );
  static const label = TextStyle(
    fontFamily: font,
    fontSize: 10,
    fontWeight: FontWeight.w800,
    color: AquaColors.textSubtle,
    letterSpacing: 1.4,
  );
  static const micro = TextStyle(
    fontFamily: font,
    fontSize: 9,
    fontWeight: FontWeight.w700,
    color: AquaColors.textSubtle,
    letterSpacing: 1.2,
  );
}

/// Glass card decoration
BoxDecoration glassCard({
  double radius = 20,
  Color? borderLeft,
}) =>
    BoxDecoration(
      color: Colors.white.withOpacity(0.85),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withOpacity(0.4),
      ),
      boxShadow: [
        BoxShadow(
          color: AquaColors.primary.withOpacity(0.05),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ],
    );

ThemeData buildAquaTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AquaColors.bg,
      colorScheme: ColorScheme.fromSeed(seedColor: AquaColors.primary),
      fontFamily: AquaText.font,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AquaColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: AquaText.font,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFEFF6FF).withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AquaColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
