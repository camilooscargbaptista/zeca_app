import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_colors.dart';

class BrandATheme {
  static ThemeData get theme {
    return AppTheme.lightTheme.copyWith(
      // Personalizações específicas da marca A
      colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
        primary: AppColors.primaryBlue,
        secondary: AppColors.fuelGreen,
      ),
      
      // AppBar personalizada
      appBarTheme: AppTheme.lightTheme.appBarTheme.copyWith(
        backgroundColor: AppColors.primaryBlue,
        titleTextStyle: AppTheme.lightTheme.appBarTheme.titleTextStyle?.copyWith(
          color: AppColors.white,
        ),
      ),
      
      // Botões personalizados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStateProperty.all(AppColors.primaryBlue),
        ),
      ),
    );
  }
}
