import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Material 3 ThemeData wired to QuantumPips' design system.
///
/// Use as `theme: AppTheme.light()` / `darkTheme: AppTheme.dark()` on the
/// root MaterialApp.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnDark,
      secondary: AppColors.primaryAccent,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.loss,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: AppColors.textOnDark,
          textStyle: AppTypography.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          textStyle: AppTypography.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          side: const BorderSide(color: AppColors.surfaceBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
      ),
      dividerColor: AppColors.surfaceBorder,
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: const BorderSide(color: AppColors.surfaceBorder),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryAccent,
      brightness: Brightness.dark,
      primary: AppColors.primaryAccent,
      onPrimary: AppColors.textOnDark,
      secondary: AppColors.primaryHover,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textOnDark,
      error: AppColors.loss,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surfaceDark,
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.textOnDark),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.textOnDark),
        displaySmall: AppTypography.displaySmall.copyWith(color: AppColors.textOnDark),
        headlineLarge: AppTypography.headlineLarge.copyWith(color: AppColors.textOnDark),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: AppColors.textOnDark),
        headlineSmall: AppTypography.headlineSmall.copyWith(color: AppColors.textOnDark),
        titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.textOnDark),
        titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.textOnDark),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textOnDarkMuted),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textOnDarkMuted),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.textOnDarkMuted),
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),
    );
  }
}
