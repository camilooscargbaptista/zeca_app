import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'autonomous_vehicles_event.dart';
import 'autonomous_vehicles_state.dart';

export 'autonomous_vehicles_event.dart';
export 'autonomous_vehicles_state.dart';

/// BLoC para gerenciar a lista de veículos autônomos
@injectable
class AutonomousVehiclesBloc extends Bloc<AutonomousVehiclesEvent, AutonomousVehiclesState> {
  AutonomousVehiclesBloc() : super(const AutonomousVehiclesState()) {
    on<AutonomousVehiclesEvent>(_onEvent);
  }

  void _onEvent(
    AutonomousVehiclesEvent event,
    Emitter<AutonomousVehiclesState> emit,
  ) {
    event.when(
      loadVehicles: () {
        emit(state.copyWith(
          isLoading: true,
          error: null,
        ));
      },
      vehiclesLoaded: (vehicles, limit) {
        emit(state.copyWith(
          isLoading: false,
          vehicles: vehicles,
          vehicleLimit: limit,
          error: null,
        ));
      },
      loadFailed: (error) {
        emit(state.copyWith(
          isLoading: false,
          error: error,
        ));
      },
      startDelete: (vehicleId) {
        emit(state.copyWith(isDeleting: true));
      },
      deleteCompleted: () {
        emit(state.copyWith(isDeleting: false));
      },
      deleteFailed: (error) {
        emit(state.copyWith(
          isDeleting: false,
          error: error,
        ));
      },
    );
  }
}
