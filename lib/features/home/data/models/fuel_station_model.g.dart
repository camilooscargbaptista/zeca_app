// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_station_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FuelStationModelImpl _$$FuelStationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FuelStationModelImpl(
      id: json['id'] as String,
      cnpj: json['cnpj'] as String,
      corporateName: json['corporate_name'] as String,
      fantasyName: json['fantasy_name'] as String,
      address: FuelStationAddressModel.fromJson(
          json['address'] as Map<String, dynamic>),
      isPartner: json['is_partner'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      prices: (json['prices'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      lastPriceUpdate: json['last_price_update'] == null
          ? null
          : DateTime.parse(json['last_price_update'] as String),
      contactInfo: json['contact_info'] == null
          ? null
          : FuelStationContactModel.fromJson(
              json['contact_info'] as Map<String, dynamic>),
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      paymentMethods: (json['payment_methods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$FuelStationModelImplToJson(
        _$FuelStationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cnpj': instance.cnpj,
      'corporate_name': instance.corporateName,
      'fantasy_name': instance.fantasyName,
      'address': instance.address,
      'is_partner': instance.isPartner,
      'is_active': instance.isActive,
      'prices': instance.prices,
      'last_price_update': instance.lastPriceUpdate?.toIso8601String(),
      'contact_info': instance.contactInfo,
      'services': instance.services,
      'payment_methods': instance.paymentMethods,
      'rating': instance.rating,
      'distance_km': instance.distanceKm,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$FuelStationAddressModelImpl _$$FuelStationAddressModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FuelStationAddressModelImpl(
      street: json['street'] as String,
      number: json['number'] as String,
      complement: json['complement'] as String?,
      neighborhood: json['neighborhood'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$FuelStationAddressModelImplToJson(
        _$FuelStationAddressModelImpl instance) =>
    <String, dynamic>{
      'street': instance.street,
      'number': instance.number,
      'complement': instance.complement,
      'neighborhood': instance.neighborhood,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_$FuelStationContactModelImpl _$$FuelStationContactModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FuelStationContactModelImpl(
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      managerName: json['manager_name'] as String?,
      managerPhone: json['manager_phone'] as String?,
    );

Map<String, dynamic> _$$FuelStationContactModelImplToJson(
        _$FuelStationContactModelImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'manager_name': instance.managerName,
      'manager_phone': instance.managerPhone,
    };
