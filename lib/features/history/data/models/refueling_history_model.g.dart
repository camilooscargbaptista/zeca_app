// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refueling_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RefuelingHistoryModelImpl _$$RefuelingHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RefuelingHistoryModelImpl(
      id: json['id'] as String,
      refuelingCode: json['refueling_code'] as String,
      refuelingDatetime: DateTime.parse(json['refueling_datetime'] as String),
      stationName: json['station_name'] as String?,
      stationCnpj: json['station_cnpj'] as String?,
      driverName: json['driver_name'] as String?,
      vehiclePlate: json['vehicle_plate'] as String,
      fuelType: json['fuel_type'] as String,
      quantityLiters:
          const StringToDoubleConverter().fromJson(json['quantity_liters']),
      totalAmount:
          const StringToDoubleConverter().fromJson(json['total_amount']),
      status: json['status'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      isAutonomous: json['is_autonomous'] as bool? ?? false,
      paymentMethod: json['payment_method'] as String?,
      transporterName: json['transporter_name'] as String?,
      unitPrice:
          const NullableStringToDoubleConverter().fromJson(json['unit_price']),
      hasNfe: json['has_nfe'] as bool? ?? false,
    );

Map<String, dynamic> _$$RefuelingHistoryModelImplToJson(
        _$RefuelingHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'refueling_code': instance.refuelingCode,
      'refueling_datetime': instance.refuelingDatetime.toIso8601String(),
      'station_name': instance.stationName,
      'station_cnpj': instance.stationCnpj,
      'driver_name': instance.driverName,
      'vehicle_plate': instance.vehiclePlate,
      'fuel_type': instance.fuelType,
      'quantity_liters':
          const StringToDoubleConverter().toJson(instance.quantityLiters),
      'total_amount':
          const StringToDoubleConverter().toJson(instance.totalAmount),
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'is_autonomous': instance.isAutonomous,
      'payment_method': instance.paymentMethod,
      'transporter_name': instance.transporterName,
      'unit_price':
          const NullableStringToDoubleConverter().toJson(instance.unitPrice),
      'has_nfe': instance.hasNfe,
    };

_$HistoryResponseModelImpl _$$HistoryResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HistoryResponseModelImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => RefuelingHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$$HistoryResponseModelImplToJson(
        _$HistoryResponseModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };
