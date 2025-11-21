import 'package:equatable/equatable.dart';
import '../../domain/entities/journey_entity.dart';
import '../../domain/entities/location_point_entity.dart';

abstract class JourneyState extends Equatable {
  const JourneyState();

  @override
  List<Object?> get props => [];
}

class JourneyInitial extends JourneyState {
  const JourneyInitial();
}

class JourneyLoading extends JourneyState {
  const JourneyLoading();
}

class JourneyLoaded extends JourneyState {
  final JourneyEntity journey;
  final bool emDescanso;
  final int tempoDecorridoSegundos;
  final double kmPercorridos;
  final List<LocationPointEntity> locationPoints;

  const JourneyLoaded({
    required this.journey,
    this.emDescanso = false,
    this.tempoDecorridoSegundos = 0,
    this.kmPercorridos = 0.0,
    this.locationPoints = const [],
  });

  JourneyLoaded copyWith({
    JourneyEntity? journey,
    bool? emDescanso,
    int? tempoDecorridoSegundos,
    double? kmPercorridos,
    List<LocationPointEntity>? locationPoints,
  }) {
    return JourneyLoaded(
      journey: journey ?? this.journey,
      emDescanso: emDescanso ?? this.emDescanso,
      tempoDecorridoSegundos: tempoDecorridoSegundos ?? this.tempoDecorridoSegundos,
      kmPercorridos: kmPercorridos ?? this.kmPercorridos,
      locationPoints: locationPoints ?? this.locationPoints,
    );
  }

  @override
  List<Object?> get props => [
        journey,
        emDescanso,
        tempoDecorridoSegundos,
        kmPercorridos,
        locationPoints,
      ];
}

class JourneyError extends JourneyState {
  final String message;

  const JourneyError(this.message);

  @override
  List<Object?> get props => [message];
}

class JourneyFinished extends JourneyState {
  final JourneyEntity journey;

  const JourneyFinished({required this.journey});

  @override
  List<Object?> get props => [journey];
}

