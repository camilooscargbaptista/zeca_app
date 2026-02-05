import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formatter para campos de entrada monetária em BRL.
/// 
/// Características:
/// - Aceita apenas números
/// - Formata automaticamente como moeda brasileira (ex: 1.099,00)
/// - Sempre mantém 2 casas decimais
/// - Remove formatação anterior e reaplica a cada keystroke
///
/// Uso:
/// ```dart
/// TextFormField(
///   inputFormatters: [CurrencyInputFormatter()],
///   keyboardType: TextInputType.number,
/// )
/// ```
class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: '',
    decimalDigits: 2,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Se estiver vazio, retorna vazio
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove tudo que não é dígito
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Se não houver dígitos, retorna o valor antigo
    if (digitsOnly.isEmpty) {
      return oldValue;
    }

    // Converte para double dividindo por 100 (para ter 2 casas decimais)
    double value = double.parse(digitsOnly) / 100;
    
    // Formata o valor
    String formatted = _formatter.format(value).trim();
    
    // Retorna com cursor no final
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Extension para extrair valor numérico de texto formatado
extension CurrencyParsing on String {
  /// Converte texto formatado como moeda para double
  /// Ex: "1.099,50" -> 1099.50
  double toCurrencyDouble() {
    if (isEmpty) return 0.0;
    
    // Remove separadores de milhar e troca vírgula por ponto
    String cleaned = replaceAll('.', '').replaceAll(',', '.');
    
    return double.tryParse(cleaned) ?? 0.0;
  }
}
