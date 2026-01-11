part of 'nearby_stations_bloc.dart';

abstract class NearbyStationsState extends Equatable {
  const NearbyStationsState();

  @override
  List<Object?> get props => [];
}

class NearbyStationsInitial extends NearbyStationsState {}

class NearbyStationsLoading extends NearbyStationsState {}

class NearbyStationsLoaded extends NearbyStationsState {
  final List<FuelStationEntity> stations;
  final int total;
  final int radiusKm;

  const NearbyStationsLoaded({
    required this.stations,
    required this.total,
    required this.radiusKm,
  });

  @override
  List<Object?> get props => [stations, total, radiusKm];
}

class NearbyStationsError extends NearbyStationsState {
  final String message;

  const NearbyStationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NearbyStationsEmpty extends NearbyStationsState {}
