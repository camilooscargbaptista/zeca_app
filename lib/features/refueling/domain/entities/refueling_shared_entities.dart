import 'package:equatable/equatable.dart';

/// Entidade compartilhada que representa um veículo no contexto de abastecimento
class RefuelingVehicleEntity extends Equatable {
  final String id;
  final String placa;
  final String modelo;
  final String marca;

  const RefuelingVehicleEntity({
    required this.id,
    required this.placa,
    required this.modelo,
    required this.marca,
  });

  @override
  List<Object?> get props => [id, placa, modelo, marca];
}

/// Entidade compartilhada que representa um posto de combustível no contexto de abastecimento
class RefuelingStationEntity extends Equatable {
  final String id;
  final String cnpj;
  final String nome;
  final String endereco;

  const RefuelingStationEntity({
    required this.id,
    required this.cnpj,
    required this.nome,
    required this.endereco,
  });

  @override
  List<Object?> get props => [id, cnpj, nome, endereco];
}

