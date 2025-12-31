// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      companyId: json['company_id'] as String,
      companyName: json['company_name'] as String,
      companyCnpj: json['company_cnpj'] as String?,
      companyType: json['company_type'] as String?,
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      emailVerified: json['email_verified'] as bool? ?? false,
      phoneVerified: json['phone_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      profile: json['profile'] == null
          ? null
          : UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
      preferences: json['preferences'] == null
          ? null
          : UserPreferencesModel.fromJson(
              json['preferences'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cpf': instance.cpf,
      'email': instance.email,
      'phone': instance.phone,
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'company_cnpj': instance.companyCnpj,
      'company_type': instance.companyType,
      'last_login': instance.lastLogin?.toIso8601String(),
      'roles': instance.roles,
      'permissions': instance.permissions,
      'email_verified': instance.emailVerified,
      'phone_verified': instance.phoneVerified,
      'is_active': instance.isActive,
      'profile': instance.profile,
      'preferences': instance.preferences,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String?,
      address: json['address'] == null
          ? null
          : UserAddressModel.fromJson(json['address'] as Map<String, dynamic>),
      emergencyContact: json['emergency_contact'] == null
          ? null
          : EmergencyContactModel.fromJson(
              json['emergency_contact'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
      'birth_date': instance.birthDate?.toIso8601String(),
      'gender': instance.gender,
      'address': instance.address,
      'emergency_contact': instance.emergencyContact,
    };

_$UserAddressModelImpl _$$UserAddressModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserAddressModelImpl(
      street: json['street'] as String,
      number: json['number'] as String,
      complement: json['complement'] as String?,
      neighborhood: json['neighborhood'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$$UserAddressModelImplToJson(
        _$UserAddressModelImpl instance) =>
    <String, dynamic>{
      'street': instance.street,
      'number': instance.number,
      'complement': instance.complement,
      'neighborhood': instance.neighborhood,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'country': instance.country,
    };

_$EmergencyContactModelImpl _$$EmergencyContactModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EmergencyContactModelImpl(
      name: json['name'] as String,
      phone: json['phone'] as String,
      relationship: json['relationship'] as String?,
    );

Map<String, dynamic> _$$EmergencyContactModelImplToJson(
        _$EmergencyContactModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'relationship': instance.relationship,
    };

_$UserPreferencesModelImpl _$$UserPreferencesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferencesModelImpl(
      theme: json['theme'] as String? ?? 'light',
      language: json['language'] as String? ?? 'pt_BR',
      notifications: json['notifications'] == null
          ? null
          : NotificationPreferencesModel.fromJson(
              json['notifications'] as Map<String, dynamic>),
      privacy: json['privacy'] == null
          ? null
          : PrivacyPreferencesModel.fromJson(
              json['privacy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserPreferencesModelImplToJson(
        _$UserPreferencesModelImpl instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'language': instance.language,
      'notifications': instance.notifications,
      'privacy': instance.privacy,
    };

_$NotificationPreferencesModelImpl _$$NotificationPreferencesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationPreferencesModelImpl(
      pushEnabled: json['push_enabled'] as bool? ?? true,
      emailEnabled: json['email_enabled'] as bool? ?? true,
      smsEnabled: json['sms_enabled'] as bool? ?? false,
      refuelingAlerts: json['refueling_alerts'] as bool? ?? true,
      budgetAlerts: json['budget_alerts'] as bool? ?? true,
      maintenanceAlerts: json['maintenance_alerts'] as bool? ?? true,
    );

Map<String, dynamic> _$$NotificationPreferencesModelImplToJson(
        _$NotificationPreferencesModelImpl instance) =>
    <String, dynamic>{
      'push_enabled': instance.pushEnabled,
      'email_enabled': instance.emailEnabled,
      'sms_enabled': instance.smsEnabled,
      'refueling_alerts': instance.refuelingAlerts,
      'budget_alerts': instance.budgetAlerts,
      'maintenance_alerts': instance.maintenanceAlerts,
    };

_$PrivacyPreferencesModelImpl _$$PrivacyPreferencesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PrivacyPreferencesModelImpl(
      locationSharing: json['location_sharing'] as bool? ?? false,
      dataAnalytics: json['data_analytics'] as bool? ?? true,
      marketingEmails: json['marketing_emails'] as bool? ?? false,
    );

Map<String, dynamic> _$$PrivacyPreferencesModelImplToJson(
        _$PrivacyPreferencesModelImpl instance) =>
    <String, dynamic>{
      'location_sharing': instance.locationSharing,
      'data_analytics': instance.dataAnalytics,
      'marketing_emails': instance.marketingEmails,
    };
