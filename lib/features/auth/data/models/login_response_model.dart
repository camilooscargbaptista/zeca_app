import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// Modelo para a resposta completa de login do backend
/// Inclui tokens OAuth e dados do usuário
@freezed
class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    required LoginUserModel user,
    @JsonKey(name: 'available_companies') @Default([]) List<LoginCompanyModel> availableCompanies,
  }) = _LoginResponseModel;
  
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}

/// Modelo do usuário na resposta de login
@freezed
class LoginUserModel with _$LoginUserModel {
  const factory LoginUserModel({
    required String id,
    required String name,
    String? username,
    String? email,
    String? cpf,
    String? phone,
    String? role,
    String? profile,
    required LoginCompanyModel company,
  }) = _LoginUserModel;
  
  factory LoginUserModel.fromJson(Map<String, dynamic> json) =>
      _$LoginUserModelFromJson(json);
}

/// Modelo da empresa na resposta de login
@freezed
class LoginCompanyModel with _$LoginCompanyModel {
  const factory LoginCompanyModel({
    required String id,
    required String name,
    String? cnpj,
    String? type,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
  }) = _LoginCompanyModel;
  
  factory LoginCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$LoginCompanyModelFromJson(json);
}
