import 'package:flutter/services.dart';
import 'dart:math';

/// Formatter para campo de KM com formato xxxxxx,xxx
/// Formata automaticamente: 1234 -> 1,234 | 123456789 -> 123456,789
/// Sem separador de milhar, apenas vírgula para decimais (3 casas)
class KmFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Se o novo valor está vazio, retornar vazio
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remover todos os caracteres não numéricos
    String oldDigitsOnly = oldValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String newDigitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Se não há dígitos, retornar vazio
    if (newDigitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Se os dígitos não mudaram (apenas formatação), manter posição do cursor
    if (oldDigitsOnly == newDigitsOnly) {
      return oldValue;
    }

    // Calcular posição do cursor ANTES da formatação
    // Contar quantos dígitos existem antes do cursor na string antiga
    int oldCursorPosition = oldValue.selection.baseOffset;
    int digitsBeforeCursor = 0;
    for (int i = 0; i < min(oldCursorPosition, oldValue.text.length); i++) {
      if (RegExp(r'[0-9]').hasMatch(oldValue.text[i])) {
        digitsBeforeCursor++;
      }
    }

    // Se está deletando, ajustar
    if (newDigitsOnly.length < oldDigitsOnly.length) {
      // Backspace/Delete: manter posição relativa
      digitsBeforeCursor = min(digitsBeforeCursor, newDigitsOnly.length);
    } else {
      // Inserindo: incrementar posição
      digitsBeforeCursor = min(digitsBeforeCursor + 1, newDigitsOnly.length);
    }

    // Formatar com vírgula para decimais (últimos 3 dígitos são decimais)
    String formatted = _formatWithDecimalComma(newDigitsOnly);

    // Encontrar posição do cursor na string formatada
    int selectionIndex = 0;
    int digitCount = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(formatted[i])) {
        digitCount++;
        if (digitCount > digitsBeforeCursor) {
          selectionIndex = i;
          break;
        }
      }
    }
    
    // Se não encontrou, colocar no final
    if (digitCount <= digitsBeforeCursor) {
      selectionIndex = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  /// Formata número com vírgula para decimais (3 casas)
  /// Exemplo: 1234 -> 1,234 | 123456789 -> 123456,789
  String _formatWithDecimalComma(String digits) {
    // Garantir pelo menos 4 dígitos (para ter 3 casas decimais)
    if (digits.length < 4) {
      digits = digits.padLeft(4, '0');
    }
    
    // Separar parte inteira e decimal (últimos 3 dígitos são decimais)
    String decimalPart = digits.substring(digits.length - 3);
    String integerPart = digits.substring(0, digits.length - 3);
    
    // Remover zeros à esquerda da parte inteira (mas manter pelo menos um zero)
    integerPart = integerPart.replaceAll(RegExp(r'^0+'), '');
    if (integerPart.isEmpty) {
      integerPart = '0';
    }
    
    // Formatar: parte inteira + vírgula + parte decimal
    return '$integerPart,$decimalPart';
  }

  /// Remove formatação e retorna apenas os dígitos
  static String unformat(String formatted) {
    return formatted.replaceAll(RegExp(r'[^0-9]'), '');
  }
}

