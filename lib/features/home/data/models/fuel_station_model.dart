import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/fuel_station_entity.dart';

part 'fuel_station_model.freezed.dart';
part 'fuel_station_model.g.dart';

@freezed
class FuelStationModel with _$FuelStationModel {
  const FuelStationModel._();
  
  const factory FuelStationModel({
    required String id,
    required String cnpj,
    @JsonKey(name: 'corporate_name') required String corporateName,
    @JsonKey(name: 'fantasy_name') required String fantasyName,
    required FuelStationAddressModel address,
    @JsonKey(name: 'is_partner') @Default(false) bool isPartner,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'prices') @Default({}) Map<String, double> prices,
    @JsonKey(name: 'last_price_update') DateTime? lastPriceUpdate,
    @JsonKey(name: 'contact_info') FuelStationContactModel? contactInfo,
    @JsonKey(name: 'services') @Default([]) List<String> services,
    @JsonKey(name: 'payment_methods') @Default([]) List<String> paymentMethods,
    @JsonKey(name: 'rating') @Default(0.0) double rating,
    @JsonKey(name: 'distance_km') double? distanceKm,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _FuelStationModel;
  
  factory FuelStationModel.fromJson(Map<String, dynamic> json) =>
      _$FuelStationModelFromJson(json);

  FuelStationEntity toEntity() {
    return FuelStationEntity(
      id: id,
      cnpj: cnpj,
      razaoSocial: corporateName,
      nomeFantasia: fantasyName,
      endereco: address.toEntity(),
      conveniado: isPartner,
      precos: prices,
      servicos: services,
      formasPagamento: paymentMethods,
      contato: contactInfo?.toEntity(),
      avaliacao: rating > 0 ? rating : null,
      distanciaKm: distanceKm,
      tempoEstimadoMin: null, // Será calculado pelo repository
      horarioFuncionamento: null, // Não disponível no modelo atual
      ativo: isActive,
      precosAtualizados: lastPriceUpdate,
    );
  }
}

@freezed
class FuelStationAddressModel with _$FuelStationAddressModel {
  const FuelStationAddressModel._();
  
  const factory FuelStationAddressModel({
    required String street,
    required String number,
    String? complement,
    required String neighborhood,
    required String city,
    required String state,
    required String zipCode,
    String? country,
    @JsonKey(name: 'latitude') double? latitude,
    @JsonKey(name: 'longitude') double? longitude,
  }) = _FuelStationAddressModel;
  
  factory FuelStationAddressModel.fromJson(Map<String, dynamic> json) =>
      _$FuelStationAddressModelFromJson(json);

  FuelStationAddressEntity toEntity() {
    return FuelStationAddressEntity(
      logradouro: street,
      numero: number,
      complemento: complement,
      bairro: neighborhood,
      cidade: city,
      uf: state,
      cep: zipCode,
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
    );
  }
}

@freezed
class FuelStationContactModel with _$FuelStationContactModel {
  const FuelStationContactModel._();
  
  const factory FuelStationContactModel({
    String? phone,
    String? email,
    String? website,
    @JsonKey(name: 'manager_name') String? managerName,
    @JsonKey(name: 'manager_phone') String? managerPhone,
  }) = _FuelStationContactModel;
  
  factory FuelStationContactModel.fromJson(Map<String, dynamic> json) =>
      _$FuelStationContactModelFromJson(json);

  FuelStationContactEntity? toEntity() {
    if (phone == null && email == null) {
      return null;
    }
    return FuelStationContactEntity(
      telefone: phone,
      email: email,
    );
  }
}
