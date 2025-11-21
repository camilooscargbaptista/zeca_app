import 'package:equatable/equatable.dart';
import 'refueling_shared_entities.dart';

class RefuelingCodeEntity extends Equatable {
  final String id;
  final String codigo;
  final String qrCode;
  final RefuelingVehicleEntity veiculo;
  final RefuelingStationEntity posto;
  final RefuelingDataEntity dadosAbastecimento;
  final RefuelingValidityEntity validade;
  final String status;
  final DateTime geradoEm;
  final RefuelingUserEntity geradoPor;

  const RefuelingCodeEntity({
    required this.id,
    required this.codigo,
    required this.qrCode,
    required this.veiculo,
    required this.posto,
    required this.dadosAbastecimento,
    required this.validade,
    required this.status,
    required this.geradoEm,
    required this.geradoPor,
  });

  @override
  List<Object?> get props => [
        id,
        codigo,
        qrCode,
        veiculo,
        posto,
        dadosAbastecimento,
        validade,
        status,
        geradoEm,
        geradoPor,
      ];
}

class RefuelingDataEntity extends Equatable {
  final String combustivel;
  final double precoLitro;
  final double quantidadeMaxima;
  final double valorMaximo;
  final int kmRegistrado;
  final bool abastecerArla;
  final double? precoArla;

  const RefuelingDataEntity({
    required this.combustivel,
    required this.precoLitro,
    required this.quantidadeMaxima,
    required this.valorMaximo,
    required this.kmRegistrado,
    required this.abastecerArla,
    this.precoArla,
  });

  @override
  List<Object?> get props => [
        combustivel,
        precoLitro,
        quantidadeMaxima,
        valorMaximo,
        kmRegistrado,
        abastecerArla,
        precoArla,
      ];
}

class RefuelingValidityEntity extends Equatable {
  final DateTime validoAte;
  final int tempoRestanteMinutos;

  const RefuelingValidityEntity({
    required this.validoAte,
    required this.tempoRestanteMinutos,
  });

  @override
  List<Object?> get props => [validoAte, tempoRestanteMinutos];
}

class RefuelingUserEntity extends Equatable {
  final String id;
  final String nome;
  final String cpf;

  const RefuelingUserEntity({
    required this.id,
    required this.nome,
    required this.cpf,
  });

  @override
  List<Object?> get props => [id, nome, cpf];
}
