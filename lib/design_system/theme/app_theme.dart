import 'package:clean_riverpod_starter/design_system/tokens/ds_colors.dart';
import 'package:clean_riverpod_starter/design_system/tokens/ds_radii.dart';
import 'package:clean_riverpod_starter/design_system/tokens/ds_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: DsColors.c00796B,
      error: DsColors.cBA1A1A,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: const TextTheme(
        titleLarge: DsTypography.titleLarge,
        titleMedium: DsTypography.titleMedium,
        bodyLarge: DsTypography.bodyLarge,
        bodyMedium: DsTypography.bodyMedium,
        bodySmall: DsTypography.bodySmall,
        labelLarge: DsTypography.labelLarge,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: DsRadii.md),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: DsRadii.md),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: const CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: DsRadii.md),
      ),
    );
  }
}
