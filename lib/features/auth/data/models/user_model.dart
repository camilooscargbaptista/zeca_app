import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';
import 'oauth_user_info_model.dart';
import 'login_response_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();
  
  const factory UserModel({
    required String id,
    required String name,
    required String cpf,
    String? email,
    String? phone,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'company_cnpj') String? companyCnpj,
    @JsonKey(name: 'company_type') String? companyType,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
    @JsonKey(name: 'roles') @Default([]) List<String> roles,
    @JsonKey(name: 'permissions') @Default([]) List<String> permissions,
    @JsonKey(name: 'email_verified') @Default(false) bool emailVerified,
    @JsonKey(name: 'phone_verified') @Default(false) bool phoneVerified,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'profile') UserProfileModel? profile,
    @JsonKey(name: 'preferences') UserPreferencesModel? preferences,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  // Converter para Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      nome: name,
      cpf: cpf,
      empresaId: companyId,
      empresaNome: companyName,
      empresaTipo: companyType,
      email: email,
      telefone: phone,
      ultimoLogin: lastLogin,
    );
  }
  
  // Criar a partir de Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.nome,
      cpf: entity.cpf,
      companyId: entity.empresaId,
      companyName: entity.empresaNome,
      email: entity.email,
      phone: entity.telefone,
      lastLogin: entity.ultimoLogin,
    );
  }
  
  // Criar a partir de OAuth User Info
  factory UserModel.fromOAuthUserInfo(OAuthUserInfoModel oauthUser) {
    return UserModel(
      id: oauthUser.sub,
      name: oauthUser.name,
      cpf: oauthUser.cpf,
      companyId: oauthUser.companyId,
      companyName: oauthUser.companyName,
      companyCnpj: oauthUser.companyCnpj,
      companyType: oauthUser.companyType,
      email: oauthUser.email,
      phone: oauthUser.phoneNumber,
      lastLogin: oauthUser.lastLogin,
      roles: oauthUser.roles,
      permissions: oauthUser.permissions,
      emailVerified: oauthUser.emailVerified,
      phoneVerified: oauthUser.phoneVerified,
    );
  }
  
  // Criar a partir da resposta de login (sem precisar chamar /oauth/userinfo)
  factory UserModel.fromLoginResponse(LoginUserModel loginUser) {
    return UserModel(
      id: loginUser.id,
      name: loginUser.name,
      cpf: loginUser.cpf ?? '',
      companyId: loginUser.company.id,
      companyName: loginUser.company.name,
      companyCnpj: loginUser.company.cnpj,
      companyType: loginUser.company.type,
      email: loginUser.email,
      phone: loginUser.phone,
    );
  }
}

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'gender') String? gender,
    @JsonKey(name: 'address') UserAddressModel? address,
    @JsonKey(name: 'emergency_contact') EmergencyContactModel? emergencyContact,
  }) = _UserProfileModel;
  
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

@freezed
class UserAddressModel with _$UserAddressModel {
  const factory UserAddressModel({
    required String street,
    required String number,
    String? complement,
    required String neighborhood,
    required String city,
    required String state,
    required String zipCode,
    String? country,
  }) = _UserAddressModel;
  
  factory UserAddressModel.fromJson(Map<String, dynamic> json) =>
      _$UserAddressModelFromJson(json);
}

@freezed
class EmergencyContactModel with _$EmergencyContactModel {
  const factory EmergencyContactModel({
    required String name,
    required String phone,
    String? relationship,
  }) = _EmergencyContactModel;
  
  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactModelFromJson(json);
}

@freezed
class UserPreferencesModel with _$UserPreferencesModel {
  const factory UserPreferencesModel({
    @JsonKey(name: 'theme') @Default('light') String theme,
    @JsonKey(name: 'language') @Default('pt_BR') String language,
    @JsonKey(name: 'notifications') NotificationPreferencesModel? notifications,
    @JsonKey(name: 'privacy') PrivacyPreferencesModel? privacy,
  }) = _UserPreferencesModel;
  
  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesModelFromJson(json);
}

@freezed
class NotificationPreferencesModel with _$NotificationPreferencesModel {
  const factory NotificationPreferencesModel({
    @JsonKey(name: 'push_enabled') @Default(true) bool pushEnabled,
    @JsonKey(name: 'email_enabled') @Default(true) bool emailEnabled,
    @JsonKey(name: 'sms_enabled') @Default(false) bool smsEnabled,
    @JsonKey(name: 'refueling_alerts') @Default(true) bool refuelingAlerts,
    @JsonKey(name: 'budget_alerts') @Default(true) bool budgetAlerts,
    @JsonKey(name: 'maintenance_alerts') @Default(true) bool maintenanceAlerts,
  }) = _NotificationPreferencesModel;
  
  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesModelFromJson(json);
}

@freezed
class PrivacyPreferencesModel with _$PrivacyPreferencesModel {
  const factory PrivacyPreferencesModel({
    @JsonKey(name: 'location_sharing') @Default(false) bool locationSharing,
    @JsonKey(name: 'data_analytics') @Default(true) bool dataAnalytics,
    @JsonKey(name: 'marketing_emails') @Default(false) bool marketingEmails,
  }) = _PrivacyPreferencesModel;
  
  factory PrivacyPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyPreferencesModelFromJson(json);
}
