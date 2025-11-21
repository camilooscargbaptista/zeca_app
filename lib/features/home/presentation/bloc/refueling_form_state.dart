part of 'refueling_form_bloc.dart';

abstract class RefuelingFormState extends Equatable {
  const RefuelingFormState();

  RefuelingDataEntity get refuelingData => const RefuelingDataEntity(
        veiculoId: '',
        veiculoPlaca: '',
        kmAtual: 0,
        combustivel: 'diesel',
        abastecerArla: false,
      );

  @override
  List<Object?> get props => [];
}

class RefuelingFormInitial extends RefuelingFormState {
  const RefuelingFormInitial();

  @override
  RefuelingDataEntity get refuelingData => const RefuelingDataEntity(
        veiculoId: '',
        veiculoPlaca: '',
        kmAtual: 0,
        combustivel: 'diesel',
        abastecerArla: false,
      );
}

class RefuelingFormUpdated extends RefuelingFormState {
  final RefuelingDataEntity refuelingData;

  const RefuelingFormUpdated(this.refuelingData);

  @override
  List<Object?> get props => [refuelingData];
}
