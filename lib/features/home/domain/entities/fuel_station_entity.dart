import 'package:equatable/equatable.dart';

class FuelStationEntity extends Equatable {
  final String id;
  final String cnpj;
  final String razaoSocial;
  final String nomeFantasia;
  final FuelStationAddressEntity endereco;
  final bool conveniado;
  final Map<String, double> precos;
  final List<String> servicos;
  final List<String> formasPagamento;
  final FuelStationContactEntity? contato;
  final double? avaliacao;
  final double? distanciaKm;
  final int? tempoEstimadoMin;
  final FuelStationScheduleEntity? horarioFuncionamento;
  final bool ativo;
  final DateTime? precosAtualizados;

  const FuelStationEntity({
    required this.id,
    required this.cnpj,
    required this.razaoSocial,
    required this.nomeFantasia,
    required this.endereco,
    required this.conveniado,
    required this.precos,
    required this.servicos,
    required this.formasPagamento,
    this.contato,
    this.avaliacao,
    this.distanciaKm,
    this.tempoEstimadoMin,
    this.horarioFuncionamento,
    required this.ativo,
    this.precosAtualizados,
  });

  @override
  List<Object?> get props => [
        id,
        cnpj,
        razaoSocial,
        nomeFantasia,
        endereco,
        conveniado,
        precos,
        servicos,
        formasPagamento,
        contato,
        avaliacao,
        distanciaKm,
        tempoEstimadoMin,
        horarioFuncionamento,
        ativo,
        precosAtualizados,
      ];
}

class FuelStationAddressEntity extends Equatable {
  final String logradouro;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cidade;
  final String uf;
  final String cep;
  final double latitude;
  final double longitude;

  const FuelStationAddressEntity({
    required this.logradouro,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.cep,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        logradouro,
        numero,
        complemento,
        bairro,
        cidade,
        uf,
        cep,
        latitude,
        longitude,
      ];

  String get enderecoCompleto {
    final parts = [
      logradouro,
      numero,
      if (complemento != null) complemento,
      bairro,
      '$cidade/$uf',
    ];
    return parts.join(', ');
  }
}

class FuelStationContactEntity extends Equatable {
  final String? telefone;
  final String? email;

  const FuelStationContactEntity({
    this.telefone,
    this.email,
  });

  @override
  List<Object?> get props => [telefone, email];
}

class FuelStationScheduleEntity extends Equatable {
  final String? segundaSexta;
  final String? sabado;
  final String? domingo;

  const FuelStationScheduleEntity({
    this.segundaSexta,
    this.sabado,
    this.domingo,
  });

  @override
  List<Object?> get props => [segundaSexta, sabado, domingo];
}
