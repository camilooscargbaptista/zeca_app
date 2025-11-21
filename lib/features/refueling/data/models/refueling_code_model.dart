import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/refueling_code_entity.dart';
import '../../domain/entities/refueling_shared_entities.dart';
import '../../domain/entities/document_entity.dart';

part 'refueling_code_model.freezed.dart';
part 'refueling_code_model.g.dart';

@freezed
class RefuelingCodeModel with _$RefuelingCodeModel {
  const RefuelingCodeModel._();
  
  const factory RefuelingCodeModel({
    required String id,
    required String code,
    @JsonKey(name: 'qr_code') required String qrCode,
    @JsonKey(name: 'vehicle_id') required String vehicleId,
    @JsonKey(name: 'vehicle_plate') required String vehiclePlate,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_cpf') required String userCpf,
    @JsonKey(name: 'station_id') required String stationId,
    @JsonKey(name: 'station_cnpj') required String stationCnpj,
    @JsonKey(name: 'fuel_type') required String fuelType,
    @JsonKey(name: 'price_per_liter') required double pricePerLiter,
    @JsonKey(name: 'max_quantity') required double maxQuantity,
    @JsonKey(name: 'max_value') required double maxValue,
    @JsonKey(name: 'current_km') required int currentKm,
    @JsonKey(name: 'requires_arla') @Default(false) bool requiresArla,
    @JsonKey(name: 'arla_price') double? arlaPrice,
    @JsonKey(name: 'valid_until') required DateTime validUntil,
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
    @JsonKey(name: 'status') @Default('pending') String status,
    @JsonKey(name: 'documents') @Default([]) List<DocumentModel> documents,
    @JsonKey(name: 'refueling_data') RefuelingDataModel? refuelingData,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _RefuelingCodeModel;
  
  factory RefuelingCodeModel.fromJson(Map<String, dynamic> json) =>
      _$RefuelingCodeModelFromJson(json);

  RefuelingCodeEntity toEntity() {
    return RefuelingCodeEntity(
      id: id,
      codigo: code,
      qrCode: qrCode,
      veiculo: RefuelingVehicleEntity(
        id: vehicleId,
        placa: vehiclePlate,
        modelo: '', // Será preenchido pelo repository
        marca: '', // Será preenchido pelo repository
      ),
      posto: RefuelingStationEntity(
        id: stationId,
        cnpj: stationCnpj,
        nome: '', // Será preenchido pelo repository
        endereco: '', // Será preenchido pelo repository
      ),
      dadosAbastecimento: RefuelingDataEntity(
        combustivel: fuelType,
        precoLitro: pricePerLiter,
        quantidadeMaxima: maxQuantity,
        valorMaximo: maxValue,
        kmRegistrado: currentKm,
        abastecerArla: requiresArla,
        precoArla: arlaPrice,
      ),
      validade: RefuelingValidityEntity(
        validoAte: validUntil,
        tempoRestanteMinutos: validUntil.difference(DateTime.now()).inMinutes,
      ),
      status: status,
      geradoEm: generatedAt,
      geradoPor: RefuelingUserEntity(
        id: userId,
        nome: '', // Será preenchido pelo repository
        cpf: userCpf,
      ),
    );
  }
}

@freezed
class DocumentModel with _$DocumentModel {
  const DocumentModel._();
  
  const factory DocumentModel({
    required String id,
    required String url,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'file_size') required int fileSize,
    @JsonKey(name: 'mime_type') required String mimeType,
    @JsonKey(name: 'document_type') required String documentType,
    @JsonKey(name: 'uploaded_at') required DateTime uploadedAt,
    @JsonKey(name: 'uploaded_by') required String uploadedBy,
  }) = _DocumentModel;
  
  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  DocumentEntity toEntity() {
    return DocumentEntity(
      id: id,
      nomeOriginal: fileName,
      nomeArquivo: fileName,
      tipo: documentType,
      tamanhoBytes: fileSize,
      mimeType: mimeType,
      url: url,
      urlThumbnail: null, // Será preenchido pelo repository se disponível
      uploadadoEm: uploadedAt,
      uploadadoPor: DocumentUserEntity(
        id: uploadedBy,
        nome: '', // Será preenchido pelo repository
      ),
      refuelingId: null, // Será preenchido pelo repository
    );
  }
}

@freezed
class RefuelingDataModel with _$RefuelingDataModel {
  const factory RefuelingDataModel({
    @JsonKey(name: 'quantity_liters') required double quantityLiters,
    @JsonKey(name: 'total_value') required double totalValue,
    @JsonKey(name: 'final_km') required int finalKm,
    @JsonKey(name: 'arla_quantity') double? arlaQuantity,
    @JsonKey(name: 'arla_value') double? arlaValue,
    @JsonKey(name: 'odometer_photo') String? odometerPhoto,
    @JsonKey(name: 'pump_photo') String? pumpPhoto,
    @JsonKey(name: 'receipt_photo') String? receiptPhoto,
    @JsonKey(name: 'refueled_at') required DateTime refueledAt,
    @JsonKey(name: 'refueled_by') required String refueledBy,
    @JsonKey(name: 'notes') String? notes,
  }) = _RefuelingDataModel;
  
  factory RefuelingDataModel.fromJson(Map<String, dynamic> json) =>
      _$RefuelingDataModelFromJson(json);
}

@freezed
class RefuelingRequestModel with _$RefuelingRequestModel {
  const factory RefuelingRequestModel({
    @JsonKey(name: 'vehicle_id') required String vehicleId,
    @JsonKey(name: 'station_id') required String stationId,
    @JsonKey(name: 'fuel_type') required String fuelType,
    @JsonKey(name: 'current_km') required int currentKm,
    @JsonKey(name: 'max_quantity') required double maxQuantity,
    @JsonKey(name: 'max_value') required double maxValue,
    @JsonKey(name: 'requires_arla') @Default(false) bool requiresArla,
    @JsonKey(name: 'notes') String? notes,
  }) = _RefuelingRequestModel;
  
  factory RefuelingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RefuelingRequestModelFromJson(json);
}
