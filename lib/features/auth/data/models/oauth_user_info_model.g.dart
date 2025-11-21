// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OAuthUserInfoModelImpl _$$OAuthUserInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OAuthUserInfoModelImpl(
      sub: json['sub'] as String,
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      companyId: json['company_id'] as String,
      companyName: json['company_name'] as String,
      companyCnpj: json['company_cnpj'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      emailVerified: json['email_verified'] as bool? ?? false,
      phoneVerified: json['phone_verified'] as bool? ?? false,
    );

Map<String, dynamic> _$$OAuthUserInfoModelImplToJson(
        _$OAuthUserInfoModelImpl instance) =>
    <String, dynamic>{
      'sub': instance.sub,
      'name': instance.name,
      'cpf': instance.cpf,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'company_cnpj': instance.companyCnpj,
      'roles': instance.roles,
      'permissions': instance.permissions,
      'last_login': instance.lastLogin?.toIso8601String(),
      'email_verified': instance.emailVerified,
      'phone_verified': instance.phoneVerified,
    };
