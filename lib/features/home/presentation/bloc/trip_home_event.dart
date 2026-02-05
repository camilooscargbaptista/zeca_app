part of 'trip_home_bloc.dart';

/// Events para TripHomeBloc
@freezed
class TripHomeEvent with _$TripHomeEvent {
  /// Carregar viagem ativa
  const factory TripHomeEvent.loadActiveTrip() = LoadActiveTrip;

  /// Iniciar nova viagem
  const factory TripHomeEvent.startTrip({
    required String vehicleId,
    String? origin,
    String? destination,
  }) = StartTripRequested;

  /// Finalizar viagem
  const factory TripHomeEvent.finishTrip({
    required String tripId,
  }) = FinishTripRequested;
}
