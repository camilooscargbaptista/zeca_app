// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autonomous_vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AutonomousVehicleModelImpl _$$AutonomousVehicleModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AutonomousVehicleModelImpl(
      id: json['id'] as String,
      plate: json['plate'] as String,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      year: (json['year'] as num?)?.toInt(),
      fuelType: json['fuel_type'] as String,
      renavam: json['renavam'] as String?,
      odometer: (json['odometer'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$AutonomousVehicleModelImplToJson(
        _$AutonomousVehicleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plate': instance.plate,
      'brand': instance.brand,
      'model': instance.model,
      'year': instance.year,
      'fuel_type': instance.fuelType,
      'renavam': instance.renavam,
      'odometer': instance.odometer,
      'is_active': instance.isActive,
    };

_$CreateAutonomousVehicleRequestImpl
    _$$CreateAutonomousVehicleRequestImplFromJson(Map<String, dynamic> json) =>
        _$CreateAutonomousVehicleRequestImpl(
          plate: json['plate'] as String,
          brand: json['brand'] as String?,
          model: json['model'] as String?,
          year: (json['year'] as num?)?.toInt(),
          fuelType: json['fuel_type'] as String,
          renavam: json['renavam'] as String?,
          odometer: (json['odometer'] as num?)?.toInt(),
        );

Map<String, dynamic> _$$CreateAutonomousVehicleRequestImplToJson(
        _$CreateAutonomousVehicleRequestImpl instance) =>
    <String, dynamic>{
      'plate': instance.plate,
      'brand': instance.brand,
      'model': instance.model,
      'year': instance.year,
      'fuel_type': instance.fuelType,
      'renavam': instance.renavam,
      'odometer': instance.odometer,
    };

_$UpdateAutonomousVehicleRequestImpl
    _$$UpdateAutonomousVehicleRequestImplFromJson(Map<String, dynamic> json) =>
        _$UpdateAutonomousVehicleRequestImpl(
          brand: json['brand'] as String?,
          model: json['model'] as String?,
          year: (json['year'] as num?)?.toInt(),
          fuelType: json['fuel_type'] as String?,
          renavam: json['renavam'] as String?,
          odometer: (json['odometer'] as num?)?.toInt(),
        );

Map<String, dynamic> _$$UpdateAutonomousVehicleRequestImplToJson(
        _$UpdateAutonomousVehicleRequestImpl instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'model': instance.model,
      'year': instance.year,
      'fuel_type': instance.fuelType,
      'renavam': instance.renavam,
      'odometer': instance.odometer,
    };
