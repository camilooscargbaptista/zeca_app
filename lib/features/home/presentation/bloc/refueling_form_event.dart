part of 'refueling_form_bloc.dart';

abstract class RefuelingFormEvent extends Equatable {
  const RefuelingFormEvent();

  @override
  List<Object?> get props => [];
}

class UpdateRefuelingData extends RefuelingFormEvent {
  final String? veiculoId;
  final String? veiculoPlaca;
  final int? kmAtual;
  final String? combustivel;
  final bool? abastecerArla;
  final String? postoId;
  final String? postoCnpj;
  final String? observacoes;

  const UpdateRefuelingData({
    this.veiculoId,
    this.veiculoPlaca,
    this.kmAtual,
    this.combustivel,
    this.abastecerArla,
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

class SelectFuelType extends RefuelingFormEvent {
  final String fuelType;

  const SelectFuelType(this.fuelType);

  @override
  List<Object?> get props => [fuelType];
}

class SelectStation extends RefuelingFormEvent {
  final FuelStationEntity station;

  const SelectStation(this.station);

  @override
  List<Object?> get props => [station];
}

class UpdateKm extends RefuelingFormEvent {
  final int km;

  const UpdateKm(this.km);

  @override
  List<Object?> get props => [km];
}

class ToggleArla extends RefuelingFormEvent {
  final bool enabled;

  const ToggleArla(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ClearForm extends RefuelingFormEvent {
  const ClearForm();
}
