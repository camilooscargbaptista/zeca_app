class AppConstants {
  // App Info
  static const String appName = 'ZECA';
  static const String appVersion = '1.0.0';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // QR Code
  static const int qrCodeSize = 200;
  static const Duration qrCodeValidity = Duration(hours: 2);
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxRetryAttempts = 3;
}
