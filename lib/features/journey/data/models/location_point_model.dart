import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/location_point_entity.dart';

part 'location_point_model.freezed.dart';
part 'location_point_model.g.dart';

@freezed
abstract class LocationPointModel with _$LocationPointModel {
  const LocationPointModel._();
  
  const factory LocationPointModel({
    required String id,
    @JsonKey(name: 'journey_id') required String journeyId,
    required double latitude,
    required double longitude,
    required double velocidade,
    required DateTime timestamp,
    @Default(false) bool sincronizado,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _LocationPointModel;
  
  factory LocationPointModel.fromJson(Map<String, dynamic> json) =>
      _$LocationPointModelFromJson(json);

  LocationPointEntity toEntity() {
    return LocationPointEntity(
      id: id,
      journeyId: journeyId,
      latitude: latitude,
      longitude: longitude,
      velocidade: velocidade,
      timestamp: timestamp,
      sincronizado: sincronizado,
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}

