// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refueling_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RefuelingCodeModelImpl _$$RefuelingCodeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RefuelingCodeModelImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      qrCode: json['qr_code'] as String,
      vehicleId: json['vehicle_id'] as String,
      vehiclePlate: json['vehicle_plate'] as String,
      userId: json['user_id'] as String,
      userCpf: json['user_cpf'] as String,
      stationId: json['station_id'] as String,
      stationCnpj: json['station_cnpj'] as String,
      fuelType: json['fuel_type'] as String,
      pricePerLiter: (json['price_per_liter'] as num).toDouble(),
      maxQuantity: (json['max_quantity'] as num).toDouble(),
      maxValue: (json['max_value'] as num).toDouble(),
      currentKm: (json['current_km'] as num).toInt(),
      requiresArla: json['requires_arla'] as bool? ?? false,
      arlaPrice: (json['arla_price'] as num?)?.toDouble(),
      validUntil: DateTime.parse(json['valid_until'] as String),
      generatedAt: DateTime.parse(json['generated_at'] as String),
      status: json['status'] as String? ?? 'pending',
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      refuelingData: json['refueling_data'] == null
          ? null
          : RefuelingDataModel.fromJson(
              json['refueling_data'] as Map<String, dynamic>),
      cancellationReason: json['cancellation_reason'] as String?,
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$$RefuelingCodeModelImplToJson(
        _$RefuelingCodeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'qr_code': instance.qrCode,
      'vehicle_id': instance.vehicleId,
      'vehicle_plate': instance.vehiclePlate,
      'user_id': instance.userId,
      'user_cpf': instance.userCpf,
      'station_id': instance.stationId,
      'station_cnpj': instance.stationCnpj,
      'fuel_type': instance.fuelType,
      'price_per_liter': instance.pricePerLiter,
      'max_quantity': instance.maxQuantity,
      'max_value': instance.maxValue,
      'current_km': instance.currentKm,
      'requires_arla': instance.requiresArla,
      'arla_price': instance.arlaPrice,
      'valid_until': instance.validUntil.toIso8601String(),
      'generated_at': instance.generatedAt.toIso8601String(),
      'status': instance.status,
      'documents': instance.documents,
      'refueling_data': instance.refuelingData,
      'cancellation_reason': instance.cancellationReason,
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };

_$DocumentModelImpl _$$DocumentModelImplFromJson(Map<String, dynamic> json) =>
    _$DocumentModelImpl(
      id: json['id'] as String,
      url: json['url'] as String,
      fileName: json['file_name'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      mimeType: json['mime_type'] as String,
      documentType: json['document_type'] as String,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      uploadedBy: json['uploaded_by'] as String,
    );

Map<String, dynamic> _$$DocumentModelImplToJson(_$DocumentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'file_name': instance.fileName,
      'file_size': instance.fileSize,
      'mime_type': instance.mimeType,
      'document_type': instance.documentType,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
      'uploaded_by': instance.uploadedBy,
    };

_$RefuelingDataModelImpl _$$RefuelingDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RefuelingDataModelImpl(
      quantityLiters: (json['quantity_liters'] as num).toDouble(),
      totalValue: (json['total_value'] as num).toDouble(),
      finalKm: (json['final_km'] as num).toInt(),
      arlaQuantity: (json['arla_quantity'] as num?)?.toDouble(),
      arlaValue: (json['arla_value'] as num?)?.toDouble(),
      odometerPhoto: json['odometer_photo'] as String?,
      pumpPhoto: json['pump_photo'] as String?,
      receiptPhoto: json['receipt_photo'] as String?,
      refueledAt: DateTime.parse(json['refueled_at'] as String),
      refueledBy: json['refueled_by'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$RefuelingDataModelImplToJson(
        _$RefuelingDataModelImpl instance) =>
    <String, dynamic>{
      'quantity_liters': instance.quantityLiters,
      'total_value': instance.totalValue,
      'final_km': instance.finalKm,
      'arla_quantity': instance.arlaQuantity,
      'arla_value': instance.arlaValue,
      'odometer_photo': instance.odometerPhoto,
      'pump_photo': instance.pumpPhoto,
      'receipt_photo': instance.receiptPhoto,
      'refueled_at': instance.refueledAt.toIso8601String(),
      'refueled_by': instance.refueledBy,
      'notes': instance.notes,
    };

_$RefuelingRequestModelImpl _$$RefuelingRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RefuelingRequestModelImpl(
      vehicleId: json['vehicle_id'] as String,
      stationId: json['station_id'] as String,
      fuelType: json['fuel_type'] as String,
      currentKm: (json['current_km'] as num).toInt(),
      maxQuantity: (json['max_quantity'] as num).toDouble(),
      maxValue: (json['max_value'] as num).toDouble(),
      requiresArla: json['requires_arla'] as bool? ?? false,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$RefuelingRequestModelImplToJson(
        _$RefuelingRequestModelImpl instance) =>
    <String, dynamic>{
      'vehicle_id': instance.vehicleId,
      'station_id': instance.stationId,
      'fuel_type': instance.fuelType,
      'current_km': instance.currentKm,
      'max_quantity': instance.maxQuantity,
      'max_value': instance.maxValue,
      'requires_arla': instance.requiresArla,
      'notes': instance.notes,
    };
