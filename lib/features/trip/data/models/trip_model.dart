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
    String? origin,
    String? destination,
    @JsonKey(name: 'total_distance_km') double? totalDistanceKm,
    required String status,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
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
        origin: origin,
        destination: destination,
        totalDistanceKm: totalDistanceKm,
        status: status,
        startedAt: startedAt,
        endedAt: endedAt,
        createdAt: createdAt,
      );
}
