import 'package:freezed_annotation/freezed_annotation.dart';

part 'autonomous_vehicle_model.freezed.dart';
part 'autonomous_vehicle_model.g.dart';

@freezed
class AutonomousVehicleModel with _$AutonomousVehicleModel {
  const AutonomousVehicleModel._();

  const factory AutonomousVehicleModel({
    required String id,
    required String plate,
    String? brand,
    String? model,
    int? year,
    @JsonKey(name: 'fuel_type') required String fuelType,
    String? renavam,
    @Default(0) int odometer,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _AutonomousVehicleModel;

  factory AutonomousVehicleModel.fromJson(Map<String, dynamic> json) =>
      _$AutonomousVehicleModelFromJson(json);

  /// Nome formatado do veículo
  String get displayName {
    if (brand != null && model != null) {
      return '$plate - $brand $model';
    } else if (model != null) {
      return '$plate - $model';
    }
    return plate;
  }
}

@freezed
class CreateAutonomousVehicleRequest with _$CreateAutonomousVehicleRequest {
  const factory CreateAutonomousVehicleRequest({
    required String plate,
    String? brand,
    String? model,
    int? year,
    @JsonKey(name: 'fuel_type') required String fuelType,
    String? renavam,
    int? odometer,
  }) = _CreateAutonomousVehicleRequest;

  factory CreateAutonomousVehicleRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAutonomousVehicleRequestFromJson(json);
}

@freezed
class UpdateAutonomousVehicleRequest with _$UpdateAutonomousVehicleRequest {
  const factory UpdateAutonomousVehicleRequest({
    String? brand,
    String? model,
    int? year,
    @JsonKey(name: 'fuel_type') String? fuelType,
    String? renavam,
    int? odometer,
  }) = _UpdateAutonomousVehicleRequest;

  factory UpdateAutonomousVehicleRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAutonomousVehicleRequestFromJson(json);
}
