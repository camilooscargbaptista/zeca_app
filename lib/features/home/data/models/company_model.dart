import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

@freezed
class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    required String id,
    required String name,
    required String cnpj,
    String? fantasyName,
    String? email,
    String? phone,
    CompanyAddressModel? address,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'settings') CompanySettingsModel? settings,
  }) = _CompanyModel;
  
  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);
}

@freezed
class CompanyAddressModel with _$CompanyAddressModel {
  const factory CompanyAddressModel({
    required String street,
    required String number,
    String? complement,
    required String neighborhood,
    required String city,
    required String state,
    required String zipCode,
    String? country,
  }) = _CompanyAddressModel;
  
  factory CompanyAddressModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyAddressModelFromJson(json);
}

@freezed
class CompanySettingsModel with _$CompanySettingsModel {
  const factory CompanySettingsModel({
    @JsonKey(name: 'max_vehicles') @Default(100) int maxVehicles,
    @JsonKey(name: 'max_users') @Default(50) int maxUsers,
    @JsonKey(name: 'fuel_budget_limit') double? fuelBudgetLimit,
    @JsonKey(name: 'require_approval') @Default(false) bool requireApproval,
    @JsonKey(name: 'allow_external_stations') @Default(true) bool allowExternalStations,
    @JsonKey(name: 'notification_settings') NotificationSettingsModel? notificationSettings,
  }) = _CompanySettingsModel;
  
  factory CompanySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$CompanySettingsModelFromJson(json);
}

@freezed
class NotificationSettingsModel with _$NotificationSettingsModel {
  const factory NotificationSettingsModel({
    @JsonKey(name: 'email_notifications') @Default(true) bool emailNotifications,
    @JsonKey(name: 'push_notifications') @Default(true) bool pushNotifications,
    @JsonKey(name: 'sms_notifications') @Default(false) bool smsNotifications,
    @JsonKey(name: 'refueling_alerts') @Default(true) bool refuelingAlerts,
    @JsonKey(name: 'budget_alerts') @Default(true) bool budgetAlerts,
  }) = _NotificationSettingsModel;
  
  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);
}
