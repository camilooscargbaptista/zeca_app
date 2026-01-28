import 'package:flutter/services.dart';

/// Formatter para campo de Odômetro com formato brasileiro: 123.456
/// Formata automaticamente enquanto o usuário digita (apenas inteiros)
/// Limite máximo: 6 dígitos (999.999 km)
/// Exemplo: 123456 -> 123.456
class OdometerFormatter extends TextInputFormatter {
  /// Número máximo de dígitos permitidos (odômetro padrão = 6 dígitos)
  static const int maxDigits = 6;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Se o novo valor está vazio, retornar vazio
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Remover todos os caracteres não numéricos
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Se não há dígitos, retornar vazio
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Limitar a quantidade máxima de dígitos
    if (digitsOnly.length > maxDigits) {
      digitsOnly = digitsOnly.substring(0, maxDigits);
    }

    // Remover zeros à esquerda (exceto se for só zeros)
    digitsOnly = digitsOnly.replaceFirst(RegExp(r'^0+'), '');
    if (digitsOnly.isEmpty) digitsOnly = '0';

    // Formatar com separador de milhar (ponto)
    String formatted = _formatWithThousandSeparator(digitsOnly);

    // Cursor simples: sempre no final
    // Isso evita bugs de posicionamento complexos
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Adiciona separador de milhar (ponto) a cada 3 dígitos
  String _formatWithThousandSeparator(String number) {
    if (number.isEmpty || number == '0') {
      return '0';
    }

    // Usar regex para adicionar ponto a cada 3 dígitos da direita para esquerda
    return number.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)}.',
    );
  }

  /// Converte valor formatado (123.456) para número inteiro (123456)
  static int parseFormattedValue(String formattedValue) {
    if (formattedValue.isEmpty) return 0;
    
    // Remover todos os caracteres não numéricos
    String digitsOnly = formattedValue.replaceAll(RegExp(r'[^0-9]'), '');
    
    return int.tryParse(digitsOnly) ?? 0;
  }

  /// Converte número inteiro para formato exibido (123456 -> 123.456)
  static String formatValue(int value) {
    if (value == 0) return '0';
    
    String digits = value.toString();
    
    // Formatar apenas com separador de milhar (sem decimais)
    return digits.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)}.',
    );
  }
}
