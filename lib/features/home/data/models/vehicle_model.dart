import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/vehicle_entity.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

@freezed
class VehicleModel with _$VehicleModel {
  const VehicleModel._();
  
  const factory VehicleModel({
    required String id,
    required String plate,
    required String model,
    required String brand,
    required int year,
    required String color,
    @JsonKey(name: 'fuel_types') @Default([]) List<String> fuelTypes,
    @JsonKey(name: 'last_km') required int lastKm,
    @JsonKey(name: 'last_refueling') DateTime? lastRefueling,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    VehicleSpecsModel? specs,
    VehicleInsuranceModel? insurance,
  }) = _VehicleModel;
  
  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  VehicleEntity toEntity() {
    return VehicleEntity(
      id: id,
      placa: plate,
      modelo: model,
      marca: brand,
      ano: year,
      cor: color,
      combustiveis: fuelTypes,
      ultimoKm: lastKm,
      ultimoAbastecimento: lastRefueling,
      especificacoes: specs?.toEntity() ?? const VehicleSpecsEntity(capacidadeTanque: 0),
      seguro: insurance?.toEntity(),
      empresaId: companyId,
      empresaNome: '', // Será preenchido pelo repository
      ativo: isActive,
      criadoEm: createdAt ?? DateTime.now(),
    );
  }
}

@freezed
class VehicleSpecsModel with _$VehicleSpecsModel {
  const VehicleSpecsModel._();
  
  const factory VehicleSpecsModel({
    @JsonKey(name: 'engine_size') String? engineSize,
    @JsonKey(name: 'fuel_capacity') double? fuelCapacity,
    @JsonKey(name: 'consumption_city') double? consumptionCity,
    @JsonKey(name: 'consumption_highway') double? consumptionHighway,
    @JsonKey(name: 'transmission') String? transmission,
    @JsonKey(name: 'fuel_system') String? fuelSystem,
  }) = _VehicleSpecsModel;
  
  factory VehicleSpecsModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleSpecsModelFromJson(json);

  VehicleSpecsEntity toEntity() {
    return VehicleSpecsEntity(
      capacidadeTanque: fuelCapacity ?? 0,
      consumoMedio: consumptionCity,
      transmissao: transmission,
      eixos: null, // Não disponível no modelo atual
      pesoBruto: null, // Não disponível no modelo atual
    );
  }
}

@freezed
class VehicleInsuranceModel with _$VehicleInsuranceModel {
  const VehicleInsuranceModel._();
  
  const factory VehicleInsuranceModel({
    @JsonKey(name: 'insurance_company') String? insuranceCompany,
    @JsonKey(name: 'policy_number') String? policyNumber,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'coverage_type') String? coverageType,
  }) = _VehicleInsuranceModel;
  
  factory VehicleInsuranceModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleInsuranceModelFromJson(json);

  VehicleInsuranceEntity? toEntity() {
    if (insuranceCompany == null || policyNumber == null || expiresAt == null) {
      return null;
    }
    return VehicleInsuranceEntity(
      seguradora: insuranceCompany!,
      apolice: policyNumber!,
      vencimento: expiresAt!,
    );
  }
}
