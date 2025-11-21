import 'package:equatable/equatable.dart';

class VehicleEntity extends Equatable {
  final String id;
  final String placa;
  final String modelo;
  final String marca;
  final int ano;
  final String cor;
  final List<String> combustiveis;
  final int ultimoKm;
  final DateTime? ultimoAbastecimento;
  final VehicleSpecsEntity especificacoes;
  final VehicleInsuranceEntity? seguro;
  final String empresaId;
  final String empresaNome;
  final bool ativo;
  final DateTime criadoEm;

  const VehicleEntity({
    required this.id,
    required this.placa,
    required this.modelo,
    required this.marca,
    required this.ano,
    required this.cor,
    required this.combustiveis,
    required this.ultimoKm,
    this.ultimoAbastecimento,
    required this.especificacoes,
    this.seguro,
    required this.empresaId,
    required this.empresaNome,
    required this.ativo,
    required this.criadoEm,
  });

  @override
  List<Object?> get props => [
        id,
        placa,
        modelo,
        marca,
        ano,
        cor,
        combustiveis,
        ultimoKm,
        ultimoAbastecimento,
        especificacoes,
        seguro,
        empresaId,
        empresaNome,
        ativo,
        criadoEm,
      ];
}

class VehicleSpecsEntity extends Equatable {
  final double capacidadeTanque;
  final double? consumoMedio;
  final String? transmissao;
  final int? eixos;
  final double? pesoBruto;

  const VehicleSpecsEntity({
    required this.capacidadeTanque,
    this.consumoMedio,
    this.transmissao,
    this.eixos,
    this.pesoBruto,
  });

  @override
  List<Object?> get props => [
        capacidadeTanque,
        consumoMedio,
        transmissao,
        eixos,
        pesoBruto,
      ];
}

class VehicleInsuranceEntity extends Equatable {
  final String seguradora;
  final String apolice;
  final DateTime vencimento;

  const VehicleInsuranceEntity({
    required this.seguradora,
    required this.apolice,
    required this.vencimento,
  });

  @override
  List<Object?> get props => [seguradora, apolice, vencimento];
}
