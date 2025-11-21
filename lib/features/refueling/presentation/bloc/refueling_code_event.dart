part of 'refueling_code_bloc.dart';

abstract class RefuelingCodeEvent extends Equatable {
  const RefuelingCodeEvent();

  @override
  List<Object?> get props => [];
}

class GenerateRefuelingCode extends RefuelingCodeEvent {
  final String veiculoId;
  final String veiculoPlaca;
  final int kmAtual;
  final String combustivel;
  final bool abastecerArla;
  final String? postoId;
  final String? postoCnpj;
  final String? observacoes;

  const GenerateRefuelingCode({
    required this.veiculoId,
    required this.veiculoPlaca,
    required this.kmAtual,
    required this.combustivel,
    required this.abastecerArla,
    this.postoId,
    this.postoCnpj,
    this.observacoes,
  });

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

class ValidateRefuelingCode extends RefuelingCodeEvent {
  final String codigo;

  const ValidateRefuelingCode(this.codigo);

  @override
  List<Object?> get props => [codigo];
}

class ClearRefuelingCode extends RefuelingCodeEvent {
  const ClearRefuelingCode();
}
