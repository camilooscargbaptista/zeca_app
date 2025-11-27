import 'package:flutter/services.dart';

/// Formatter para campo de Odômetro com formato brasileiro: 123.456
/// Formata automaticamente enquanto o usuário digita (apenas inteiros)
/// Exemplo: 123456 -> 123.456
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

    // Formatar com separador de milhar (ponto) - apenas inteiros
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

  /// Formata o número com separador de milhar: 123.456
  String _formatOdometer(String digits) {
    // Formatar apenas como número inteiro com separador de milhar
    return _formatWithThousandSeparator(digits.isEmpty ? '0' : digits);
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

