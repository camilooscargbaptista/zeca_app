import 'package:freezed_annotation/freezed_annotation.dart';

part 'fuel_type_model.freezed.dart';
part 'fuel_type_model.g.dart';

@freezed
class FuelTypeModel with _$FuelTypeModel {
  const factory FuelTypeModel({
    required String id,
    required String name,
    required String code,
    required String description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'color') String? color,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'unit') @Default('L') String unit,
    @JsonKey(name: 'density') double? density,
    @JsonKey(name: 'energy_content') double? energyContent,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _FuelTypeModel;
  
  factory FuelTypeModel.fromJson(Map<String, dynamic> json) =>
      _$FuelTypeModelFromJson(json);
}

@freezed
class FuelPriceModel with _$FuelPriceModel {
  const factory FuelPriceModel({
    required String id,
    @JsonKey(name: 'fuel_type_id') required String fuelTypeId,
    @JsonKey(name: 'station_id') required String stationId,
    required double price,
    @JsonKey(name: 'price_date') required DateTime priceDate,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'source') @Default('station') String source,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _FuelPriceModel;
  
  factory FuelPriceModel.fromJson(Map<String, dynamic> json) =>
      _$FuelPriceModelFromJson(json);
}

@freezed
class FuelPriceHistoryModel with _$FuelPriceHistoryModel {
  const factory FuelPriceHistoryModel({
    required String id,
    @JsonKey(name: 'fuel_type_id') required String fuelTypeId,
    @JsonKey(name: 'station_id') required String stationId,
    required double price,
    @JsonKey(name: 'price_date') required DateTime priceDate,
    @JsonKey(name: 'change_amount') double? changeAmount,
    @JsonKey(name: 'change_percentage') double? changePercentage,
    @JsonKey(name: 'is_increase') @Default(false) bool isIncrease,
  }) = _FuelPriceHistoryModel;
  
  factory FuelPriceHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$FuelPriceHistoryModelFromJson(json);
}
