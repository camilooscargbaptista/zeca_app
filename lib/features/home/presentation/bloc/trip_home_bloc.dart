import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../trip/domain/entities/trip.dart';
import '../../../trip/domain/usecases/get_active_trip.dart';
import '../../../trip/domain/usecases/start_trip.dart';
import '../../../trip/domain/usecases/finish_trip.dart';
import '../../../../core/usecases/usecase.dart';

part 'trip_home_event.dart';
part 'trip_home_state.dart';
part 'trip_home_bloc.freezed.dart';

/// BLoC simples para gerenciar viagens na Home
/// Só faz: carregar viagem ativa, iniciar, finalizar
@injectable
class TripHomeBloc extends Bloc<TripHomeEvent, TripHomeState> {
  final GetActiveTrip _getActiveTrip;
  final StartTrip _startTrip;
  final FinishTrip _finishTrip;

  TripHomeBloc({
    required GetActiveTrip getActiveTrip,
    required StartTrip startTrip,
    required FinishTrip finishTrip,
  })  : _getActiveTrip = getActiveTrip,
        _startTrip = startTrip,
        _finishTrip = finishTrip,
        super(const TripHomeState.initial()) {
    on<LoadActiveTrip>(_onLoadActiveTrip);
    on<StartTripRequested>(_onStartTrip);
    on<FinishTripRequested>(_onFinishTrip);
  }

  Future<void> _onLoadActiveTrip(
    LoadActiveTrip event,
    Emitter<TripHomeState> emit,
  ) async {
    emit(const TripHomeState.loading());

    final result = await _getActiveTrip(NoParams());

    result.fold(
      (failure) => emit(const TripHomeState.noActiveTrip()),
      (trip) {
        if (trip == null) {
          emit(const TripHomeState.noActiveTrip());
        } else {
          emit(TripHomeState.active(trip: trip));
        }
      },
    );
  }

  Future<void> _onStartTrip(
    StartTripRequested event,
    Emitter<TripHomeState> emit,
  ) async {
    emit(const TripHomeState.loading());

    final result = await _startTrip(StartTripParams(
      vehicleId: event.vehicleId,
      origin: event.origin,
      destination: event.destination,
    ));

    result.fold(
      (failure) => emit(TripHomeState.error(message: failure.message)),
      (trip) => emit(TripHomeState.active(trip: trip)),
    );
  }

  Future<void> _onFinishTrip(
    FinishTripRequested event,
    Emitter<TripHomeState> emit,
  ) async {
    emit(const TripHomeState.loading());

    final result = await _finishTrip(FinishTripParams(tripId: event.tripId));

    result.fold(
      (failure) => emit(TripHomeState.error(message: failure.message)),
      (trip) => emit(const TripHomeState.noActiveTrip()),
    );
  }
}
