import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const seed = Color(0xFF1F6F66);
  static const deep = Color(0xFF0F3D39);
  static const mid = Color(0xFF2A857B);
  static const mist = Color(0xFFF2F7F5);
  static const soft = Color(0xFFD5E6E1);
  static const ink = Color(0xFF142421);
  static const muted = Color(0xFF5A6E68);
  static const warn = Color(0xFFB7791F);
  static const high = Color(0xFFB42318);
  static const low = Color(0xFF2F6B4F);
  static const creamSoft = Color(0xFFF7FBFA);
}

class AppTheme {
  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.light,
      surface: AppColors.mist,
    );

    final textTheme = GoogleFonts.manropeTextTheme().apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base.copyWith(
        primary: AppColors.seed,
        onPrimary: Colors.white,
        secondary: AppColors.deep,
        surface: AppColors.mist,
      ),
      scaffoldBackgroundColor: AppColors.mist,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -0.3,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.seed,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: -0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deep,
          minimumSize: const Size.fromHeight(54),
          side: BorderSide(color: AppColors.soft.withValues(alpha: 0.95), width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.creamSoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: GoogleFonts.manrope(
          color: AppColors.muted,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: GoogleFonts.manrope(color: AppColors.muted.withValues(alpha: 0.75)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.soft.withValues(alpha: 0.8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.soft.withValues(alpha: 0.8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.seed, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.high),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        height: 72,
        indicatorColor: AppColors.soft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? AppColors.deep : AppColors.muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.deep : AppColors.muted,
            size: 22,
          );
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.seed,
        inactiveTrackColor: AppColors.soft,
        thumbColor: AppColors.deep,
        overlayColor: AppColors.seed.withValues(alpha: 0.12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.creamSoft,
        selectedColor: AppColors.soft,
        labelStyle: GoogleFonts.manrope(
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        side: BorderSide(color: AppColors.soft.withValues(alpha: 0.9)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: AppColors.soft.withValues(alpha: 0.7)),
        ),
      ),
    );
  }
}
