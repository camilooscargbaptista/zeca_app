import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_confirmed_model.freezed.dart';
part 'payment_confirmed_model.g.dart';

@freezed
class PaymentConfirmedModel with _$PaymentConfirmedModel {
  const factory PaymentConfirmedModel({
    @JsonKey(name: 'refuelingCode') required String refuelingCode,
    required String status,
    required double totalValue,
    required double quantityLiters,
    required double pricePerLiter,
    required double pumpPrice,
    required double savings,
    @JsonKey(name: 'savingsPerLiter') double? savingsPerLiter,
    required String stationName,
    required String vehiclePlate,
    required String fuelType,
    required String timestamp,
  }) = _PaymentConfirmedModel;

  factory PaymentConfirmedModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentConfirmedModelFromJson(json);
}
