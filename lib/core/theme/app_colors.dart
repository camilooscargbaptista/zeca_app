import 'package:flutter/material.dart';

class AppColors {
  // Cores do ZECA (baseadas no logo)
  static const Color zecaBlue = Color(0xFF2A70C0); // Azul do texto "zeca"
  static const Color zecaBlack = Color(0xFF000000); // Preto do fundo do logo
  static const Color zecaGreen = Color(0xFF28A745); // Verde do boné
  static const Color zecaOrange = Color(0xFFFF8C00); // Laranja para accents
  static const Color zecaWhite = Color(0xFFFFFFFF); // Branco dos detalhes
  static const Color zecaPurple = Color(0xFF673AB7); // Roxo para o card de boas-vindas
  
  // Cores primárias (baseadas no ZECA)
  static const Color primaryBlue = zecaBlue;
  static const Color primaryBlueDark = Color(0xFF1E5A9A);
  static const Color primaryBlueLight = Color(0xFFB3D1F0);
  
  // Cores secundárias (baseadas no ZECA)
  static const Color secondaryGreen = zecaGreen;
  static const Color secondaryOrange = zecaOrange;
  static const Color secondaryRed = Color(0xFFDC3545);
  
  // Cores de status (baseadas no ZECA)
  static const Color success = zecaGreen;
  static const Color warning = zecaOrange;
  static const Color error = Color(0xFFDC3545);
  static const Color info = zecaBlue;
  
  // Cores neutras
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // Cores de fundo
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  
  // Cores de texto
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFFE0E0E0);
  
  // Cores de borda
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderFocused = Color(0xFF2196F3);
  static const Color borderError = Color(0xFFF44336);
  static const Color borderSuccess = Color(0xFF4CAF50);
  
  // Cores de sombra
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowDark = Color(0x33000000);
  
  // Cores específicas do combustível
  static const Color fuelGreen = Color(0xFF28A745);
  static const Color fuelBlue = Color(0xFF007BFF);
  static const Color fuelOrange = Color(0xFFFF8C00);
  static const Color fuelRed = Color(0xFFDC3545);
}