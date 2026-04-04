import 'package:flutter/material.dart';
import 'package:spendora/core/theme/app_colors.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textMuted;
  final Color outline;
  final Color accentSoft;

  const AppThemeColors({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textMuted,
    required this.outline,
    required this.accentSoft,
  });

  const AppThemeColors.light()
      : background = AppColors.background,
        surface = AppColors.surface,
        textPrimary = AppColors.textPrimary,
        textMuted = AppColors.textMuted,
        outline = AppColors.outline,
        accentSoft = AppColors.accentSoft;

  const AppThemeColors.dark()
      : background = const Color(0xFF161A18),
        surface = const Color(0xFF202623),
        textPrimary = const Color(0xFFF5F1E8),
        textMuted = const Color(0xFFBAC3BD),
        outline = const Color(0xFF324039),
        accentSoft = const Color(0xFF2B3E37);

  @override
  AppThemeColors copyWith({
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textMuted,
    Color? outline,
    Color? accentSoft,
  }) {
    return AppThemeColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      outline: outline ?? this.outline,
      accentSoft: accentSoft ?? this.accentSoft,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }

    return AppThemeColors(
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      outline: Color.lerp(outline, other.outline, t) ?? outline,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t) ?? accentSoft,
    );
  }
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get appColors =>
      Theme.of(this).extension<AppThemeColors>() ?? const AppThemeColors.light();
}
