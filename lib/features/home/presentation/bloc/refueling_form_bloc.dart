import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/refueling_data_entity.dart';
import '../../domain/entities/fuel_station_entity.dart';

part 'refueling_form_event.dart';
part 'refueling_form_state.dart';

@injectable
class RefuelingFormBloc extends Bloc<RefuelingFormEvent, RefuelingFormState> {
  RefuelingFormBloc() : super(const RefuelingFormInitial()) {
    on<UpdateRefuelingData>(_onUpdateRefuelingData);
    on<SelectFuelType>(_onSelectFuelType);
    on<SelectStation>(_onSelectStation);
    on<UpdateKm>(_onUpdateKm);
    on<ToggleArla>(_onToggleArla);
    on<ClearForm>(_onClearForm);
  }

  void _onUpdateRefuelingData(
    UpdateRefuelingData event,
    Emitter<RefuelingFormState> emit,
  ) {
    final currentData = state.refuelingData;
    final updatedData = currentData.copyWith(
      veiculoId: event.veiculoId ?? currentData.veiculoId,
      veiculoPlaca: event.veiculoPlaca ?? currentData.veiculoPlaca,
      kmAtual: event.kmAtual ?? currentData.kmAtual,
      combustivel: event.combustivel ?? currentData.combustivel,
      abastecerArla: event.abastecerArla ?? currentData.abastecerArla,
      postoId: event.postoId ?? currentData.postoId,
      postoCnpj: event.postoCnpj ?? currentData.postoCnpj,
      observacoes: event.observacoes ?? currentData.observacoes,
    );

    emit(RefuelingFormUpdated(updatedData));
  }

  void _onSelectFuelType(
    SelectFuelType event,
    Emitter<RefuelingFormState> emit,
  ) {
    final currentData = state.refuelingData;
    final updatedData = currentData.copyWith(combustivel: event.fuelType);
    emit(RefuelingFormUpdated(updatedData));
  }

  void _onSelectStation(
    SelectStation event,
    Emitter<RefuelingFormState> emit,
  ) {
    final currentData = state.refuelingData;
    final updatedData = currentData.copyWith(
      postoId: event.station.id,
      postoCnpj: event.station.cnpj,
    );
    emit(RefuelingFormUpdated(updatedData));
  }

  void _onUpdateKm(
    UpdateKm event,
    Emitter<RefuelingFormState> emit,
  ) {
    final currentData = state.refuelingData;
    final updatedData = currentData.copyWith(kmAtual: event.km);
    emit(RefuelingFormUpdated(updatedData));
  }

  void _onToggleArla(
    ToggleArla event,
    Emitter<RefuelingFormState> emit,
  ) {
    final currentData = state.refuelingData;
    final updatedData = currentData.copyWith(abastecerArla: event.enabled);
    emit(RefuelingFormUpdated(updatedData));
  }

  void _onClearForm(
    ClearForm event,
    Emitter<RefuelingFormState> emit,
  ) {
    emit(const RefuelingFormInitial());
  }
}
