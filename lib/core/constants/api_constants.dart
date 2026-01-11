class ApiConstants {
  // OAuth Endpoints
  static const String oauthToken = '/oauth/token';
  static const String oauthRevoke = '/oauth/revoke';
  static const String oauthUserInfo = '/oauth/userinfo';
  
  // Auth (legacy - manter para compatibilidade)
  static const String login = '/api/v1/auth/login';
  static const String logout = '/api/v1/auth/logout';
  static const String refreshToken = '/api/v1/auth/refresh';
  
  // Company/Enterprise
  static const String companyInfo = '/api/v1/company/info';
  static const String companyVehicles = '/api/v1/company/vehicles';
  static const String companyFuelStations = '/api/v1/company/fuel-stations';
  static const String companyUsers = '/api/v1/company/users';
  
  // Vehicles
  static const String vehicles = '/api/v1/vehicles';
  static const String searchVehicle = '/api/v1/vehicles/search';
  static const String validateVehicle = '/api/v1/vehicles/validate';
  static const String vehicleHistory = '/api/v1/vehicles/{id}/history';
  
  // Fuel Stations
  static const String fuelStations = '/api/v1/fuel-stations';
  static const String validateStation = '/api/v1/fuel-stations/validate';
  static const String stationPrices = '/api/v1/fuel-stations/{id}/prices';
  static const String nearbyStations = '/companies/stations/nearby';
  
  // Fuel Types
  static const String fuelTypes = '/api/v1/fuel-types';
  static const String fuelPrices = '/api/v1/fuel-prices';
  
  // Refueling
  static const String refuelingCodes = '/api/v1/codes';
  static const String generateCode = '/api/v1/refueling/generate-code';
  static const String uploadDocument = '/api/v1/refueling/upload-document';
  static const String finalizeRefueling = '/api/v1/refueling/finalize';
  static const String cancelCode = '/api/v1/refueling/cancel';
  static const String refuelingHistory = '/api/v1/refueling/history';
  static const String refuelingStatus = '/api/v1/refueling/{id}/status';
  
  // Documents
  static const String documents = '/api/v1/documents';
  static const String uploadFile = '/api/v1/documents/upload';
  static const String deleteDocument = '/api/v1/documents/{id}';
  
  // Notifications
  static const String notifications = '/api/v1/notifications';
  static const String notificationSettings = '/api/v1/notifications/settings';
  static const String notificationTemplates = '/api/v1/notifications/templates';
  static const String deviceTokens = '/api/v1/notifications/device-tokens';
  static const String sendNotification = '/api/v1/notifications/send';
  static const String markNotificationRead = '/api/v1/notifications/{id}/read';
  
  // User Profile
  static const String userProfile = '/api/v1/user/profile';
  static const String updateProfile = '/api/v1/user/profile';
  static const String userPreferences = '/api/v1/user/preferences';
  
  // Reports
  static const String reports = '/api/v1/reports';
  static const String consumptionReport = '/api/v1/reports/consumption';
  static const String costReport = '/api/v1/reports/cost';
  
  // System
  static const String healthCheck = '/api/v1/health';
  static const String appConfig = '/api/v1/config';
  static const String appVersion = '/api/v1/version';
}
