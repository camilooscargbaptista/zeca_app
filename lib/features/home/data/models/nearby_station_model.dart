import 'package:freezed_annotation/freezed_annotation.dart';

part 'nearby_station_model.freezed.dart';
part 'nearby_station_model.g.dart';

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

  Map<String, double> get pricesMap {
    final map = <String, double>{};
    for (final price in fuelPrices) {
      map[price.fuelType] = double.tryParse(price.price) ?? 0.0;
    }
    return map;
  }

  String get formattedDistance {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).toInt()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  String get formattedAddress {
    return '${address.street}, ${address.number} - ${address.city}, ${address.state}';
  }
}

@freezed
class NearbyStationAddressModel with _$NearbyStationAddressModel {
  const factory NearbyStationAddressModel({
    required String street,
    String? number,
    required String city,
    required String state,
    @Default('') String neighborhood,
    @Default('') String zipCode,
  }) = _NearbyStationAddressModel;

  factory NearbyStationAddressModel.fromJson(Map<String, dynamic> json) =>
      _$NearbyStationAddressModelFromJson(json);
}

@freezed
class FuelPriceItemModel with _$FuelPriceItemModel {
  const factory FuelPriceItemModel({
    @JsonKey(name: 'fuel_type') required String fuelType,
    required String price,
  }) = _FuelPriceItemModel;

  factory FuelPriceItemModel.fromJson(Map<String, dynamic> json) =>
      _$FuelPriceItemModelFromJson(json);
}
