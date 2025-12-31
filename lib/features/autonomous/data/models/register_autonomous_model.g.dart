// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_autonomous_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterAutonomousRequestImpl _$$RegisterAutonomousRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterAutonomousRequestImpl(
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      phone: json['phone'] as String,
      birthDate: json['birth_date'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String,
      termsAccepted: json['terms_accepted'] as bool,
      termsVersion: json['terms_version'] as String?,
    );

Map<String, dynamic> _$$RegisterAutonomousRequestImplToJson(
        _$RegisterAutonomousRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cpf': instance.cpf,
      'phone': instance.phone,
      'birth_date': instance.birthDate,
      'email': instance.email,
      'password': instance.password,
      'terms_accepted': instance.termsAccepted,
      'terms_version': instance.termsVersion,
    };

_$RegisterAutonomousResponseImpl _$$RegisterAutonomousResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterAutonomousResponseImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      accessToken: json['access_token'] as String,
    );

Map<String, dynamic> _$$RegisterAutonomousResponseImplToJson(
        _$RegisterAutonomousResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cpf': instance.cpf,
      'access_token': instance.accessToken,
    };

_$TermsVersionModelImpl _$$TermsVersionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TermsVersionModelImpl(
      id: json['id'] as String,
      version: json['version'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      isActive: json['is_active'] as bool? ?? true,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
    );

Map<String, dynamic> _$$TermsVersionModelImplToJson(
        _$TermsVersionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'title': instance.title,
      'content': instance.content,
      'type': instance.type,
      'is_active': instance.isActive,
      'published_at': instance.publishedAt?.toIso8601String(),
    };

_$CheckCpfResponseImpl _$$CheckCpfResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckCpfResponseImpl(
      exists: json['exists'] as bool,
    );

Map<String, dynamic> _$$CheckCpfResponseImplToJson(
        _$CheckCpfResponseImpl instance) =>
    <String, dynamic>{
      'exists': instance.exists,
    };
