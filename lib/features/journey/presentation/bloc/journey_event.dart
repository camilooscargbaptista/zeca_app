import 'package:equatable/equatable.dart';

abstract class JourneyEvent extends Equatable {
  const JourneyEvent();

  @override
  List<Object?> get props => [];
}

class LoadActiveJourney extends JourneyEvent {
  const LoadActiveJourney();
}

class StartJourney extends JourneyEvent {
  final String placa;
  final int odometroInicial;
  final String? destino;
  final int? previsaoKm;
  final String? observacoes;

  const StartJourney({
    required this.placa,
    required this.odometroInicial,
    this.destino,
    this.previsaoKm,
    this.observacoes,
  });

  @override
  List<Object?> get props => [placa, odometroInicial, destino, previsaoKm, observacoes];
}

class AddLocationPoint extends JourneyEvent {
  final double latitude;
  final double longitude;
  final double velocidade;
  final DateTime timestamp;

  const AddLocationPoint({
    required this.latitude,
    required this.longitude,
    required this.velocidade,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [latitude, longitude, velocidade, timestamp];
}

class ToggleRest extends JourneyEvent {
  final bool isStartingRest;

  const ToggleRest({required this.isStartingRest});

  @override
  List<Object?> get props => [isStartingRest];
}

class FinishJourney extends JourneyEvent {
  final int? odometroFinal;

  const FinishJourney({this.odometroFinal});

  @override
  List<Object?> get props => [odometroFinal];
}

class CancelJourney extends JourneyEvent {
  const CancelJourney();
}

class SyncPendingPoints extends JourneyEvent {
  const SyncPendingPoints();
}

class UpdateJourneyTimer extends JourneyEvent {
  const UpdateJourneyTimer();
}

