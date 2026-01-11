// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_station_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NearbyStationModelImpl _$$NearbyStationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbyStationModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      cnpj: json['cnpj'] as String,
      distanceKm: (json['distance_km'] as num).toDouble(),
      isPartner: json['is_partner'] as bool? ?? false,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: NearbyStationAddressModel.fromJson(
          json['address'] as Map<String, dynamic>),
      fuelPrices: (json['fuel_prices'] as List<dynamic>?)
              ?.map(
                  (e) => FuelPriceItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      acceptsAutonomous: json['accepts_autonomous'] as bool? ?? false,
      acceptsFleetWithoutPartnership:
          json['accepts_fleet_without_partnership'] as bool? ?? false,
    );

Map<String, dynamic> _$$NearbyStationModelImplToJson(
        _$NearbyStationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cnpj': instance.cnpj,
      'distance_km': instance.distanceKm,
      'is_partner': instance.isPartner,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'fuel_prices': instance.fuelPrices,
      'accepts_autonomous': instance.acceptsAutonomous,
      'accepts_fleet_without_partnership':
          instance.acceptsFleetWithoutPartnership,
    };

_$NearbyStationAddressModelImpl _$$NearbyStationAddressModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbyStationAddressModelImpl(
      street: json['street'] as String,
      number: json['number'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
    );

Map<String, dynamic> _$$NearbyStationAddressModelImplToJson(
        _$NearbyStationAddressModelImpl instance) =>
    <String, dynamic>{
      'street': instance.street,
      'number': instance.number,
      'city': instance.city,
      'state': instance.state,
    };

_$FuelPriceItemModelImpl _$$FuelPriceItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FuelPriceItemModelImpl(
      fuelTypeId: json['fuel_type_id'] as String?,
      fuelType: json['fuel_type'] as String,
      fuelTypeCode: json['fuel_type_code'] as String?,
      price: json['price'] as String,
    );

Map<String, dynamic> _$$FuelPriceItemModelImplToJson(
        _$FuelPriceItemModelImpl instance) =>
    <String, dynamic>{
      'fuel_type_id': instance.fuelTypeId,
      'fuel_type': instance.fuelType,
      'fuel_type_code': instance.fuelTypeCode,
      'price': instance.price,
    };

_$NearbyStationsResponseModelImpl _$$NearbyStationsResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbyStationsResponseModelImpl(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => NearbyStationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: NearbyStationsMetaModel.fromJson(
          json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NearbyStationsResponseModelImplToJson(
        _$NearbyStationsResponseModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'meta': instance.meta,
    };

_$NearbyStationsMetaModelImpl _$$NearbyStationsMetaModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbyStationsMetaModelImpl(
      total: (json['total'] as num).toInt(),
      radiusKm: (json['radius_km'] as num).toInt(),
      userLocation: UserLocationModel.fromJson(
          json['user_location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NearbyStationsMetaModelImplToJson(
        _$NearbyStationsMetaModelImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'radius_km': instance.radiusKm,
      'user_location': instance.userLocation,
    };

_$UserLocationModelImpl _$$UserLocationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserLocationModelImpl(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$$UserLocationModelImplToJson(
        _$UserLocationModelImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
