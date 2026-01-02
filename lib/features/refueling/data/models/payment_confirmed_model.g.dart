// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_confirmed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentConfirmedModelImpl _$$PaymentConfirmedModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentConfirmedModelImpl(
      refuelingCode: json['refuelingCode'] as String,
      status: json['status'] as String,
      totalValue: (json['totalValue'] as num).toDouble(),
      quantityLiters: (json['quantityLiters'] as num).toDouble(),
      pricePerLiter: (json['pricePerLiter'] as num).toDouble(),
      pumpPrice: (json['pumpPrice'] as num).toDouble(),
      savings: (json['savings'] as num).toDouble(),
      savingsPerLiter: (json['savingsPerLiter'] as num?)?.toDouble(),
      stationName: json['stationName'] as String,
      vehiclePlate: json['vehiclePlate'] as String,
      fuelType: json['fuelType'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$PaymentConfirmedModelImplToJson(
        _$PaymentConfirmedModelImpl instance) =>
    <String, dynamic>{
      'refuelingCode': instance.refuelingCode,
      'status': instance.status,
      'totalValue': instance.totalValue,
      'quantityLiters': instance.quantityLiters,
      'pricePerLiter': instance.pricePerLiter,
      'pumpPrice': instance.pumpPrice,
      'savings': instance.savings,
      'savingsPerLiter': instance.savingsPerLiter,
      'stationName': instance.stationName,
      'vehiclePlate': instance.vehiclePlate,
      'fuelType': instance.fuelType,
      'timestamp': instance.timestamp,
    };
