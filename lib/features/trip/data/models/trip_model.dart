import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/trip.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

@freezed
class TripModel with _$TripModel {
  const TripModel._();

  const factory TripModel({
    required String id,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'vehicle_id') required String vehicleId,
    @JsonKey(name: 'driver_id') String? driverId,
    @JsonKey(name: 'journey_id') String? journeyId,
    
    // Campos de origem/destino - todos opcionais
    @JsonKey(name: 'origin_description') String? originDescription,
    @JsonKey(name: 'origin_city') String? originCity,
    @JsonKey(name: 'origin_state') String? originState,
    @JsonKey(name: 'origin_latitude') double? originLatitude,
    @JsonKey(name: 'origin_longitude') double? originLongitude,
    
    @JsonKey(name: 'destination_description') String? destinationDescription,
    @JsonKey(name: 'destination_city') String? destinationCity,
    @JsonKey(name: 'destination_state') String? destinationState,
    @JsonKey(name: 'destination_latitude') double? destinationLatitude,
    @JsonKey(name: 'destination_longitude') double? destinationLongitude,
    
    // Distância e odômetro - opcionais
    @JsonKey(name: 'distance_km') double? distanceKm,
    @JsonKey(name: 'odometer_start') double? odometerStart,
    @JsonKey(name: 'odometer_end') double? odometerEnd,
    
    // Status e datas
    required String status,
    @JsonKey(name: 'departure_date') DateTime? departureDate,
    @JsonKey(name: 'arrival_date') DateTime? arrivalDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    
    // Métricas de paradas
    @JsonKey(name: 'total_stops') int? totalStops,
    @JsonKey(name: 'total_stop_duration_seconds') int? totalStopDurationSeconds,
    @JsonKey(name: 'driving_duration_seconds') int? drivingDurationSeconds,
    
    // Notas
    String? notes,
  }) = _TripModel;

  factory TripModel.fromJson(Map<String, dynamic> json) =>
      _$TripModelFromJson(json);

  /// Convert to domain entity
  Trip toEntity() => Trip(
        id: id,
        companyId: companyId,
        vehicleId: vehicleId,
        driverId: driverId,
        journeyId: journeyId,
        origin: originDescription,
        destination: destinationDescription,
        totalDistanceKm: distanceKm,
        status: status,
        startedAt: departureDate,
        endedAt: arrivalDate,
        createdAt: createdAt,
      );
}
