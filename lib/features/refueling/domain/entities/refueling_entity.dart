import 'package:equatable/equatable.dart';
import 'document_entity.dart';
import 'refueling_shared_entities.dart';

class RefuelingEntity extends Equatable {
  final String id;
  final String codigo;
  final String status;
  final RefuelingVehicleEntity veiculo;
  final RefuelingStationEntity posto;
  final RefuelingFinalDataEntity dadosAbastecimento;
  final DateTime? finalizadoEm;
  final RefuelingUserEntity? finalizadoPor;
  final List<DocumentEntity> comprovantes;
  final String? motivoCancelamento;
  final DateTime? canceladoEm;
  final RefuelingUserEntity? canceladoPor;

  const RefuelingEntity({
    required this.id,
    required this.codigo,
    required this.status,
    required this.veiculo,
    required this.posto,
    required this.dadosAbastecimento,
    this.finalizadoEm,
    this.finalizadoPor,
    required this.comprovantes,
    this.motivoCancelamento,
    this.canceladoEm,
    this.canceladoPor,
  });

  @override
  List<Object?> get props => [
        id,
        codigo,
        status,
        veiculo,
        posto,
        dadosAbastecimento,
        finalizadoEm,
        finalizadoPor,
        comprovantes,
        motivoCancelamento,
        canceladoEm,
        canceladoPor,
      ];

  bool get isAtivo => status == 'ativo';
  bool get isFinalizado => status == 'finalizado';
  bool get isCancelado => status == 'cancelado';
  bool get isExpirado => status == 'expirado';
}

class RefuelingFinalDataEntity extends Equatable {
  final double quantidadeLitros;
  final double valorTotal;
  final int kmFinal;
  final double? quantidadeArla;
  final double? valorArla;
  final double valorTotalGeral;
  final String? observacoes;

  const RefuelingFinalDataEntity({
    required this.quantidadeLitros,
    required this.valorTotal,
    required this.kmFinal,
    this.quantidadeArla,
    this.valorArla,
    required this.valorTotalGeral,
    this.observacoes,
  });

  @override
  List<Object?> get props => [
        quantidadeLitros,
        valorTotal,
        kmFinal,
        quantidadeArla,
        valorArla,
        valorTotalGeral,
        observacoes,
      ];
}

class RefuelingUserEntity extends Equatable {
  final String id;
  final String nome;

  const RefuelingUserEntity({
    required this.id,
    required this.nome,
  });

  @override
  List<Object?> get props => [id, nome];
}
