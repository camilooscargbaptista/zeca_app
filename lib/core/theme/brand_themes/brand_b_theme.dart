import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_colors.dart';

class BrandBTheme {
  static ThemeData get theme {
    return AppTheme.lightTheme.copyWith(
      // Personalizações específicas da marca B (vermelho)
      colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
        primary: const Color(0xFFE74C3C), // Vermelho
        secondary: const Color(0xFFC0392B), // Vermelho escuro
      ),
      
      // AppBar personalizada
      appBarTheme: AppTheme.lightTheme.appBarTheme.copyWith(
        backgroundColor: const Color(0xFFE74C3C),
        titleTextStyle: AppTheme.lightTheme.appBarTheme.titleTextStyle?.copyWith(
          color: AppColors.white,
        ),
      ),
      
      // Botões personalizados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFE74C3C)),
        ),
      ),
    );
  }
}
