import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/refueling_history_entity.dart';

part 'refueling_history_model.freezed.dart';
part 'refueling_history_model.g.dart';

/// Conversor para campos que podem vir como String ou num
class StringToDoubleConverter implements JsonConverter<double, dynamic> {
  const StringToDoubleConverter();

  @override
  double fromJson(dynamic json) {
    if (json == null) return 0.0;
    if (json is num) return json.toDouble();
    if (json is String) return double.tryParse(json) ?? 0.0;
    return 0.0;
  }

  @override
  dynamic toJson(double object) => object;
}

/// Conversor nullable para campos opcionais
class NullableStringToDoubleConverter implements JsonConverter<double?, dynamic> {
  const NullableStringToDoubleConverter();

  @override
  double? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is num) return json.toDouble();
    if (json is String) return double.tryParse(json);
    return null;
  }

  @override
  dynamic toJson(double? object) => object;
}

/// Model para um item do histórico de abastecimentos
@freezed
class RefuelingHistoryModel with _$RefuelingHistoryModel {
  const RefuelingHistoryModel._();

  const factory RefuelingHistoryModel({
    required String id,
    @JsonKey(name: 'refueling_code') required String refuelingCode,
    @JsonKey(name: 'refueling_datetime') required DateTime refuelingDatetime,
    @JsonKey(name: 'station_name') String? stationName,
    @JsonKey(name: 'station_cnpj') String? stationCnpj,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'vehicle_plate') required String vehiclePlate,
    @JsonKey(name: 'fuel_type') required String fuelType,
    @StringToDoubleConverter()
    @JsonKey(name: 'quantity_liters') required double quantityLiters,
    @StringToDoubleConverter()
    @JsonKey(name: 'total_amount') required double totalAmount,
    required String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'is_autonomous') @Default(false) bool isAutonomous,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'transporter_name') String? transporterName,
    @NullableStringToDoubleConverter()
    @JsonKey(name: 'unit_price') double? unitPrice,
    @JsonKey(name: 'has_nfe') @Default(false) bool hasNfe,
  }) = _RefuelingHistoryModel;

  factory RefuelingHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$RefuelingHistoryModelFromJson(json);

  /// Converte para entity do domínio
  RefuelingHistoryEntity toEntity() {
    return RefuelingHistoryEntity(
      id: id,
      refuelingCode: refuelingCode,
      refuelingDatetime: refuelingDatetime,
      stationName: stationName ?? 'Posto não informado',
      vehiclePlate: vehiclePlate,
      fuelType: fuelType,
      quantityLiters: quantityLiters,
      totalAmount: totalAmount,
      status: status,
      isAutonomous: isAutonomous,
      paymentMethod: paymentMethod,
      unitPrice: unitPrice ?? (quantityLiters > 0 ? totalAmount / quantityLiters : 0),
      hasNfe: hasNfe,
    );
  }
}

/// Model para resposta paginada do histórico
@freezed
class HistoryResponseModel with _$HistoryResponseModel {
  const HistoryResponseModel._();

  const factory HistoryResponseModel({
    required List<RefuelingHistoryModel> data,
    required int total,
    required int page,
    required int limit,
  }) = _HistoryResponseModel;

  factory HistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryResponseModelFromJson(json);

  bool get hasMore => (page * limit) < total;
  int get totalPages => (total / limit).ceil();
}
