// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyModelImpl _$$CompanyModelImplFromJson(Map<String, dynamic> json) =>
    _$CompanyModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      cnpj: json['cnpj'] as String,
      fantasyName: json['fantasyName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] == null
          ? null
          : CompanyAddressModel.fromJson(
              json['address'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      settings: json['settings'] == null
          ? null
          : CompanySettingsModel.fromJson(
              json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CompanyModelImplToJson(_$CompanyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cnpj': instance.cnpj,
      'fantasyName': instance.fantasyName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_active': instance.isActive,
      'settings': instance.settings,
    };

_$CompanyAddressModelImpl _$$CompanyAddressModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CompanyAddressModelImpl(
      street: json['street'] as String,
      number: json['number'] as String,
      complement: json['complement'] as String?,
      neighborhood: json['neighborhood'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$$CompanyAddressModelImplToJson(
        _$CompanyAddressModelImpl instance) =>
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

_$CompanySettingsModelImpl _$$CompanySettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CompanySettingsModelImpl(
      maxVehicles: (json['max_vehicles'] as num?)?.toInt() ?? 100,
      maxUsers: (json['max_users'] as num?)?.toInt() ?? 50,
      fuelBudgetLimit: (json['fuel_budget_limit'] as num?)?.toDouble(),
      requireApproval: json['require_approval'] as bool? ?? false,
      allowExternalStations: json['allow_external_stations'] as bool? ?? true,
      notificationSettings: json['notification_settings'] == null
          ? null
          : NotificationSettingsModel.fromJson(
              json['notification_settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CompanySettingsModelImplToJson(
        _$CompanySettingsModelImpl instance) =>
    <String, dynamic>{
      'max_vehicles': instance.maxVehicles,
      'max_users': instance.maxUsers,
      'fuel_budget_limit': instance.fuelBudgetLimit,
      'require_approval': instance.requireApproval,
      'allow_external_stations': instance.allowExternalStations,
      'notification_settings': instance.notificationSettings,
    };

_$NotificationSettingsModelImpl _$$NotificationSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsModelImpl(
      emailNotifications: json['email_notifications'] as bool? ?? true,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      smsNotifications: json['sms_notifications'] as bool? ?? false,
      refuelingAlerts: json['refueling_alerts'] as bool? ?? true,
      budgetAlerts: json['budget_alerts'] as bool? ?? true,
    );

Map<String, dynamic> _$$NotificationSettingsModelImplToJson(
        _$NotificationSettingsModelImpl instance) =>
    <String, dynamic>{
      'email_notifications': instance.emailNotifications,
      'push_notifications': instance.pushNotifications,
      'sms_notifications': instance.smsNotifications,
      'refueling_alerts': instance.refuelingAlerts,
      'budget_alerts': instance.budgetAlerts,
    };
