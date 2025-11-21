import 'package:equatable/equatable.dart';

class RefuelingDataEntity extends Equatable {
  final String veiculoId;
  final String veiculoPlaca;
  final int kmAtual;
  final String combustivel;
  final bool abastecerArla;
  final String? postoId;
  final String? postoCnpj;
  final String? observacoes;

  const RefuelingDataEntity({
    required this.veiculoId,
    required this.veiculoPlaca,
    required this.kmAtual,
    required this.combustivel,
    required this.abastecerArla,
    this.postoId,
    this.postoCnpj,
    this.observacoes,
  });

  RefuelingDataEntity copyWith({
    String? veiculoId,
    String? veiculoPlaca,
    int? kmAtual,
    String? combustivel,
    bool? abastecerArla,
    String? postoId,
    String? postoCnpj,
    String? observacoes,
  }) {
    return RefuelingDataEntity(
      veiculoId: veiculoId ?? this.veiculoId,
      veiculoPlaca: veiculoPlaca ?? this.veiculoPlaca,
      kmAtual: kmAtual ?? this.kmAtual,
      combustivel: combustivel ?? this.combustivel,
      abastecerArla: abastecerArla ?? this.abastecerArla,
      postoId: postoId ?? this.postoId,
      postoCnpj: postoCnpj ?? this.postoCnpj,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  @override
  List<Object?> get props => [
        veiculoId,
        veiculoPlaca,
        kmAtual,
        combustivel,
        abastecerArla,
        postoId,
        postoCnpj,
        observacoes,
      ];
}
