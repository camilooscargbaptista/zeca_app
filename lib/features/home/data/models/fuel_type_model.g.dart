// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FuelTypeModelImpl _$$FuelTypeModelImplFromJson(Map<String, dynamic> json) =>
    _$FuelTypeModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String,
      isActive: json['is_active'] as bool? ?? true,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      unit: json['unit'] as String? ?? 'L',
      density: (json['density'] as num?)?.toDouble(),
      energyContent: (json['energy_content'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$FuelTypeModelImplToJson(_$FuelTypeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
      'is_active': instance.isActive,
      'color': instance.color,
      'icon': instance.icon,
      'unit': instance.unit,
      'density': instance.density,
      'energy_content': instance.energyContent,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$FuelPriceModelImpl _$$FuelPriceModelImplFromJson(Map<String, dynamic> json) =>
    _$FuelPriceModelImpl(
      id: json['id'] as String,
      fuelTypeId: json['fuel_type_id'] as String,
      stationId: json['station_id'] as String,
      price: (json['price'] as num).toDouble(),
      priceDate: DateTime.parse(json['price_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
      source: json['source'] as String? ?? 'station',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$FuelPriceModelImplToJson(
        _$FuelPriceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fuel_type_id': instance.fuelTypeId,
      'station_id': instance.stationId,
      'price': instance.price,
      'price_date': instance.priceDate.toIso8601String(),
      'is_active': instance.isActive,
      'source': instance.source,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$FuelPriceHistoryModelImpl _$$FuelPriceHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FuelPriceHistoryModelImpl(
      id: json['id'] as String,
      fuelTypeId: json['fuel_type_id'] as String,
      stationId: json['station_id'] as String,
      price: (json['price'] as num).toDouble(),
      priceDate: DateTime.parse(json['price_date'] as String),
      changeAmount: (json['change_amount'] as num?)?.toDouble(),
      changePercentage: (json['change_percentage'] as num?)?.toDouble(),
      isIncrease: json['is_increase'] as bool? ?? false,
    );

Map<String, dynamic> _$$FuelPriceHistoryModelImplToJson(
        _$FuelPriceHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fuel_type_id': instance.fuelTypeId,
      'station_id': instance.stationId,
      'price': instance.price,
      'price_date': instance.priceDate.toIso8601String(),
      'change_amount': instance.changeAmount,
      'change_percentage': instance.changePercentage,
      'is_increase': instance.isIncrease,
    };
