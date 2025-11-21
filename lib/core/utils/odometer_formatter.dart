import 'package:flutter/services.dart';

/// Formatter para campo de Odômetro com formato brasileiro: 123.456,789
/// Formata automaticamente enquanto o usuário digita
/// Exemplo: 123456789 -> 123.456,789
class OdometerFormatter extends TextInputFormatter {
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

    // Formatar com separador de milhar (ponto) e vírgula para decimais
    String formatted = _formatOdometer(digitsOnly);

    // Calcular posição do cursor
    int cursorPosition = _calculateCursorPosition(
      oldValue,
      newValue,
      formatted,
      digitsOnly,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  /// Formata o número com separadores: 123.456,789
  String _formatOdometer(String digits) {
    // Se há menos de 4 dígitos, não forçar decimais ainda
    if (digits.length < 4) {
      // Formatar apenas como número inteiro com separador de milhar
      return _formatWithThousandSeparator(digits.isEmpty ? '0' : digits);
    }

    // Separar parte inteira e decimal (últimos 3 dígitos são decimais)
    String decimalPart = digits.substring(digits.length - 3);
    String integerPart = digits.substring(0, digits.length - 3);

    // Se parte inteira está vazia, usar "0"
    if (integerPart.isEmpty) {
      integerPart = '0';
    }

    // Formatar parte inteira com separador de milhar (ponto)
    String formattedInteger = _formatWithThousandSeparator(integerPart);

    // Combinar: parte inteira + vírgula + parte decimal
    return '$formattedInteger,$decimalPart';
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

  /// Calcula a posição correta do cursor após formatação
  int _calculateCursorPosition(
    TextEditingValue oldValue,
    TextEditingValue newValue,
    String formatted,
    String digitsOnly,
  ) {
    String oldDigits = oldValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    int oldCursor = oldValue.selection.baseOffset;
    int newCursor = newValue.selection.baseOffset;
    
    // Contar quantos dígitos existem antes do cursor no texto antigo
    int digitsBeforeOldCursor = _countDigitsBeforePosition(oldValue.text, oldCursor);
    
    // Se está deletando
    if (digitsOnly.length < oldDigits.length) {
      // Backspace/Delete: manter posição relativa
      int targetDigits = digitsBeforeOldCursor > digitsOnly.length 
          ? digitsOnly.length 
          : (digitsBeforeOldCursor > 0 ? digitsBeforeOldCursor - 1 : 0);
      return _findPositionAfterDigits(formatted, targetDigits);
    } else if (digitsOnly.length > oldDigits.length) {
      // Inserindo: posição após o último dígito inserido
      int digitsBeforeNewCursor = _countDigitsBeforePosition(newValue.text, newCursor);
      return _findPositionAfterDigits(formatted, digitsBeforeNewCursor);
    } else {
      // Mesmo número de dígitos (apenas formatação ou substituição)
      // Manter posição relativa baseada nos dígitos antes do cursor
      return _findPositionAfterDigits(formatted, digitsBeforeOldCursor);
    }
  }

  /// Conta quantos dígitos existem antes de uma posição específica
  int _countDigitsBeforePosition(String text, int position) {
    int count = 0;
    for (int i = 0; i < position && i < text.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(text[i])) {
        count++;
      }
    }
    return count;
  }

  /// Encontra a posição do cursor após N dígitos na string formatada
  int _findPositionAfterDigits(String formatted, int digitCount) {
    if (digitCount <= 0) {
      return 0;
    }
    
    int digitsFound = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(formatted[i])) {
        digitsFound++;
        if (digitsFound == digitCount) {
          // Retornar posição após este dígito
          return i + 1;
        }
      }
    }
    // Se não encontrou todos os dígitos, retornar o final
    return formatted.length;
  }

  /// Converte valor formatado (123.456,789) para número inteiro (123456789)
  static int parseFormattedValue(String formattedValue) {
    if (formattedValue.isEmpty) return 0;
    
    // Remover todos os caracteres não numéricos
    String digitsOnly = formattedValue.replaceAll(RegExp(r'[^0-9]'), '');
    
    return int.tryParse(digitsOnly) ?? 0;
  }

  /// Converte número inteiro para formato exibido (123456789 -> 123.456,789)
  static String formatValue(int value) {
    if (value == 0) return '0,000';
    
    String digits = value.toString();
    
    // Garantir pelo menos 4 dígitos (para ter 3 casas decimais)
    if (digits.length < 4) {
      digits = digits.padLeft(4, '0');
    }
    
    // Separar parte inteira e decimal
    String decimalPart = digits.substring(digits.length - 3);
    String integerPart = digits.substring(0, digits.length - 3);
    
    if (integerPart.isEmpty) integerPart = '0';
    
    // Formatar parte inteira com separador de milhar
    String formattedInteger = integerPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)}.',
    );
    
    return '$formattedInteger,$decimalPart';
  }
}

