// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleModelImpl _$$VehicleModelImplFromJson(Map<String, dynamic> json) =>
    _$VehicleModelImpl(
      id: json['id'] as String,
      plate: json['plate'] as String,
      model: json['model'] as String,
      brand: json['brand'] as String,
      year: (json['year'] as num).toInt(),
      color: json['color'] as String,
      fuelTypes: (json['fuel_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastKm: (json['last_km'] as num).toInt(),
      lastRefueling: json['last_refueling'] == null
          ? null
          : DateTime.parse(json['last_refueling'] as String),
      companyId: json['company_id'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      specs: json['specs'] == null
          ? null
          : VehicleSpecsModel.fromJson(json['specs'] as Map<String, dynamic>),
      insurance: json['insurance'] == null
          ? null
          : VehicleInsuranceModel.fromJson(
              json['insurance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VehicleModelImplToJson(_$VehicleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plate': instance.plate,
      'model': instance.model,
      'brand': instance.brand,
      'year': instance.year,
      'color': instance.color,
      'fuel_types': instance.fuelTypes,
      'last_km': instance.lastKm,
      'last_refueling': instance.lastRefueling?.toIso8601String(),
      'company_id': instance.companyId,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'specs': instance.specs,
      'insurance': instance.insurance,
    };

_$VehicleSpecsModelImpl _$$VehicleSpecsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VehicleSpecsModelImpl(
      engineSize: json['engine_size'] as String?,
      fuelCapacity: (json['fuel_capacity'] as num?)?.toDouble(),
      consumptionCity: (json['consumption_city'] as num?)?.toDouble(),
      consumptionHighway: (json['consumption_highway'] as num?)?.toDouble(),
      transmission: json['transmission'] as String?,
      fuelSystem: json['fuel_system'] as String?,
    );

Map<String, dynamic> _$$VehicleSpecsModelImplToJson(
        _$VehicleSpecsModelImpl instance) =>
    <String, dynamic>{
      'engine_size': instance.engineSize,
      'fuel_capacity': instance.fuelCapacity,
      'consumption_city': instance.consumptionCity,
      'consumption_highway': instance.consumptionHighway,
      'transmission': instance.transmission,
      'fuel_system': instance.fuelSystem,
    };

_$VehicleInsuranceModelImpl _$$VehicleInsuranceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VehicleInsuranceModelImpl(
      insuranceCompany: json['insurance_company'] as String?,
      policyNumber: json['policy_number'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      coverageType: json['coverage_type'] as String?,
    );

Map<String, dynamic> _$$VehicleInsuranceModelImplToJson(
        _$VehicleInsuranceModelImpl instance) =>
    <String, dynamic>{
      'insurance_company': instance.insuranceCompany,
      'policy_number': instance.policyNumber,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'coverage_type': instance.coverageType,
    };
