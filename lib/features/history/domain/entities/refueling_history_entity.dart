import 'package:equatable/equatable.dart';

/// Entity que representa um item do histórico de abastecimentos
class RefuelingHistoryEntity extends Equatable {
  final String id;
  final String refuelingCode;
  final DateTime refuelingDatetime;
  final String stationName;
  final String vehiclePlate;
  final String fuelType;
  final double quantityLiters;
  final double totalAmount;
  final String status;
  final bool isAutonomous;
  final String? paymentMethod;
  final double unitPrice;
  final bool hasNfe;

  const RefuelingHistoryEntity({
    required this.id,
    required this.refuelingCode,
    required this.refuelingDatetime,
    required this.stationName,
    required this.vehiclePlate,
    required this.fuelType,
    required this.quantityLiters,
    required this.totalAmount,
    required this.status,
    required this.isAutonomous,
    this.paymentMethod,
    required this.unitPrice,
    required this.hasNfe,
  });

  @override
  List<Object?> get props => [
        id,
        refuelingCode,
        refuelingDatetime,
        stationName,
        vehiclePlate,
        fuelType,
        quantityLiters,
        totalAmount,
        status,
        isAutonomous,
        paymentMethod,
        unitPrice,
        hasNfe,
      ];

  /// Verifica se está concluído
  bool get isConcluido => status == 'CONCLUIDO';

  /// Verifica se está pendente
  bool get isPendente => status == 'PENDENTE' || status == 'AGUARDANDO_VALIDACAO_MOTORISTA';

  /// Verifica se foi cancelado
  bool get isCancelado => status == 'CANCELADO';

  /// Retorna o label do status formatado
  String get statusLabel {
    switch (status) {
      case 'CONCLUIDO':
        return 'Concluído';
      case 'PENDENTE':
        return 'Pendente';
      case 'AGUARDANDO_VALIDACAO_MOTORISTA':
        return 'Aguardando Validação';
      case 'AGUARDANDO_NFE':
        return 'Aguardando NFE';
      case 'VALIDADO':
        return 'Validado';
      case 'CANCELADO':
        return 'Cancelado';
      case 'CONTESTADO':
        return 'Contestado';
      default:
        return status;
    }
  }
}

/// Entity para o resumo/totalizadores do histórico
class HistorySummaryEntity extends Equatable {
  final double totalValue;
  final double totalLiters;
  final int totalRefuelings;
  final double averagePricePerLiter;

  const HistorySummaryEntity({
    required this.totalValue,
    required this.totalLiters,
    required this.totalRefuelings,
    required this.averagePricePerLiter,
  });

  @override
  List<Object?> get props => [
        totalValue,
        totalLiters,
        totalRefuelings,
        averagePricePerLiter,
      ];

  /// Cria um summary a partir de uma lista de abastecimentos
  factory HistorySummaryEntity.fromRefuelings(List<RefuelingHistoryEntity> refuelings) {
    if (refuelings.isEmpty) {
      return const HistorySummaryEntity(
        totalValue: 0,
        totalLiters: 0,
        totalRefuelings: 0,
        averagePricePerLiter: 0,
      );
    }

    final totalValue = refuelings.fold<double>(0, (sum, r) => sum + r.totalAmount);
    final totalLiters = refuelings.fold<double>(0, (sum, r) => sum + r.quantityLiters);
    final totalRefuelings = refuelings.length;
    final averagePricePerLiter = totalLiters > 0 ? totalValue / totalLiters : 0.0;

    return HistorySummaryEntity(
      totalValue: totalValue,
      totalLiters: totalLiters,
      totalRefuelings: totalRefuelings,
      averagePricePerLiter: averagePricePerLiter,
    );
  }
}

/// Entity para filtros do histórico
class HistoryFiltersEntity extends Equatable {
  final String? vehiclePlate;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  const HistoryFiltersEntity({
    this.vehiclePlate,
    this.startDate,
    this.endDate,
    this.status,
  });

  @override
  List<Object?> get props => [vehiclePlate, startDate, endDate, status];

  /// Cria uma cópia com novos valores
  HistoryFiltersEntity copyWith({
    String? vehiclePlate,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    bool clearVehiclePlate = false,
    bool clearStatus = false,
  }) {
    return HistoryFiltersEntity(
      vehiclePlate: clearVehiclePlate ? null : (vehiclePlate ?? this.vehiclePlate),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  /// Verifica se há algum filtro aplicado
  bool get hasFilters =>
      vehiclePlate != null || startDate != null || endDate != null || status != null;

  /// Limpa todos os filtros
  HistoryFiltersEntity clear() => const HistoryFiltersEntity();
}
