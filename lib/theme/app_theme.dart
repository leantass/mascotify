import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primaryDeep,
          onPrimary: AppColors.dark,
          secondary: AppColors.accent,
          onSecondary: Colors.white,
          tertiary: AppColors.support,
          onTertiary: AppColors.dark,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          surfaceContainerHighest: AppColors.surfaceAlt,
          outline: AppColors.border,
          outlineVariant: AppColors.border,
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shadowColor: AppColors.primary.withValues(alpha: 0.10),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        height: 78,
        indicatorColor: AppColors.primarySoft,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? AppColors.primaryDeep
              : AppColors.textSecondary;
          return IconThemeData(color: color);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? AppColors.primaryDeep
              : AppColors.textSecondary;
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.2,
          );
        }),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          height: 1.1,
          letterSpacing: -0.8,
        ),
        headlineMedium: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          height: 1.15,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          backgroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.surfaceAlt,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      dividerColor: AppColors.border,
    );
  }

  static ThemeData dark() {
    const background = Color(0xFF101B20);
    const surface = Color(0xFF17262C);
    const surfaceAlt = Color(0xFF20323A);
    const surfaceTint = Color(0xFF24444A);
    const border = Color(0xFF36505A);
    const textPrimary = Color(0xFFF2FBFC);
    const textSecondary = Color(0xFFB4C7CD);
    const textMuted = Color(0xFF89A0A8);
    const primary = Color(0xFF7DDFDF);
    const primaryDeep = Color(0xFF8BE8E8);
    const primarySoft = Color(0xFF173E45);
    const accent = Color(0xFFFF5B83);
    const accentSoft = Color(0xFF43202F);
    const supportSoft = Color(0xFF3B3218);

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: primary,
          onPrimary: const Color(0xFF062A2D),
          secondary: accent,
          onSecondary: Colors.white,
          tertiary: AppColors.support,
          onTertiary: const Color(0xFF2A2100),
          surface: surface,
          onSurface: textPrimary,
          surfaceContainerHighest: surfaceAlt,
          outline: border,
          outlineVariant: border,
          error: const Color(0xFFFF8A8A),
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        shadowColor: Colors.black.withValues(alpha: 0.22),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        height: 78,
        indicatorColor: primarySoft,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? primaryDeep
              : textSecondary;
          return IconThemeData(color: color);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? primaryDeep
              : textSecondary;
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.2,
          );
        }),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryDeep,
        unselectedLabelColor: textSecondary,
        indicatorColor: primary,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          height: 1.1,
          letterSpacing: -0.8,
        ),
        headlineMedium: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          height: 1.15,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary, height: 1.5),
        bodySmall: TextStyle(fontSize: 12, color: textMuted, height: 1.45),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
          color: textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: border),
          backgroundColor: surfaceAlt,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surfaceAlt,
        selectedColor: primarySoft,
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: const TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? accent : textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? accentSoft
              : surfaceAlt;
        }),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: surfaceAlt,
        contentTextStyle: TextStyle(color: textPrimary),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: surface,
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      dividerColor: border,
      extensions: const <ThemeExtension<dynamic>>[
        MascotifyPalette(
          surfaceAlt: surfaceAlt,
          surfaceTint: surfaceTint,
          primarySoft: primarySoft,
          accentSoft: accentSoft,
          supportSoft: supportSoft,
          textMuted: textMuted,
        ),
      ],
    );
  }
}

bool mascotifyIsDark(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Color mascotifySurface(BuildContext context) {
  return Theme.of(context).colorScheme.surface;
}

Color mascotifySurfaceAlt(BuildContext context) {
  return MascotifyPalette.of(context).surfaceAlt;
}

Color mascotifySurfaceTint(BuildContext context) {
  return MascotifyPalette.of(context).surfaceTint;
}

Color mascotifyBorder(BuildContext context) {
  return Theme.of(context).colorScheme.outlineVariant;
}

Color mascotifyPrimaryText(BuildContext context) {
  return Theme.of(context).colorScheme.onSurface;
}

Color mascotifySecondaryText(BuildContext context) {
  return Theme.of(context).colorScheme.onSurfaceVariant;
}

Color mascotifyTone(BuildContext context, Color lightTone) {
  if (!mascotifyIsDark(context)) return lightTone;

  final palette = MascotifyPalette.of(context);
  if (lightTone == AppColors.primarySoft) return palette.primarySoft;
  if (lightTone == AppColors.accentSoft) return palette.accentSoft;
  if (lightTone == AppColors.supportSoft) return palette.supportSoft;
  if (lightTone == AppColors.surfaceTint) return palette.surfaceTint;
  if (lightTone == AppColors.surface || lightTone == AppColors.surfaceAlt) {
    return palette.surfaceAlt;
  }
  if (lightTone == Colors.white || lightTone.computeLuminance() > 0.45) {
    return palette.surfaceAlt;
  }

  return Color.alphaBlend(
    lightTone.withValues(alpha: 0.24),
    palette.surfaceAlt,
  );
}

@immutable
class MascotifyPalette extends ThemeExtension<MascotifyPalette> {
  const MascotifyPalette({
    required this.surfaceAlt,
    required this.surfaceTint,
    required this.primarySoft,
    required this.accentSoft,
    required this.supportSoft,
    required this.textMuted,
  });

  final Color surfaceAlt;
  final Color surfaceTint;
  final Color primarySoft;
  final Color accentSoft;
  final Color supportSoft;
  final Color textMuted;

  static MascotifyPalette of(BuildContext context) {
    final extension = Theme.of(context).extension<MascotifyPalette>();
    if (extension != null) return extension;
    return const MascotifyPalette(
      surfaceAlt: AppColors.surfaceAlt,
      surfaceTint: AppColors.surfaceTint,
      primarySoft: AppColors.primarySoft,
      accentSoft: AppColors.accentSoft,
      supportSoft: AppColors.supportSoft,
      textMuted: AppColors.textMuted,
    );
  }

  @override
  MascotifyPalette copyWith({
    Color? surfaceAlt,
    Color? surfaceTint,
    Color? primarySoft,
    Color? accentSoft,
    Color? supportSoft,
    Color? textMuted,
  }) {
    return MascotifyPalette(
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      primarySoft: primarySoft ?? this.primarySoft,
      accentSoft: accentSoft ?? this.accentSoft,
      supportSoft: supportSoft ?? this.supportSoft,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  @override
  MascotifyPalette lerp(ThemeExtension<MascotifyPalette>? other, double t) {
    if (other is! MascotifyPalette) return this;
    return MascotifyPalette(
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      supportSoft: Color.lerp(supportSoft, other.supportSoft, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
    );
  }
}
