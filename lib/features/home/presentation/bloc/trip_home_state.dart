part of 'trip_home_bloc.dart';

/// Estados para TripHomeBloc
@freezed
class TripHomeState with _$TripHomeState {
  /// Estado inicial
  const factory TripHomeState.initial() = TripHomeInitial;

  /// Carregando
  const factory TripHomeState.loading() = TripHomeLoading;

  /// Sem viagem ativa - mostrar CTA
  const factory TripHomeState.noActiveTrip() = NoActiveTrip;

  /// Viagem ativa - mostrar status
  const factory TripHomeState.active({
    required Trip trip,
  }) = TripActive;

  /// Erro
  const factory TripHomeState.error({
    required String message,
  }) = TripHomeError;
}
