part of 'nearby_stations_bloc.dart';

abstract class NearbyStationsEvent extends Equatable {
  const NearbyStationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNearbyStations extends NearbyStationsEvent {
  final double latitude;
  final double longitude;
  final int radius;
  final String? combustivel;
  final bool? conveniado;
  final String? search;

  const LoadNearbyStations({
    required this.latitude,
    required this.longitude,
    this.radius = 50,
    this.combustivel,
    this.conveniado,
    this.search,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius, combustivel, conveniado, search];
}
