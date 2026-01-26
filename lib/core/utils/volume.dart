import 'package:intl/intl.dart';

/// Classe utilitária para manipulação de volumes (litros) no ZECA.
/// 
/// Garante:
/// - Sempre 2 casas decimais para volumes
/// - Formatação consistente em todo o app
/// - Conversão segura de String/num para valores de volume
/// 
/// Uso:
/// ```dart
/// final liters = Volume.fromDynamic(json['quantity_liters']);
/// print(liters.formatted);       // 12,34 L
/// print(liters.value);           // 12.34
/// ```
class Volume {
  /// Valor em mililitros (evita problemas de ponto flutuante)
  final int _milliliters;

  /// Construtor privado - use os factory methods
  const Volume._(this._milliliters);

  /// Cria Volume a partir de um valor em litros (double)
  factory Volume.fromDouble(double value) {
    // Arredonda para 2 casas decimais e converte para mililitros
    final milliliters = (value * 100).round();
    return Volume._(milliliters);
  }

  /// Cria Volume a partir de um valor em mililitros (int)
  factory Volume.fromMilliliters(int milliliters) {
    return Volume._(milliliters);
  }

  /// Cria Volume a partir de qualquer tipo dinâmico (String, num, null)
  /// Útil para parsing de JSON onde o tipo pode variar
  factory Volume.fromDynamic(dynamic value) {
    if (value == null) return Volume.zero;
    
    if (value is int) {
      return Volume.fromDouble(value.toDouble());
    }
    
    if (value is double) {
      return Volume.fromDouble(value);
    }
    
    if (value is String) {
      // Remove caracteres não numéricos exceto ponto e vírgula
      final cleanValue = value
          .replaceAll('L', '')
          .replaceAll('l', '')
          .replaceAll(' ', '')
          .replaceAll('.', '') // Remove separador de milhar brasileiro
          .replaceAll(',', '.'); // Converte vírgula decimal para ponto
      
      final parsed = double.tryParse(cleanValue);
      if (parsed != null) {
        return Volume.fromDouble(parsed);
      }
      
      // Tenta parse direto para valores como "12.34"
      final directParsed = double.tryParse(value);
      if (directParsed != null) {
        return Volume.fromDouble(directParsed);
      }
    }
    
    return Volume.zero;
  }

  /// Valor zero
  static const Volume zero = Volume._(0);

  /// Retorna o valor como double com 2 casas decimais
  double get value => _milliliters / 100.0;

  /// Retorna o valor em mililitros
  int get milliliters => _milliliters;

  /// Retorna o valor formatado com sufixo L (ex: "12,34 L")
  String get formatted {
    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'pt_BR',
      decimalDigits: 2,
    );
    return '${formatter.format(value)} L';
  }

  /// Retorna o valor formatado sem sufixo (ex: "12,34")
  String get formattedWithoutSuffix {
    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'pt_BR',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  /// Retorna o valor como string com ponto decimal (para APIs)
  /// Ex: "12.34"
  String toApiString() {
    return value.toStringAsFixed(2);
  }

  /// Operadores matemáticos
  Volume operator +(Volume other) => Volume._(_milliliters + other._milliliters);
  Volume operator -(Volume other) => Volume._(_milliliters - other._milliliters);
  Volume operator *(num multiplier) => Volume._((_milliliters * multiplier).round());
  Volume operator /(num divisor) => Volume._((_milliliters / divisor).round());

  /// Comparadores
  bool operator <(Volume other) => _milliliters < other._milliliters;
  bool operator <=(Volume other) => _milliliters <= other._milliliters;
  bool operator >(Volume other) => _milliliters > other._milliliters;
  bool operator >=(Volume other) => _milliliters >= other._milliliters;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Volume && other._milliliters == _milliliters;
  }

  @override
  int get hashCode => _milliliters.hashCode;

  @override
  String toString() => formatted;
}

/// Extension para facilitar conversão de num para Volume
extension NumToVolume on num {
  Volume toVolume() => Volume.fromDouble(toDouble());
}

/// Extension para facilitar conversão de String para Volume
extension StringToVolume on String {
  Volume toVolume() => Volume.fromDynamic(this);
}
