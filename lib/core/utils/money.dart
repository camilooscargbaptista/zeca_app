import 'package:intl/intl.dart';

/// Classe utilitária para manipulação de valores monetários no ZECA.
/// 
/// Garante:
/// - Sempre 2 casas decimais para valores em BRL
/// - Formatação consistente em todo o app
/// - Conversão segura de String/num para valores monetários
/// 
/// Uso:
/// ```dart
/// final price = Money.fromDynamic(json['total_amount']);
/// print(price.formatted); // R$ 72,68
/// print(price.value);     // 72.68
/// ```
class Money {
  /// Valor em centavos (evita problemas de ponto flutuante)
  final int _cents;

  /// Construtor privado - use os factory methods
  const Money._(this._cents);

  /// Cria Money a partir de um valor em reais (double)
  factory Money.fromDouble(double value) {
    // Arredonda para 2 casas decimais e converte para centavos
    final cents = (value * 100).round();
    return Money._(cents);
  }

  /// Cria Money a partir de um valor em centavos (int)
  factory Money.fromCents(int cents) {
    return Money._(cents);
  }

  /// Cria Money a partir de qualquer tipo dinâmico (String, num, null)
  /// Útil para parsing de JSON onde o tipo pode variar
  factory Money.fromDynamic(dynamic value) {
    if (value == null) return Money.zero;
    
    if (value is int) {
      // Se for int, assume que já é o valor em reais
      return Money.fromDouble(value.toDouble());
    }
    
    if (value is double) {
      return Money.fromDouble(value);
    }
    
    if (value is String) {
      // Remove caracteres não numéricos exceto ponto e vírgula
      final cleanValue = value
          .replaceAll('R\$', '')
          .replaceAll(' ', '')
          .replaceAll('.', '') // Remove separador de milhar brasileiro
          .replaceAll(',', '.'); // Converte vírgula decimal para ponto
      
      final parsed = double.tryParse(cleanValue);
      if (parsed != null) {
        return Money.fromDouble(parsed);
      }
      
      // Tenta parse direto para valores como "72.68"
      final directParsed = double.tryParse(value);
      if (directParsed != null) {
        return Money.fromDouble(directParsed);
      }
    }
    
    return Money.zero;
  }

  /// Valor zero
  static const Money zero = Money._(0);

  /// Retorna o valor como double com 2 casas decimais
  double get value => _cents / 100.0;

  /// Retorna o valor em centavos
  int get cents => _cents;

  /// Retorna o valor formatado em BRL (ex: "R$ 72,68")
  String get formatted {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  /// Retorna o valor formatado sem símbolo (ex: "72,68")
  String get formattedWithoutSymbol {
    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'pt_BR',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  /// Retorna o valor como string com ponto decimal (para APIs)
  /// Ex: "72.68"
  String toApiString() {
    return value.toStringAsFixed(2);
  }

  /// Operadores matemáticos
  Money operator +(Money other) => Money._(_cents + other._cents);
  Money operator -(Money other) => Money._(_cents - other._cents);
  Money operator *(num multiplier) => Money._((_cents * multiplier).round());
  Money operator /(num divisor) => Money._((_cents / divisor).round());

  /// Comparadores
  bool operator <(Money other) => _cents < other._cents;
  bool operator <=(Money other) => _cents <= other._cents;
  bool operator >(Money other) => _cents > other._cents;
  bool operator >=(Money other) => _cents >= other._cents;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Money && other._cents == _cents;
  }

  @override
  int get hashCode => _cents.hashCode;

  @override
  String toString() => formatted;
}

/// Extension para facilitar conversão de num para Money
extension NumToMoney on num {
  Money toMoney() => Money.fromDouble(toDouble());
}

/// Extension para facilitar conversão de String para Money
extension StringToMoney on String {
  Money toMoney() => Money.fromDynamic(this);
}
