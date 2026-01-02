// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseModelImpl _$$LoginResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LoginResponseModelImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: LoginUserModel.fromJson(json['user'] as Map<String, dynamic>),
      availableCompanies: (json['available_companies'] as List<dynamic>?)
              ?.map(
                  (e) => LoginCompanyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$LoginResponseModelImplToJson(
        _$LoginResponseModelImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user,
      'available_companies': instance.availableCompanies,
    };

_$LoginUserModelImpl _$$LoginUserModelImplFromJson(Map<String, dynamic> json) =>
    _$LoginUserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String?,
      email: json['email'] as String?,
      cpf: json['cpf'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      profile: json['profile'] as String?,
      company:
          LoginCompanyModel.fromJson(json['company'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LoginUserModelImplToJson(
        _$LoginUserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'cpf': instance.cpf,
      'phone': instance.phone,
      'role': instance.role,
      'profile': instance.profile,
      'company': instance.company,
    };

_$LoginCompanyModelImpl _$$LoginCompanyModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LoginCompanyModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      cnpj: json['cnpj'] as String?,
      type: json['type'] as String?,
      isPrimary: json['is_primary'] as bool? ?? false,
    );

Map<String, dynamic> _$$LoginCompanyModelImplToJson(
        _$LoginCompanyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cnpj': instance.cnpj,
      'type': instance.type,
      'is_primary': instance.isPrimary,
    };
