import 'package:freezed_annotation/freezed_annotation.dart';

part 'nearby_station_model.freezed.dart';
part 'nearby_station_model.g.dart';

/// Model para resposta da API GET /stations/nearby
/// Compatível com o formato otimizado do backend
@freezed
class NearbyStationModel with _$NearbyStationModel {
  const NearbyStationModel._();
  
  const factory NearbyStationModel({
    required String id,
    required String name,
    required String cnpj,
    @JsonKey(name: 'distance_km') required double distanceKm,
    @JsonKey(name: 'is_partner') @Default(false) bool isPartner,
    required double latitude,
    required double longitude,
    required NearbyStationAddressModel address,
    @JsonKey(name: 'fuel_prices') @Default([]) List<FuelPriceItemModel> fuelPrices,
    @JsonKey(name: 'accepts_autonomous') @Default(false) bool acceptsAutonomous,
    @JsonKey(name: 'accepts_fleet_without_partnership') @Default(false) bool acceptsFleetWithoutPartnership,
  }) = _NearbyStationModel;
  
  factory NearbyStationModel.fromJson(Map<String, dynamic> json) =>
      _$NearbyStationModelFromJson(json);

  /// Formatar preços para exibição
  Map<String, double> get pricesMap {
    final map = <String, double>{};
    for (final price in fuelPrices) {
      map[price.fuelType] = double.tryParse(price.price) ?? 0.0;
    }
    return map;
  }

  /// Formatar distância para exibição
  String get formattedDistance {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).toInt()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  /// Endereço formatado
  String get formattedAddress {
    final addr = address;
    return '${addr.street}, ${addr.number} - ${addr.city}, ${addr.state}';
  }
}

@freezed
class NearbyStationAddressModel with _$NearbyStationAddressModel {
  const factory NearbyStationAddressModel({
    required String street,
    String? number,
    required String city,
    required String state,
  }) = _NearbyStationAddressModel;
  
  factory NearbyStationAddressModel.fromJson(Map<String, dynamic> json) =>
      _$NearbyStationAddressModelFromJson(json);
}

@freezed
class FuelPriceItemModel with _$FuelPriceItemModel {
  const factory FuelPriceItemModel({
    @JsonKey(name: 'fuel_type_id') String? fuelTypeId,
    @JsonKey(name: 'fuel_type') required String fuelType,
    @JsonKey(name: 'fuel_type_code') String? fuelTypeCode,
    required String price,
  }) = _FuelPriceItemModel;
  
  factory FuelPriceItemModel.fromJson(Map<String, dynamic> json) =>
      _$FuelPriceItemModelFromJson(json);
}

/// Response wrapper para lista de postos próximos
@freezed
class NearbyStationsResponseModel with _$NearbyStationsResponseModel {
  const factory NearbyStationsResponseModel({
    required bool success,
    required List<NearbyStationModel> data,
    required NearbyStationsMetaModel meta,
  }) = _NearbyStationsResponseModel;
  
  factory NearbyStationsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NearbyStationsResponseModelFromJson(json);
}

@freezed
class NearbyStationsMetaModel with _$NearbyStationsMetaModel {
  const factory NearbyStationsMetaModel({
    required int total,
    @JsonKey(name: 'radius_km') required int radiusKm,
    @JsonKey(name: 'user_location') required UserLocationModel userLocation,
  }) = _NearbyStationsMetaModel;
  
  factory NearbyStationsMetaModel.fromJson(Map<String, dynamic> json) =>
      _$NearbyStationsMetaModelFromJson(json);
}

@freezed
class UserLocationModel with _$UserLocationModel {
  const factory UserLocationModel({
    required double lat,
    required double lng,
  }) = _UserLocationModel;
  
  factory UserLocationModel.fromJson(Map<String, dynamic> json) =>
      _$UserLocationModelFromJson(json);
}
