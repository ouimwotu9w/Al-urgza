import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// نظام التصميم الموحد للتطبيق — Material 3 بهوية «الأزرق الليلي».
class AppTheme {
  AppTheme._();

  /// اللون البذري: أزرق ملكي ليلي.
  static const Color seedBlue = Color(0xFF1A237E);

  /// لون فضي مساعد يستخدم في الزخارف والشارات.
  static const Color accentSilver = Color(0xFF90A4AE);

  /// لون ورقي دافئ لخلفيات عرض الأبيات.
  static const Color paperLight = Color(0xFFFBF9F4);

  static ThemeData build({required Brightness brightness}) {
    // الهوية اللونية ثابتة على الأزرق الملكي الليلي دائماً،
    // ولا تتأثر بألوان خلفية الجهاز (Material You معطّل تماماً).
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: seedBlue,
      brightness: brightness,
    ).copyWith(
      // إبقاء اللون الثالث في العائلة الزرقاء بدل انحرافه إلى الوردي/الأخضر.
      tertiary: brightness == Brightness.light
          ? const Color(0xFF2E3A9E)
          : const Color(0xFFAEB9FF),
      onTertiary: brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF16205C),
      tertiaryContainer: brightness == Brightness.light
          ? const Color(0xFFE1E6FF)
          : const Color(0xFF2E3A9E),
      onTertiaryContainer: brightness == Brightness.light
          ? const Color(0xFF16205C)
          : const Color(0xFFE1E6FF),
    );
    final ThemeData base =
        ThemeData(useMaterial3: true, brightness: brightness, colorScheme: scheme);

    return base.copyWith(
      textTheme: GoogleFonts.cairoTextTheme(base.textTheme),
      scaffoldBackgroundColor: brightness == Brightness.light
          ? const Color(0xFFF6F7FC)
          : const Color(0xFF10131C),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        height: 66,
        elevation: 1,
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 0.6,
        space: 0.6,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  /// نمط نص الأبيات الشعري بخط أميري.
  static TextStyle verseStyle(
    double size, {
    Color? color,
    FontWeight weight = FontWeight.w600,
  }) {
    return GoogleFonts.amiri(
      fontSize: size,
      height: 1.9,
      color: color,
      fontWeight: weight,
    );
  }

  /// نمط نص الشروح.
  static TextStyle explanationStyle(ColorScheme scheme, {double size = 14.5}) {
    return GoogleFonts.cairo(
      fontSize: size,
      height: 1.85,
      color: scheme.onSurfaceVariant,
    );
  }
}
